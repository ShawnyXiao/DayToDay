# Pandas

## 导入 Pandas、NumPy、Matplotlib

```
import pandas as pd
import numpy as np
import matplotlib.pyplot as plt
```

## 创建对象

1. 传递一个值的列表，创建一个默认整型索引的 Series
	```
	s = pd.Series([1, 2, 4, np.nan, 6, 8])
	```
2. 传递一个 numpy 数组（即矩阵），创建一个 datetime 索引的、字母标记列的 DataFrame
	```
	df = pd.DataFrame(np.random.randn(6 4), index=pd.date_range('20130101', periods=6), columns=list('ABCD'))
	```
3. 传递一个 dict，创建一个 DataFrame（dict 中的每个元素会自动转化成一个 Series）
	```
	df2 = pd.DataFrame({'A': 1.,
		'B': pd.Timestamp('20130102'),
		'C': pd.Series(1, index=list(range(4)), dtype='float32'),
		'D': np.array([3] * 4, dtype='int32'),
		'E': pd.Categorical(['test', 'train', 'test','train']),
		'F': 'foo'})
	```
	每列的格式用 dtypes 查看：
	```
	df2.dtypes
	```

## 查看数据

1. 查看顶端和底端的几行
	```
	df.head()
	df.tail(3)
	```
2. 查看 index、columns 和 其内部的 numpy 数据（即：values）
	```
	df.index
	df.columns
	df.values
	```
3. 查看数据的统计，包括计数、均值、标准差、最小值和最大值等等
	```
	df.describe()
	```
4. 转置
	```
	df.T
	```
5. 对 axis 排序（axis=1 是指第二个维度）
	```
	df.sort_index(axis=1, ascending=False)
	```
6. 对 values 排序
	```
	df.sort_values(by='B')
	```

## 选择

### 获取行或列

1. 选择一列（即：得到一个 Series）
	```
	df['A']
	df.A
	```
2. 选择行，通过 ```[]``` 可进行切片选择
	```
	df[0:3] # 不包括 3
	df['20130102':'20130104'] # 包括 '20130104'
	```

### 通过 Label 选择

1. 通过 Label 获取一个 Series
	```
	df.loc['20130102']
	```
2. 通过 Label 获取多轴的数据
	```
	df.loc[:, ['A', 'B']]
	```
3. 通过 Label 进行切片选择
	```
	df.loc['20130101':'20130103', ['A', 'B']]
	```
4. 通过 Label 选择标量值
	```
	df.loc['20130101', 'A']
	```
5. 对于选择标量值，使用 ```at()``` 能更快
	```
	df.at['20130101', 'A']
	```

### 通过 Position 选择

1. 通过整数的 Position 选择
	```
	df.iloc[3]
	```
2. 通过整数切片的 Position 选择
	```
	df.iloc[3:5, 0:2]
	```
3. 通过整数数组的 Position 选择
	```
	df.iloc[[1, 2, 4], [2, 3]]
	```
4. 对行切片选择
	```
	df.iloc[1:4, :]
	```
5. 对列切片选择
	```
	df.iloc[:, 1:3]
	```
6. 通过 Position 选择标量值
	```
	df.iloc[3, 2]
	```
7. 对于选择标量值，使用 ```iat()``` 能更快
	```
	df.iat[3, 2]
	```

### 通过布尔值索引选择

1. 通过一个布尔值 Series 选择
	```
	df[df.A > 0]
	```
2. 通过一个布尔值 DataFrame 选择
	```
	df[df > 0]
	```
3. 使用 isin() 方法过滤
	```
	df2[df2.E.isin(['two', 'four'])]
	```

## 设置

1. 为 DataFrame 增加新的列
	```
	df['F'] = pd.Series([1, 2, 3, 4, 5, 6], index=pd.date_range('20130101', periods=6))
	```
2. 通过 Label 设置值
	```
	df.at['20130101', 'A'] = 0
	```
3. 通过 Position 设置值
	```
	df.iat[0, 1] = 1
	```
