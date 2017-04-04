# MySQL 技巧

今天知晓了一个 MySQL 的技巧：

```sql
INSERT IGNORE INOT
  person (id, name, sex)
VALUES
  (1, "Shawn", "male")
```

如果重复插入的话，```INSERT IGNORE``` 可以忽略错误，防止主键冲突导致的报错，在 MyBatis 中返回 0（表示没有行插入），方便业务逻辑的处理。

## 引用

- [基于myBatis实现DAO编程(下)-慕课网](http://www.imooc.com/video/11712)