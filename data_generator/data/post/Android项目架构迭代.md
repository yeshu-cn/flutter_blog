---
title: Android项目架构迭代
date: 2019-03-25 17:06:06
tags:
---
## Android项目架构迭代

### 第一次迭代MVC 
失血模型的model, Activity的作为Control, xml作为View。

Activity需要处理UI的展示，用户的交互，实现业务逻辑，职责过于庞大，代码臃肿。

### 第二次迭代MVC-(View + Control + ServiceManager + Repository + Model)
根据数据层，业务层，展示层的三层思想，添加了数据层DB,业务层Service,App作为展示层。

相比于之前，将业务层和数据层整理出来了。但是Activity依然需要处理UI展示，Serivice的交互。

### 第三次迭代MVP(View + Presenter + Service + Repository + Model  )
将Activity,Fragment作为View, Presenter作为View和Service的桥梁。

MVP相对于之前的优点是写代码的时候View和Service完全独立，最终Presenter作为桥梁连接就行，思路很清晰，写起来很爽。但是也存在一些麻烦：
* Presenter中常常需要完全复制一片Activity,Fragment的生命周期，导致我们又要多维护一系列的状态。
* 维护代码时，当一个页面交互很复杂的时候，代码的执行流程会在Presenter和View两个文件中跳转来跳转去，很容易打断思路，不易理解。
* 当一个页面很简单时，直接将Activity作为Control的写法，代码会更简单，也更容易理解。
* Service中既存在细粒度接口，又存在针对当前版本的业务功能设计的粗粒度接口，当程序业务功能改变时，需要修改Service中的粗粒度接口，违背了开放封闭原则

所以下一步的重构主要问题是，将Service中的细粒度和粗粒度的接口分开，隔离变化和不变化的业务接口，从而遵循开放封闭原则
### 第四次迭代-(UI层 + UseCase + Service + Repository + DomainModel）
为解决上述问题,这次设计中的角色职责如下：
* Service:提供基于业务基础功能的不会随版本变化而变化的细粒度接口
* UseCase:提供基于当前版本功能的粗粒度接口
* Repository:提供数据的存储，包含远程数据，本地数据
* Domain model ：领域模型
* UI层：表示项目的展示层，可以采用mvc或者MVP的方式来调用UseCase

其中每个层次，角色之间只依赖接口，不依赖具体实现。具体实现参考[The Clean Architecture]( http://five.agency/android-architecture-part-2-clean-architecture/)

基于这样的设计，每次只需要删除或新增相关页面UseCase就可以了，而不用去修改原有代码，遵循了开放封闭原则。

### 第五次迭代-（UI层 + UseCase + Service）
在后续的思考中发现，只有本地App才需要关心Domain model, Repository等业务的具体实现细节。而在大多数项目中往往是服务器负责实现业务，客户端只负责数据展示和用户交互。在这种理想情况下的架构设计应该是即可：

    MVC/MVP + WebServiceApi
    WebServiceApi: 为服务端提供的粗粒度的业务功能接口
    
还有一种App是服务端提供部分业务功能Api，还有一部分业务功能需要本地配合实现。针对这样的客户端架构设计如下：
        
    MVC/MVP + UseCase + WebServiceApi/LocalServiceApi
    UseCase: 提供给UI层的统一粗粒度接口
    WebServiceApi: 服务端提供的粗粒度的业务功能接口
    LocalServiceApi: 本地实现的细粒度接口
    
    