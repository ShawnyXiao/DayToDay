# Solidity

## ...

## 合约的结构

Solidity 中的合约类似于面向对象语言中的类。每个合约可以包含状态变量（State Variables），函数（Functions），函数修饰符（Function Modifiers），事件（Events），结构类型（Structs Types）和枚举类型（Enum Types）。此外，合约可以继承其他合约。

### 状态变量（State Variables）

状态变量是永久存储在合约存储中的值。

```javascript
pragma solidity ^0.4.0;

contract SimpleStorage {
    uint storedData; // 状态变量
    // ...
}
```

请参阅“类型”部分以获取有效的状态变量类型，以及“可见性和 Getters”以查看可见性的可能选项。

### 函数（Functions）

函数是合约中代码的可执行单元。

```javascript
pragma solidity ^0.4.0;

contract SimpleAuction {
    function bid() payable { // 函数
        // ...
    }
}
```

函数调用可以在内部或外部发生，对其他合同具有不同级别的可见性（可见性和Getters）。

### 函数修饰符（Function Modifiers）

函数修饰符可以用于以声明方式修改函数的语义（详情参见合约中的函数修饰符部分）。

```javascript
pragma solidity ^0.4.0;

contract Purchase {
    address public seller;

    modifier onlySeller() { // 函数修饰符
        if (msg.sender != seller) throw;
        _;
    }

    function abort() onlySeller { // 使用函数修饰符
        // ...
    }
}
```

### 事件（Events）

事件是 EVM 日志记录工具的便利接口。

```javascript
pragma solidity ^0.4.0;

contract SimpleAuction {
    event HighestBidIncreased(address bidder, uint amount); // 事件

    function bid() payable {
        // ...
        HighestBidIncreased(msg.sender, msg.value); // 触发事件
    }
}
```

### 结构类型（Structs Types）

结构是可以对多个变量进行分组的自定义类型（请参阅类型中的结构部分）。

```javascript
pragma solidity ^0.4.0;

contract Ballot {
    struct Voter { // 结构
        uint weight;
        bool voted;
        address delegate;
        uint vote;
    }
}
```

### 枚举类型（Enum Types）

枚举可用于创建具有有限值集合的自定义类型（详情参阅“类型”部分中的枚举）。

```javascript
pragma solidity ^0.4.0;

contract Purchase {
    enum State { Created, Locked, Inactive } // 枚举
}
```

## ...

## 合约

### ...

### 事件

事件允许方便地使用 EVM 日志记录工具。它可以用于在一个 dapp 的用户界面中调用 JavaScript 回调函数，来监听这些事件。

事件是合约的可继承成员。当它们被调用时，它们使得参数被存储在事务的日志中，这里的日志是一种在区块链中的特殊数据结构。这些日志与合约的地址相关联，并且将被合并到区块链中，只要区块是可访问的（Frontier 和 Homestead 是永久可以访问的，但 Serenity 可能会改变）。无法在合约中访问日志和事件数据（甚至不能在创建日志的合约中访问）。

SPV 证明日志是可能的，所以如果一个外部实体为合约提供这样的证明，那么它可以检查日志实际上存在于区块链上（但是区块头也必须被提供，因为合约只能知道最新
的 256 个区块的哈希）。

最多三个参数可以接收 ```indexed``` 的属性，这使得可以搜索相应的参数：可以在用户界面中过滤索引参数的特定值。

如果数组（包括 ```string``` 和 ```bytes```）被用作索引参数，那么它的 Keccak-256 哈希值将作为 topic 被存储。

除非您使用 ```anonymous``` 修饰符声明事件，事件的签名的哈希是 topics 之一。这意味着不可能按名称过滤特定的匿名事件。

> 注意：
> 不会存储索引参数本身，你只能搜索值，但是不可能获取值本身。

```javascript
pragma solidity ^0.4.0;

contract ClientReceipt {
    event Deposit(
        address indexed _from,
        bytes32 indexed _id,
        uint _value
    );

    function deposit(bytes32 _id) {
        // 通过过滤“Deposit”，任何此函数的调用都可以被 JavaScript API 检测到。
        Deposit(msg.sender, _id, msg.value);
    }
}
```

在JavaScript API中的使用如下：

```javascript
var abi = /* abi 由编译器产生 */;
var ClientReceipt = web3.eth.contract(abi);
var clientReceipt = ClientReceipt.at(0x123 /* 地址 */);

var event = clientReceipt.Deposit();

// 监测变动
event.watch(function(error, result){
    // result 将会包含调用 Deposit 的参数信息等
    if (!error)
        console.log(result);
});

// 或者通过回调开始立即监测
var event = clientReceipt.Deposit(function(error, result) {
    if (!error)
        console.log(result);
});
```

#### 对日志的低级接口

还可以通过函数 ```log0```，```log1```，```log2```，```log3``` 和 ```log4``` 访问到日志机制的低级接口。```logi``` 需要 ```bytes32``` 类型的 ```i + 1``` 个参数，其中第一个参数将用于日志的数据部分，其他参数用作 topics。上面的事件调用可以以相同的方式执行，如下：

