---
title: Google play使用敏感权限无法上架，敏感权限排查方法
date: 2020-04-28 11:05:08
tags:
---

> 
Google Play 会限制应用使用高风险或敏感权限，包括短信或通话记录权限组。
> 如果您的应用不需要使用通话记录或短信权限，您必须从应用的清单中移除这些权限。下文还详细介绍了符合政策的替代实现方式的相关细节。
> 
> 如果您认为自己的应用在政策允许使用的范畴内，或属于可以使用这些权限的例外情况，那么您应直接通过 Play 管理中心声明通话记录或短信权限。
> 
> 对于逾期仍不符合政策要求或未提交声明表单的应用，我们可能会将其从 Google Play 中移除。

发现项目中引入了`PROCESS_OUTGOING_CALLS`敏感权限，但是主工程中没有直接引入这个权限

## 1.查找引入权限的library
`build/outputs/logs/manifest-merger-debug-report.txt`
文件中查看权限从哪个依赖中引入

文件结构如下：
```
uses-permission#android.permission.PROCESS_OUTGOING_CALLS
ADDED from [com.xxx.xxx:lib:1.1.0]...
```

## 2.library有可能是子module的依赖，查找是哪个子module引入的
查看项目的依赖树:`./gradlew app:dependencies > ~/Downloads/log.txt`

文件结构如下：
```
NormalDebugAndroidTestImplementationDependenciesMetadata
+--- androidx.test:runner:1.1.1
|    +--- androidx.annotation:annotation:1.0.0 -> 1.0.1
|    +--- androidx.test:monitor:1.1.1
|    |    \--- androidx.annotation:annotation:1.0.0 -> 1.0.1
|    +--- junit:junit:4.12
|    |    \--- org.hamcrest:hamcrest-core:1.3
|    \--- net.sf.kxml:kxml2:2.3.0
+--- androidx.test:rules:1.1.1
|    \--- androidx.test:runner:1.1.1 (*)
\--- com.google.truth:truth:0.35
     +--- com.google.guava:guava:22.0-android
     |    +--- com.google.code.findbugs:jsr305:1.3.9 -> 3.0.1
     |    +--- com.google.errorprone:error_prone_annotations:2.0.18 -> 2.0.19
     |    +--- com.google.j2objc:j2objc-annotations:1.1
     |    \--- org.codehaus.mojo:animal-sniffer-annotations:1.14
     +--- junit:junit:4.12 (*)
     \--- com.google.errorprone:error_prone_annotations:2.0.19
```

## 3. `tools:node="remove"`删除权限
合并清单时通过`tools:node="remove"`控制删除权限
```
<uses-permission android:name="android.permission.PROCESS_OUTGOING_CALLS" tools:node="remove" />
```

## 参考资料
* [短信和通话记录权限组是敏感权限，不能随便使用](https://support.google.com/googleplay/android-developer/answer/9047303?hl=zh-Hans)
* [google play申明敏感权限](https://support.google.com/googleplay/android-developer/answer/9214102)
* [manifest合并规则](https://developer.android.com/studio/build/manifest-merge?hl=zh-cn#attribute_markers)