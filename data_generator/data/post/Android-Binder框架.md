---
title: Android Binder框架
permalink: android-binderkuang-jia
id: 29
updated: '2015-09-06 21:01:04'
date: 2015-08-15 15:12:20
tags:
---

Binder框架用途：
实现Android中进程间通信，Apk调用系统服务时就是使用binder框架。

#####框架组成部分
Service(例如音乐服务)
Binder Driver（驱动程序，类似内核中一块共享的内存空间）
Client（Apk程序）

执行流程  
1. Client调用Binder Driver,Binder Driver使Client线程挂起等待
2. Binder Driver调用Service 执行具体功能代码并返回结果给Binder Driver
3. Binder Driver将Service中执行的结果返回给Client线程，并继续执行Client线程

实际存在两个Binder对象，不同的是Binder驱动中的对象不会额外产生一个线程。

服务端和Binder驱动中都需要重写onTransact()方法
```java
@override
protected boolean onTransact(int code, Parcel data, Parcel reply, int flags) throws RemoteException{
    return super.onTransact(code, data, reply, flags);
}
```

######Service
Service其实就是一个Binder对象实例，但该实例一旦创建时就会启动一个线程等待接收Binder驱动发送过来的消息，收到消息后执行Binder类中的onTransact()方法。
######Binder Driver
任意一个Service创建时，都会在Binder驱动中创建一个Binder类型的mRemote对象
1. 向服务端线程发送调用消息
2. 挂起当前线程，等待服务端执行完毕后的通知
3. 接到通知后，继续客户端线程，并返回执行结果
######Client
客户端发送的Parcel格式的数据和服务端接收到的Parcel格式数据必须按照约定的顺序发送和解析


Service启动成功后，ActivityManagerService会将Binder驱动中的mRemot当做参数以回调的方式传给客户端。

AIDL生成的Java文件中包含：传输包裹数据的写入和读取顺序和服务端中的onTransact()方法