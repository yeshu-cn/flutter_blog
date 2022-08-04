---
title: Repository设计
date: 2020-07-08 15:03:12
tags:
categories: 架构设计
---

# Repository设计
前提：WebService只是数据的增删改查接口，不是业务接口。如果是业务接口那WebApi应当等价于UseCase。


## 方案一
![](15941779248052.jpg)

Repository职责：
* 从本地数据中增删改查数据
* 从远程数据中增删改查

具体方法如下：
* addToLocal()
* deleteLocal()
* queryLocal()
* updateLocal()
* addToRemote()
* deleteRemote()
* queryRemote()
* updateRemote()

常见UseCase:
* 本地数据的增删改查
* 远程数据的增删改查
* 本地数据同步到远程
* 远程数据同步到本地

由于数据同步机制属于和具体场景强相关的，所以不放在Repository中，应当由UseCase实现。

## 方案二
方案一发现一个问题：Repository的接口基本上就是本地数据和远程数据的透传，那能不能将其拆分为两个独立的Repository

![](15941778752001.jpg)

LocalRepository职责：本地数据的增删改查
* add()
* query()
* delete()
* update()
RemoteRepository职责：远程数据的增删改查
* add()
* query()
* delete()
* update()

常见UseCase:
* 本地数据的增删改查
* 远程数据的增删改查
* 本地数据同步到远程
* 远程数据同步到本地

虽然清晰了，但使用起来感觉不对，usecase得关注两个数据源？找找理由：
* 对UseCase来说，应当只有一个单一数据源的概念，Local和Remote只是数据类型不同，并不是说来自不同的数据源。
* 方案二的数据同步逻辑实现，会让数据类型转换添加一个不必要的Model转换
    * 方案一：ApiBean->DaoBean
    * 方案二：ApiBean->Model->DaoBean

所以最终结论：还是方案一比较好
