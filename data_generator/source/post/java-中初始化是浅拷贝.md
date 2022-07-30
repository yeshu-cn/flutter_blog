---
title: java 中初始化是浅拷贝
permalink: java-zhong-fu-zhi-mo-ren-shi-qian-kao-bei
id: 44
updated: '2016-02-01 07:21:59'
date: 2015-09-16 04:12:21
tags:
---

```java
Student s1 = xx;
Student s2 = s1;
```
s2和s1其实指向同一空间


```
Person p(q); //此时拷贝构造函数被用来创建实例p
Person p = q; //此时拷贝构造函数被用来在定义实例p时初始化p
```
c语言中这叫初始化

拷贝构造函数分：浅拷贝，深拷贝
默认拷贝构造函数：默认拷贝构造函数执行的也是浅拷贝