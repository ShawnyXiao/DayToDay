# 部署和运行智能合约

## 步骤

### 1. 启动私有链

1. ```geth --identity "Inplus Ethereum" --rpc --rpccorsdomain "*" --rpcapi "db,eth,net,web3" --rpcport "8545" --datadir "%cd%\chain" --port "30303" --networkid "95518" console```
2. 启动 Ethereum Wallet

### 2. 创建两个账户

1. 方法一：命令行 ```personal.newAccount()```
2. 方法二：图形界面 - ADD ACCOUNT

### 3. 通过挖矿获取以太币

1. ```miner.start(1)``` （参数 “1” 表示使用一个线程进行挖矿）
2. ```miner.stop()```

### 4. 将一个账户的以太币转到另一个账户中

1. 复制收钱账户的 address
2. 点击 SEND
3. 粘贴复制好的 address 到 TO 下的文本框中
4. 输入以太币的发送数量：100
5. 下拉滚动条
6. （可选）点击 SHOW MORE OPTIONS，可以为这笔交易附加一个 DATA 信息，会永久记录在区块上
7. （可选）选择发送费用，费用越高速度越快，只是用在公有链上
8. （可选）TOTAL 中显示的以太币就是需要消耗的以太币总量
9. 点击 SEND
10. 在弹出的对话框中，输入帐号密码
11. 此时，并没有发送成功，为什么？因为还没有矿工确认这笔交易（即挖矿），并且需要确认 12 次（即生成 12 个区块）。切到 Geth 控制台，输入挖矿命令。

### 5. 部署智能合约

1. 点击 CONTRACTS，进入智能合约管理界面
2. 点击 DEPLOY NEW CONTRACT
3. 在 FROM 下的文本框中，选择部署智能合约的账户
4. 在 SOLIDITY CONTRACT SOURCE CODE 下的文本框中，输入智能合约的代码
5. 在 SELECT CONTRACT TO DEPLOY 下的下拉框中，选择要部署的智能合约
6. 在弹出的对话框中，输入帐号密码
7. 需要确认 12 次（即生成 12 个区块）。切到 Geth 控制台，输入挖矿命令。

### 6. 运行智能合约

#### 在自己的 Geth 节点上运行

1. 点击 CONTRACTS，进入智能合约管理界面
2. 在 CUSTOM CONTRACTS 下，可以看到刚才部署的智能合约 SIMPLE STORAGE，点击进入该智能合约
3. 在 READ FROM CONTRACT 下的内容是智能合约的读取函数，在 WRITE TO CONTRACT 下的内容是智能合约的设置函数
4. 在 Select function 下的下拉框中选择 Set，并填入想要设置的值，点击 EXECUTE
5. 在弹出的对话框中，输入帐号密码
6. 需要确认 12 次（即生成 12 个区块）。切到 Geth 控制台，输入挖矿命令。

#### 在其他的 Geth 节点上运行

1. 通过 Copy address，拷贝智能合约的 ADDRESS
2. 通过 Show Interface，拷贝智能合约的 JSON 接口
3. 在另一个区块链节点打开 Ethereum Wallet，点击 CONTRACTS，点击 WATCH CONTRACTS
4. CONTRACT NAME 可任意填，CONTRACT ADDRESS 填入复制好的智能合约 ADDRESS，JSON INTERFACE 填入复制好的智能合约的 JSON 接口
5. 点击 OK

## 引用

- [区块链开发（二）部署和运行第一个以太坊智能合约 - 李赫的专栏 - 博客频道 - CSDN.NET](http://blog.csdn.net/sportshark/article/details/52249607)