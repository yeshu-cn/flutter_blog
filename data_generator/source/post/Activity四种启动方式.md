---
title: Activity四种启动方式
permalink: activitysi-chong-qi-dong-fang-shi
id: 34
updated: '2015-09-06 16:55:12'
date: 2015-09-06 16:06:08
tags:
---


1. standard
每次产生一个新的实例Activity放在栈中
2. singleTop
如果站顶有Activity的实例则onNewInstance()复用它，否则创建一个新的
3. singleTask
会清除栈中Activity之上的所有Activity
Manifest文件中加上taskAffinity属性才会单独在一个Activity栈中，默认情况并不会新建一个栈
利用此方法实现程序的完美退出
4. singleInstance
系统会首先判断系统其他栈中是否已经存在此Activity实例，有则直接使用

**使用方法可以在Manifest文件中定义，也可以通过Intent.addFlags()设置。**


**退出程序**
```java
//通过context获取系统服务，得到ActivityManager   
ActivityManager manager = (ActivityManager) context.getSystemService(Context.ACTIVITY_SERVICE);  
//获取当前运行中的TaskInfo    
//获取的是一个List集合，也就是说当前系统中的task有多个
//关于该方法的参数，我从源码看了下，是指返回集合的最大可能条目数，实际返回数可能  
//小于这个数目，取决于用户启动了几个task  
List<ActivityManager.RunningTaskInfo> tasks = manager.getRunningTasks(1);
ComponetName baseActivity = tasks.get(0).baskActivity;
Intent intent = new Intent();
intent.setComponent(baseActivity);
intent.setFlags(Intent.FLAG_ACTIVITY_CLEAR_TOP);
intent.putExtra("exit", "1");
content.startActivity(intent);
//在应用程序的每个Activity中的onNewIntent()函数中接收intent参数并判断退出
String exit = intent.getStringExtra("exit");
if(exit != null && exit.equals("1")){
   finish();
}

/*
这里主要利用Task找到处于栈底的Activity。再利用Intent.FLAG_ACTIVITY_CLEAR_TOP标志清空task栈中除栈底以外的activity.
注意加上权限：<uses-permission android:name=”android.permission.GET_TASKS”/>
如果应用程序中包含多个Task就去遍历依次退出吧。
还有个思路：利用startActivityForResult依次调用task栈中的baseActivity或topActivity。每次创建后结束掉它
*/
```