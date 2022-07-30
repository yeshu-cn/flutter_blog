---
title: Android Package Structure Best Practice
permalink: android-package-structure-best-practice
id: 80
updated: '2016-05-17 06:54:40'
date: 2016-05-17 06:52:16
tags:
---


###### 原则

Packages are mainly useful for two reasons:

1. A package provides a unique namespace for the types it contains.(可以根据类型将文件组织在一个包中，例如service, model,Adapter等, 即根据layer划分)
2. Classes in the same package can access each other's package-access members.（可以根据业务逻辑之间的权限关系将文件组织在一个包中，即根据feature划分）

但2的优先级应该更高，然后在根据1的特性来组织项目。即优先根据feature划分模块，再在其中根据layer划分。




###### 最佳实践
￼![demo](http://7xt69f.com1.z0.glb.clouddn.com/1-A-m20R0Qve-eB4ishqZc_Q.png)

**用自己的话讲**

1. 可以通过项目文件架构了解app的基本功能
2. 导航度高，很容易找到相关代码。再查看代码时不用在不同的package之间跳来跳去
3. 低耦合，高内聚，模块度高。很容易维护，扩展代码。


**Gains and Benefits**

* 		By looking at the structure you can already tell what the app is all about (figure 1); （可读性高，通过项目文件架构就能了解app的基本功能）
* 		Higher modularity; （每个包之间相互独立，模块化高）
* 		Easier code navigation; （导航性高，容易找到代码）
* 		Higher level of abstraction;
* 		Separates both features and layers; （先按features分层，再按layer分层）
* 		More readable and maintainable structure;
* 		More cohesion; （和2一样，高内聚性）
* 		Much easier to scale;
* 		Less chance to accidentally modify unrelated classes or files;
* 		Much easier to add or remove application features;
* 		And much more reusable modules.



#### 来源资料

* http://stackoverflow.com/questions/5525872/android-project-package-structure
* https://medium.com/@cesarmcferreira/package-by-features-not-layers-2d076df1964d#.hg4s10o2e
* https://medium.com/@joaquimadraz/pragmatic-clean-code-architecture-d0d34f38849a#.ppbt2xdi8
