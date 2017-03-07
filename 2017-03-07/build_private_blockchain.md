# 搭建基于以太坊的私有链

## 步骤

### 1. 安装 Windows 下的 Geth 客户端

1. https://github.com/ethereum/go-ethereum/releases/
2. https://github.com/ethereum/mist/releases/

### 2. 准备创世块文件

genesis.json:

```json
{
    "nonce": "0x0000000000000042",
    "mixhash": "0x0000000000000000000000000000000000000000000000000000000000000000",
    "difficulty": "0x4000",
    "alloc": {},
    "coinbase": "0x0000000000000000000000000000000000000000",
    "timestamp": "0x00",
    "parentHash": "0x0000000000000000000000000000000000000000000000000000000000000000",
    "extraData": "Inplus Genesis Block",
    "gasLimit": "0xffffffff"
}
```

### 3. 在 Windows 下启动 Geth 节点

1. ```geth --datadir "%cd%\chain" init genesis.json```
2. ```geth --identity "Inplus Ethereum" --rpc --rpccorsdomain "*" --datadir "%cd%\chain" --port "30303" --rpcapi "db,eth,net,web3" --networkid "95518" console```

### 4. 在 Geth 节点下创建账号

```
personal.newAccount()
```

### 5. 在 Windows 下启动图形界面

运行 Ethereum Wallet，右上角会显示“PRIVATE-NET”

### 6. 连接以太坊网络的其他节点

1. 每个节点查询自己的节点信息，通过命令 ```admin.nodeInfo```，其中 ```enode://35a05a84f88bec7e4a5a43b3b7970afa5442d584bdbe14e1d4df1906a65e6c1fb8c04069c7c2099b99393b00f08cf5c3e7d10de022ec8fc654bacbe8d1b913e7@192.168.0.107:30303``` 就是自己节点的信息，后面的 “192.168.0.107” 需要改成自己的 IP
2. 在自己节点中添加别人的节点：```admin.addPeer(‘enode://35a05a84f88bec7e4a5a43b3b7970afa5442d584bdbe14e1d4df1906a65e6c1fb8c04069c7c2099b99393b00f08cf5c3e7d10de022ec8fc654bacbe8d1b913e7@192.168.0.107:30303’)```
3. 通过命令 ```admin.peers``` 查询是否添加成功

### 7. 挖矿

- ```miner.start()```
- ```miner.stop()```

## 引用

- [区块链开发（一）搭建基于以太坊的私有链环境 - 李赫的专栏 - 博客频道 - CSDN.NET](http://blog.csdn.net/sportshark/article/details/51855007)
- [以太坊连载（17）：搭建测试网络和私有链 - 汪晓明对区块链、以太坊的思考](http://wangxiaoming.com/blog/2016/07/08/e17/)
- [明说(01)：从0开始搭建区块链开发环境 - 汪晓明对区块链、以太坊的思考](http://wangxiaoming.com/blog/2016/09/06/ming-shuo-1/)