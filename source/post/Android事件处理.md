---
title: Android事件处理
permalink: androidshi-jian-chu-li-2
id: 36
updated: '2015-09-06 21:11:23'
date: 2015-09-06 21:11:12
tags:
---

WindowManagerService负责接收和派发消息

* 一个线程用于循环接收消息，并将消息放入消息队列
* 一个线程用于从消息队列中去消息，并将消息加工处理发送给对应的窗口


View收到消息后，先判断是否拦截，在确定是否处理事件。
如果拦截，自己处理事件。如果不处理，将事件返回给父View处理。
如果不拦截，将事件传递给子View
