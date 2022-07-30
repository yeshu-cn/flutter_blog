---
title: handler机制笔记
permalink: handlerji-zhi-bi-ji
id: 41
updated: '2015-09-13 10:24:33'
date: 2015-09-13 10:15:47
tags:
---


* Looper和MessageQueue是一一对应关系，创建Looper时会自动创建一个MessageQueue
* 一个Looper可以绑定很多个handler
* Activity启动时会UI线程会自动Looper.prepare()创建一个Looper
* 一个线程只有一个Looper，但可以有很多个handler

```java
//创建包含Looper的线程
 class LooperThread extends Thread {
 	public Handler mHandler;
	public void run() {
		Looper.prepare();
		mHandler = new Handler() {
       	public void handleMessage(Message msg) {
       	// process incoming messages here
			}};
               Looper.loop();
	}
 }
```

```java
private static void prepare(boolean quitAllowed) {
        if (sThreadLocal.get() != null) {
            throw new RuntimeException("Only one Looper may be created per thread");
        }
        sThreadLocal.set(new Looper(quitAllowed));
    }

//Looper中包含一个MessageQueue
private Looper(boolean quitAllowed) {
        mQueue = new MessageQueue(quitAllowed);
        mThread = Thread.currentThread();
    }

```