4. 通过一个 numpy 数组设置
	```
	df.loc[:, 'D'] = np.array([5] * len(df))
	```
5. 通过布尔值索引设置
	```
	df2[df2 > 0] = -df2
	```

### 缺失值

pandas 用 np.nan 表示缺失值。通常它不会被计算。

1. ```reindex()``` 允许你改变/删除/新增某个轴的 index
	```
	df1 = df.reindex(index=pd.date_range('20130101', periods=6), columns=list(df.columns) + ['E'])
	df1.loc['20130101':'20130102', 'E'] = 1
	```
2. 丢弃有缺失值的行
	```
	df1.dropna(how='any')
	```
3. 填充所有缺失值
	```
	df1.fillna(value=5)
	```
4. 获取布尔值索引，是缺失值的位置返回 True，其他返回 False
	```
	pd.isnull(df1)
	```

## 操作

### 统计

1. 对列求平均值
	```
	df.mean()
	```
2. 对行求平均值
	```
	df.mean(1)
	```
3. 操作不同维度的对象需要对齐。另外，pandas 会沿着指定的维度自动广播操作
	```
	s = pd.Series([1, 2, 3, np.nan, 6, 7], index=pd.date_range('20130101', periods=6)).shift(2)
	df.sub(s, axis='index')
	```

### Apply

对数据应用指定函数

```
df.apply(np.cumsum)
df.apply(lambda x: x.max() - x.min())
```

### 直方图

```
s = pd.Series(np.random.randint(0, 7,size=10))
s.value_counts()
```

### 字符串方法

Series 自带了很多字符串处理函数，在 str 属性中

```
s = pd.Series(['A', 'B', 'C', 'Aaba', 'Baca', np.nan, 'CABA', 'dog', 'cat'])
s.str.lower()\
```

## 合并

### Concat

```
df = pd.DataFrame(np.random.randn(10, 4))
pieces = [df[:3], df[3:7], df[7:]] # 拆分
pd.concate(pieces)
```

### Join

SQL 类型的合并，和全连接（笛卡尔积）类似

```
left = pd.DataFrame({'key': ['foo', 'foo', 'foo'], 'lval': [1, 2, 3]})
right = pd.DataFrame({'key': ['foo', 'foo'], 'rval': [4, 5]})
pd.merge(left, right, on='key')

# 输出
#    key  lval  rval
# 0  foo     1     4
# 1  foo     1     5
# 2  foo     2     4
# 3  foo     2     5
# 4  foo     3     4
# 5  foo     3     5
```

```
left = pd.DataFrame({'key': ['foo', 'bar'], 'lval': [1, 2]})
right = pd.DataFrame({'key': ['foo', 'bar'], 'rval': [4, 5]})
pd.merge(left, right, on='key')

# 输出
#    key  lval  rval
# 0  foo     1     4
# 1  bar     2     5
```

### Append

向 DataFrame 追加新的行

```
df = pd.DataFrame(np.random.randn(8, 4), columns=['A','B','C','D'])
df.append(df.iloc[3], ignore_index=True)
```

## Grouping

和 SQL 中的 GROUP BY 类似，包括以下这几步：

- 根据某些规则，把数据分组
- 对每组应用一个聚集函数，把结果放在一个数据结构中

1. 对一列进行分组，然后应用 ```sum()```
	```
	df = pd.DataFrame({'A' : ['foo', 'bar', 'foo', 'bar', 'foo', 'bar', 'foo', 'foo'], 'B' : ['one', 'one', 'two', 'three', 'two', 'two', 'one', 'three'], 'C' : np.random.randn(8), 'D' : np.random.randn(8)})
	df.groupby('A').sum()
	```
2. 对多列进行分组
	```
	df.groupby(['A', 'B']).sum()
	```

## Reshaping

1. ```stack()``` 将多列压缩成一列
	```
	tuples = list(zip(*[['bar', 'bar', 'baz', 'baz', 'foo', 'foo', 'qux', 'qux'], ['one', 'two', 'one', 'two', 'one', 'two', 'one', 'two']]))
	index = pd.MultiIndex.from_tuples(tulples, names=['first', 'second'])
	df = pd.DataFrame(np.random.randn(8, 2), index=index, columns=['A', 'B'])
	df2 = df[:4]
	stacked = df2.stack()
	```
