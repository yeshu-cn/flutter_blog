---
title: Android程序员技能列表
permalink: androidcheng-xu-yuan-ji-neng-lie-biao
id: 16
updated: '2015-06-03 03:25:23'
date: 2015-06-02 07:39:07
tags:
---

#Android技术要点
Android程序员技能列表
##目录
###必备基础知识
*  程序员基础知识
*  Android基础知识  

###开发技能
*  软件架构设计技能
*  UI开发技能（每年Google IO推出的新组件和常用开源项目）
*  网络开发技能
*  NDK编程技能
*  应用的安全技能
*  进阶提高技能

##详情
1. 程序员基础知识
	* SVN Github版本控制使用
	* Java线程和线程池
	* 代码Review

2. Android基础知识
	* Android四大组件，Activity生命周期，Intent传递数据，Notification等机制和ListView等控间使用。
	* 每一个App即使一个单独的进程，单独的jvm虚拟机上运行。每个jvm虚拟机所需的内存都是在编译rom时设定死的。
	* Android测试框架
	* 多屏幕适配
	* Android进程间通信AIDL
	* Gradle使用
	* adb工具使用(安装/卸载应用，上传和下载设备中文件，启动和停止服务，启动和停止莫一个Service,Activity,发送广播等)
	* 命令行操作sqlite数据库
	* Android系统各个文件目录结构和权限
	* Apk安装和卸载流程
	* 熟悉SDK目录结构（里面含有adb工具，.9.png制作工具，模拟器镜像等）
	* .9.png工具使用
		
3. 软件架构设计技能
	* 项目包结构设计 
	* MVC（Model-View-Controller）
	* MVP (Model-View-Presenter)
	* MVVM（Model-View-ViewModel: Data Binding）
	* RoboBinding
	* RxJava
	* 事件总线的架构，考虑使用Otto或者greenrobot EventBus。
		
4. UI开发技能（包括每年Google IO推出的新技术和常用开源项目）
	* Material Design设计
	* Fragment使用(什么时候使用Fragment：Activity管理Fragment.UI显示用Fragement)
	* 图片加载（Picasso Fresco Glie Android-Universal-Image-Loader）
	* merge标签使用
	* RecyclerView和CardView使用
	* ActionBar使用
	* Android Theme Style使用
	* ActionBarSherlock
	* ViewPagerIndicator	
	* IO 2015上新组件，详情：http://android-developers.blogspot.fi/2015/05/android-design-support-library.html
	
5. 网络开发技能
	* Volley使用
	* android-async-http
	* Json解析库
	
6. NDK编程技能
	* NDK编程
	* 程序中调用so

7. 应用的安全技能
	* 代码混淆，Proguard配置
	* 注入框架使用，api hook
	* 软件逆向

	
8. 进阶提高技能
	* Android系统、应用启动销毁流程
	* 源码分析，linux system design.....
	* Arm（逆向汇编的时候还是需要知道点这个知识的）
	* bootloader

##备注
以上仅是自己有接触或了解过的Android相关知识点总结

##好资料
Android最佳实践
<https://github.com/futurice/android-best-practices>





