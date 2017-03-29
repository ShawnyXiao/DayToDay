# Aspect mining、 Copyright infringement investigation 和 Code compaction 的定义调研

## Aspect mining

### 定义

面向对象的系统，通过将应用领域内的真实实体映射为层次化的类，来进行软件系统的开发。但是并不是所有的开发的系统的需求都需要与单个模块单元（类） 相对应。某些需求的实现被分散在不同的类中，而且有可能与类中实现其它职责的功能相搀杂。这种需求与实现的不匹配，成为系统维护阶段的一个潜在的严重问题。事实上很难在单元模块里找到如何实现这些需求的方法，并且不利于对程序的理解，而且如果需求改变，代码的改进就变得很困难。AOP（Aspect Oriented Programming）通过提供一种称为 aspect 的新模块来消除横向的需求（横向关注）与代码之间的不匹配。aspect 可以使需求定位到代码单元。AOP 将一个横向关注实现为一个独特单元 aspect 的一部分，而不是将其散射到多个类中并与其它功能相搀杂。

将横向关注模块化为 aspect 有利于对现有软件的理解与改进。但是其中最难的一个问题是如何确定一个功能是否应该被视为一个 aspect。这个问题现在被称为 aspect 挖掘。

### 引用

- [一种结合扇入和概念分析技术进行Aspect挖掘的方法](http://xueshu.baidu.com/s?wd=paperuri%3A%2802e138a93940be4dd5a301f3f573c593%29&filter=sc_long_sign&tn=SE_xueshusource_2kduw22v&sc_vurl=http%3A%2F%2Fwww.oalib.com%2Fpaper%2F1652152&ie=utf-8&sc_us=14791745087635371296)
- [Aspect Mining and Refactoring](http://www.swerl.tudelft.nl/amr.pdf)

## Copyright infringement investigation

### 定义

> 似乎并没有这样一个专业的术语，著作权侵权的审查，似乎这个词可能是探讨如何检测著作权是否被侵权的问题

著作权侵权是指一切违反著作权法侵害著作权人享有的著作人身权、著作财产权的行为。具体说来,凡行为人实施了《著作权法》第四十七条和第四十八条所规定的行为,侵犯了他人的著作权造成财产或非财产损失,都属于对著作权的侵权。

在检测可能的侵犯版权的情况下，找到两个不同程序的源代码文件之间的相关性并不一定意味着发生侵权行为。思想，概念，事实，过程和方法本身并不受版权法保护。因此，并非软件中的所有内容都受版权或专利保护。法院可能需要专家意见，以确定知识产权侵权是否已经发生。这可能涉及源代码的比较。

### 引用

- [著作权侵权_百度百科](http://baike.baidu.com/link?url=vNYIJtvOF6-FoVUUmhiIxxdCnOPIsLarcyYARLKWiW8YDVLS-RpPsH-Tq-fLnN90vmluK5WD3tfawd1HSjrcrdfnr1nCy3YeRHYcOzUY-ALsww7m_qXE5px8jmAhK14504wyKCa3Je-N8Hq8GRTK4K)
- [A new look at software plagiarism investigation and copyright infringement](http://xueshu.baidu.com/s?wd=paperuri%3A%2875fe5c269a185aaea7f118d06b442ebc%29&filter=sc_long_sign&tn=SE_xueshusource_2kduw22v&sc_vurl=http%3A%2F%2Fieeexplore.ieee.org%2Fxpls%2Fabs_all.jsp%3Farnumber%3D4475669&ie=utf-8&sc_us=11942630679892046996)

## Code compaction

### 定义

- The code size reduction of binaries in order to save manufacturing costs or of source code in order to increase maintainability
- 代码紧缩是为减小代码大小而对代码进行的、结果仍然是可执行代码的变换。其主要方法包括：（1）传统的编译器优化方法；（2）代码因子提取；（3）从软件体系结构出发的代码紧缩方法。

### 引用

- [What is Code Compaction | IGI Global](http://www.igi-global.com/dictionary/code-compaction/4142)
- [代码缩减技术的研究](http://xueshu.baidu.com/s?wd=paperuri%3A%2881a5e3b0321decb3d54050c273e8fdf5%29&filter=sc_long_sign&tn=SE_xueshusource_2kduw22v&sc_vurl=http%3A%2F%2Fwww.cnki.com.cn%2FArticle%2FCJFDTotal-JSJA200602071.htm&ie=utf-8&sc_us=15797978633515780547)