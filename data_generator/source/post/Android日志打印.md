---
title: Android日志打印
date: 2017-04-01 17:19:49
tags:
---

## Android日志打印

Release版本中不应该打印日志或者包含日志代码

1. 打印了日志信息会有信息泄漏的危险
2. 包含了日志代码也可以通过反编译的手段将日志信息打印出来。

<!--more -->

参考：[如何安全的打印日志](http://weishu.me/2015/10/19/how-to-log-safely-in-android/)


利用混淆配置，去掉日志打印的代码

```
 -assumenosideeffects class android.util.Log {
           public static boolean isLoggable(java.lang.String, int);
           public static int v(...);
           public static int i(...);
           public static int w(...);
           public static int d(...);
           public static int e(...);
       }
```

参考：[android关闭日志](http://blog.csdn.net/jiese1990/article/details/21752159)


把日志打印当作追踪bug的行为是不对的，Release版本应该就不存在bug。这个是在开发测试阶段就应该保证的，不应该抱着以防万一的想法。

