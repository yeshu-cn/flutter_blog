---
title: 项目架构中Module使用
date: 2017-03-03 20:16:28
tags:
categories: 架构设计
---


### Android 多Module遇到的问题

<!--more-->

1.  重复字符串，图片资源文件难以统计，处理。
2.  编译速度慢
3.  容易滥用，能用package的地方也用module, 不符合module设计初衷
4.  随着需求的变化，很容易module之间相互依赖成网，程序架构变的更加混乱
5.  Module中swith里面不能使用R.id.xxx
6.  必然会创建一个公共的Module用于存放公共资源，公共UI组件，公共Utils类。但是这样一个公共的Module的存在就是个大错误。谁都往里面加代码，但谁都不敢去改这里面的代码。这个module就像是一个越堆越高的垃圾山


### 创建Module的原则
1.  不创建module,用package区分模块和代码
2.  除非你有明确的需求，其中一部分代码需要编译为jar、arr包给第三方使用，那可以将其抽出作为moudle