2. ```unstack()``` 将压缩后的一列还原成多列（默认还原 MultiIndex 的最后一列）
	```
	stacked.unstack()
	stacked.unstack(1)
	stacked.unstack(0)
	```
### Pivot Tables

利用现有的 DataFrame 中的数据构建新的 DataFrame，pivot 是把原来的数据作为行和列

```
df = pd.DataFrame({'A' : ['one', 'one', 'two', 'three'] * 3, 'B' : ['A', 'B', 'C'] * 4, 'C' : ['foo', 'foo', 'foo', 'bar', 'bar', 'bar'] * 2, 'D' : np.random.randn(12), 'E' : np.random.randn(12)})
pd.pivot_table(df, values='D', index=['A', 'B'], columns=['C'])
```

## Time Series

1. 重采样
	```
	rng = pd.date_range('1/1/2012', periods=100, freq='S')
	ts = pd.Series(np.random.randint(0, 500, len(rng)), index=rng)
	ts.resample('5Min').sum()
	```
2. 时区表示
	```
	rng = pda.date_range('3/6/2012 00:00', periods=5, freq='D')
	ts = pd.Series(np.random.randn(len(rng)), rng)
	ts_utc = ts.tz_localize('UTC')
	```
3. 时区转换
	```
	ts_utc.tz_convert('US/Eastern')
	```
4. 从 Timestamp index 转换成 TimePeriod index
	```
	rng = pd.date_range('1/1/2012', periods=5, freq='M')
	ts = pd.Series(np.random.randn(len(rng)), index=rng)
	ps = ts.to_period()
	ps.to_timestamp()
	```

## Categoricals

1. 把文本类型的 raw_grade 转化成类别
	```
	df = pd.DataFrame({"id":[1,2,3,4,5,6], "raw_grade":['a', 'b', 'b', 'a', 'a', 'e']})
	df["grade"] = df["row_grade"].astype("category")
	```
2. 对类别重命名
	```
	df["grade"].cat.categories = ["very good", "good", "very bad"]
	```
3. 对类别重排序，可以增加新的类别
	```
	df["grade"] = df["grade"].cat.set_categories(["very bad", "bad", "medium", "good", "very good"])
	```
4. 通过类别列排序
	```
	df.sort_values(by="grade")
	```
5. 通过类别列分组，空类别也会统计
	```
	df.groupby("grade").size()
	```

## Plotting

1. 通过 Series 画图
	```
	ts = pd.Series(np.random.randn(1000), index=pd.date_range('1/1/2000', periods=1000))
	ts = ts.cumsum()
	ts.plot()
	plt.show()
	```
2. 通过 DataFrame 画图
	```
	df = pd.DataFrame(np.random.randn(1000, 4), index=pd.date_range('1/1/2000', periods=1000), columns=['A', 'B', 'C', 'D'])
	df = df.cumsum()
	df.plot()
	plt.legend(loc='best')
	plt.show()
	```

## 读入、写出数据

### CSV

1. 写出
	```
	df.to_csv('foo.csv')
	```
2. 读入
	```
	pd.read_csv('foo.csv')
	```

### HDF5

1. 写出
	```
	df.to_hdf('foo.h5', 'df')
	```
2. 读入
	```
	pd.read_hdf('foo.h5', 'df')
	```

### Excel

1. 写出
	```
	df.to_excel('foo.xlsc', sheet_name='Sheet1')
	```
2. 读入
	```
	pd.read_excel('foo.xlsx', 'Sheet1', index_col=None, na_values=['NA'])

## 坑

不要将 Series 或者 DataFrame 作为布尔值

```
if pd.Series([False, True, False]):
    print("I was true")
```

将会弹出以下异常：

```
Traceback
    ...
ValueError: The truth value of an array is ambiguous. Use a.empty, a.any() or a.all().
```