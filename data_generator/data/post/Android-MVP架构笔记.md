---
title: Android MVP架构笔记
permalink: android-mvpjia-gou-bi-ji
id: 70
updated: '2016-04-18 12:02:29'
date: 2016-04-18 08:28:25
tags:
---

Basic Model-View-Presenter architecture. [Android 官方架构Demo](ttps://github.com/googlesamples/android-architecture/tree/todo-mvp)


#### TO-DO-MVP项目按页面模块划分
页面模块

* addedittask
* tasks
* statistics
* taskdetai

data 和 utils

* data
* utils


两个基类：BaseView，BasePresenter

命名方式：

```
//布局文件命名
addtask_act.xml
addtask_frag.xml
task_item.xml

//资源文件命名
ic_xxx.png

<color name="colorPrimary">#455A64</color>
<color name="colorPrimaryDark">#263238</color>
<color name="colorAccent">#D50000</color>  

//xml中id命名
android:id="@+id/noTasksIcon"
```

#### Model and Repository

* Task
* TasksRepository:by using the remote data source only if the local database doesn't exist or is empty.

TasksDataSource(interface)定义task的增删改查操作：获取，保存、更新、删除。

1. 函数名为业务方式,
2. 函数的操作对象必须是Task,参数为Task或者Task相关属性

DataSource分为TasksRemoteDataSource和TasksLocalDataSource,分别都实现TasksDataSource接口

TasksRepository则是用户维护管理两个DataSource的。

Repostory中包含数据模型的操作


#### Activity
`TasksActivity`包含`TasksPresenter`

* 初始化必要的界面代码，如`toolbar`, `drawerLayout`，加载`fragment`
* 实例化`Presenter`


#### Presneter and View
`TasksPresenter`作用:监听UI事件，执行业务逻辑，获取数据并更新UI显示

`TasksContract`：包含`View`和`Presenter`两个接口,用于定义`View`和`Presenter`的行为，


`Presenter`包含`Repository`和`view`
`TasksFragment`作为`View`包含`Presenter`

`Presenter`负责处理业务相关函数
`View`负责处理UI显示的函数

`View`中单纯的全部是`View`的展示方法,但是`View`中包含`Presenter`，因为一些UI的交互必须从其中`View`中传递告诉`Presenter`

`Presenter`中包含业务方法、`Repository`和成员`View`，因为业务需要数据和控制UI的展示

## 总结

`MVP`构成其实包含：（`Model`,`Repository`）, `Presenter`, `View`
其中核心代码：

* `Model`：业务模型的定义
* `Presenter`和`View`的`Interface`的定义。这两个定义清楚了，整个项目的层次就会很清楚

#### 实践

在工作中，虽然没有单独的实现`Presenter`和`View`文件。但已经尝试将代码按照`View`的UI展示方法方法和`Presneter`的业务方法进行区分，如果需要重构为`MVP`的话只需要将其中方法提取至单独的`Presenter`和`View`中即可。

因为感觉不是很大的项目，不想建立太多的`Presenter`和`View`文件，所以代码还是全部写在Activity中，如果项目足够大的话，会考虑用标准的mvp项目文件架构形式

这样做的成果就是需求变动的时候往往只需要注释掉莫行代码即可，快速无误，不用担心对其他业务逻辑或UI显示造成影响。



#### MVP思想写代码

* `View`层负责UI展示，`Presenter`层负责业务逻辑。两部分代码需要隔离分清楚，函数级别的松耦合，易维护，复用性高（对应抽象成单独的`Presenter`,`View`类文件，是文件类级别的）。
* 有一个`Model`业务模型大家都知道，但是`Repository`层总是没能理清楚。（参考DDD中的Repository）


#### `MVC`的问题
`MVC`中的`Activity`即充当`View`又充当`Controller`。其中的逻辑代码紧紧的关联着UI，不能复用，混乱。

## 别人的说法
<http://blog.csdn.net/vector_yi/article/details/24719873>

缺点：额外的代码复杂度及学习成本。多了Presenter和View类

优点：

1. 降低耦合度
2. 模块职责划分明显
3. 利于测试驱动开发
4. 代码复用
5. 隐藏数据
6. 代码灵活性

**因：**
Activity并不是一个标准的MVC模式中的Controller， 它的首要职责是加载应用的布局和初始化用户界面，并接受并处理来自用户的操作请求，进而作出响应。随着界面及其逻辑的复杂度不断提升，Activity类的职责不断增加，以致变得庞大臃肿。

**果：**
我们将其中复杂的逻辑处理移至另外的一个类（Presneter）中时，Activity其实就是MVP模式中View，它负责UI元素的初始化，建立UI元素与Presenter的关联（Listener之类），同时自己也会处理一些简单的逻辑（复杂的逻辑交由Presenter处理）.

