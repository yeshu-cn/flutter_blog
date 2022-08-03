---
title: C语言数组退化为指针
permalink: cy
id: 39
updated: '2015-09-13 07:44:40'
date: 2015-09-13 07:37:22
tags:
---

**数组在除了3种情况外, 其他时候都要"退化"成指向首元素的指针**

 比如对 char s[10] = "china";  这3中例外情况是:  

1. sizeof(s) 
2. &s;
3. 用来初始化s的"china";

除了上述3种情况外,s都会退化成&s[0], 这就是数组变量的操作方式

参考：http://bbs.chinaunix.net/thread-1031622-1-1.html