```javascript
log3(
    msg.value,
    0x50cb9fe53daa9737b786ab3646f04d0150dc50ef4e75f59509d83667ad5adb20,
    msg.sender,
    _id
);
```

其中的十六进制数等于 ```keccak256("Deposit(address, hash256, uint256)")```，即事件的签名。

#### 帮助了解事件的其他资源

- [Javascript documentation](https://github.com/ethereum/wiki/wiki/JavaScript-API#contract-events)
- [Example usage of events](https://github.com/ethchange/smart-exchange/blob/master/lib/contracts/SmartExchange.sol)
- [How to access them in js](https://github.com/ethchange/smart-exchange/blob/master/lib/exchange_transactions.js)

### 继承

通过复制包含多态性的代码，Solidity 支持多重继承。

所有函数调用都是虚拟的，这意味着调用了最新派生（most derived）的函数，除非显示地给出了合约名称。

即使合约继承自多个合约，在区块链上也只创建一个合约，来自基础合约的代码也总是被复制到最终合约中。

通用继承系统与 Python 非常相似，尤其是关于多重继承。

详细信息在以下示例中给出。

```javascript
pragma solidity ^0.4.0;

contract owned {
    function owned() { owner = msg.sender; }
    address owner;
}


// 使用“is”关键字继承另一个合约。派生合约
// 可以访问所有非私有成员，包括内部函数和
// 状态变量。这些不能通过“this”关键字从外
// 部访问。
contract mortal is owned {
    function kill() {
        if (msg.sender == owner) selfdestruct(owner);
    }
}


// 这些抽象合约只是为了让编译器知道提供了
// 这样的接口。注意函数没有主体。如果合约
// 不实现所有功能，它只能用作接口。
contract Config {
    function lookup(uint id) returns (address adr);
}


contract NameReg {
    function register(bytes32 name);
    function unregister();
 }


// 多继承是允许的。注意，“owned”也是“mortal”
// 的​​基类，但只有一个“owned”的实例（就像
// C++ 中的虚拟继承）。
contract named is owned, mortal {
    function named(bytes32 name) {
        Config config = Config(0xd5f9d8d94886e70b06e474c3fb14fd43e2f23970);
        NameReg(config.lookup(1)).register(name);
    }

    // 函数可以被具有相同名称和相同数量以及
    // 类型的输入的另一个函数覆盖。如果覆盖
    // 函数具有不同类型的输出参数，则会导致
    // 错误。本地和基于消息的函数调用都会考
    // 虑这些覆盖。
    function kill() {
        if (msg.sender == owner) {
            Config config = Config(0xd5f9d8d94886e70b06e474c3fb14fd43e2f23970);
            NameReg(config.lookup(1)).unregister();
            // It is still possible to call a specific
            // overridden function.
            mortal.kill();
        }
    }
}


// 如果构造函数接受一个参数，它需要在头部
// 中提供（或在派生合约的构造函数上使用修
// 饰符调用样式（见下文））。
contract PriceFeed is owned, mortal, named("GoldFeed") {
   function updateInfo(uint newInfo) {
      if (msg.sender == owner) info = newInfo;
   }

   function get() constant returns(uint r) { return info; }

   uint info;
}
```

注意上面，我们调用 ```mortal.kill()``` 来“转发”销毁请求。执行此操作的方法有问题，如以下示例所示：

```javascript
pragma solidity ^0.4.0;

contract mortal is owned {
    function kill() {
        if (msg.sender == owner) selfdestruct(owner);
    }
}


contract Base1 is mortal {
    function kill() { /* 销毁 1 */ mortal.kill(); }
}


contract Base2 is mortal {
    function kill() { /* 销毁 2 */ mortal.kill(); }
}


contract Final is Base1, Base2 {
}
```

调用 ```Final.kill()``` 将调用 ```Base2.kill``` 作为最新派生的覆盖，但是这个函数将绕过 ```Base1.kill```，原因是它根本不知道 ```Base1```。解决这个的方法是使用 ```super```：

```javascript
pragma solidity ^0.4.0;

contract mortal is owned {
    function kill() {
        if (msg.sender == owner) selfdestruct(owner);
    }
}


contract Base1 is mortal {
    function kill() { /* 销毁 1 */ super.kill(); }
}


contract Base2 is mortal {
    function kill() { /* 销毁 2 */ super.kill(); }
}


contract Final is Base2, Base1 {
}
```

如果 ```Base1``` 调用 ```super``` 关键字标识的函数，它不会简单地调用其继承的某一个基本合约这个函数，而是基于继承顺序调用下一个基本合约的这个函数，因此它将调用 ```Base2.kill()``` （从最新派生的合约开始，继承顺序是：Final，Base1，Base2，Mortal，owned）。使用 ```super``` 时调用的实际函数在使用它的类的上下文中是未知的，尽管它的类型是已知的。这与普通虚拟方法查找类似。

#### ...

### ...

## ...