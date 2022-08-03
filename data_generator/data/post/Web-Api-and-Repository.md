---
title: Web Api and Repository
date: 2018-09-07 19:04:09
tags:
---

# Web Api和Repository处理

之前一直疑惑LocalModelRepository,RemoteModelRepository,api接口代码怎么写，他们应该属于框架里的哪个角色？

## 服务端Api有两层
1. 应用无关的细粒度接口
2. 应用相关的粗粒度接口

提供给客户端的应该是应用相关的粗粒度接口

接口的代码写成WebApiService,由Usecase调用



## 框架流程

`ViewModel`是指`android.arch.lifecycle.ViewModel`,UI和数据之间的桥梁，相当于`Controller`

1. 简单的：UI->ViewModel->WebApiService
2. 复杂的：UI->ViewModel->Usecase->ModelRepository/WebApiService



## Repository

结论：不应该存在RemoteRepository,Repository只表示本地仓库

* 数据的来源有时在功能需求上是要明确表现出来的，所以不能盲目的屏蔽数据的来源，封装城一个Repository，提供一个接口。
* WebApi是应用相关的接口，直接就相当于Usecase了。不能把他当作远程仓库的接口

## Package

```
domain
	- model					//domain model 业务模型
	- repository 			//interface:本地数据的增删改查
	- service 	
		- apiService 		//interface:服务端提供的网络接口
		- elseService 		//interface:细粒度的业务功能单元 
	- usecase				//粗粒度的应用层的业务功能，由service,repository,model组装而成

data
	- model					//持久层model
	- repository        	//impl:repository的具体实现

device
	- service				//impl:service的具体实现

app
	- ui 					//ui 实现	 
```

## Links

https://blog.csdn.net/yu870646595/article/details/51900478
