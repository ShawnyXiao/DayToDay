# Lambda表达式和方法引用（Java 8）

此篇只总结**Lambda表达式**和**方法引用**的语法和哪类情况适合使用Lambda表达式，并没有详细介绍Lambda表达式和方法引用。欲了解详情，请详细参考文献。

## Lambda表达式的语法

一个Lambda表达式包含以下几个组成部分：

1. 	**一个逗号分隔，小括号包围的形参集合**。你可以忽略参数的数据类型；如果只有一个参数，你还可以忽略小括号。  
	合法的例子：
	```
	(int a, int b)  
	(a, b)  
	(int a)  
	a
	()
	```
	不合法的例子：
	```
	(String a, b)  
	(a, String b)  
	int a
	```

2. 	**一个箭头符号**。  
	**唯一**合法的例子：
	```
	->
	```
	不合法的例子：
	```
	- >
	-->
	-<
	<-
	```

3. 	**一个主体**。要么是一个表达式，要么是一个由大括号包围语句块。如果Lambda表达式实现的是一个void方法，而且只有一条语句，那么可以忽略大括号。  
	合法的例子：
	```
	a == b  
	{return a == b;}  
	{result = (a == b); return result;}  
	System.out.println("Hello, world!")
	```
	不合法的例子：
	```
	a == b;  
	{return a == b}  
	```

现在讲上面3个部分组合起来，实现**完整的Lambda表达式**。例如：
```
(a, b) -> a == b  
(int a, int b) -> {result = (a == b); return result;}  
a -> {System.out.println(a);}  
() -> System.out.println("Hello, world!")
```

## 方法引用的语法

| 类型 | 例子 |
| ---- | ---- |
| 静态方法的引用 | ContainingClass::staticMethodName |
| 一个指定对象的实例方法的引用 | containingObject::instanceMethodName |
| 一个指定类的任意对象的实例方法的引用 | ContainingType::methodName |
| 一个构造器的引用 | ClassName::new |

## 哪类情况适合使用Lambda表达式

1. 	如果你想对某些变量做一些处理，而你又想降这些处理封装起来，那么你应该使用Lambda表达式。举个例子：当你想对一个集合的每一个元素做过滤处理的时候，你就应该使用Lambda表达式了。（下面的例子涉及一些Stream API，这里只需要关注filter()方法）
	```
	double average = cars.stream()
						 .filter(c -> c.isBMW() && c.isRed)
						 .mapToDoule(c -> c.getSpeed())
						 .averge()
						 .getAsDouble();
	```

2. 	如果你只想要一个简单的**函数式接口**的实例（只想要实现函数式接口中的唯一的抽象方法），那么你应该使用Lambda表达式。举个例子：
	```
	button.setOnAction(
		event -> System.out.println("Hello World!")
	);
	```

## 参考文献

-	[Lambda Expressions (The Java&trade; Tutorials &gt; Learning the Java Language &gt; Classes and Objects)](https://docs.oracle.com/javase/tutorial/java/javaOO/lambdaexpressions.html)
-	[Method References (The Java&trade; Tutorials &gt; Learning the Java Language &gt; Classes and Objects)](https://docs.oracle.com/javase/tutorial/java/javaOO/methodreferences.html)
-	[When to Use Nested Classes, Local Classes, Anonymous Classes, and Lambda Expressions  (The Java&trade; Tutorials &gt; Learning the Java Language &gt; Classes and Objects)](https://docs.oracle.com/javase/tutorial/java/javaOO/whentouse.html)
-	[Predicate, Consumer, Supplier, Function, UnaryOperator, BinaryOperator (Java Platform SE 8)](http://docs.oracle.com/javase/8/docs/api/index.html)