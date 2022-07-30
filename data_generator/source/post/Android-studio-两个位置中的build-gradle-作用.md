---
title: Android studio 两个位置中的build.gradle 作用
permalink: build-gradle-bi-ji
id: 61
updated: '2016-03-14 03:08:12'
date: 2016-03-14 02:55:58
tags:
---

整个项目的`build.gradle`

* 声明仓库源
* 声明`android gradle plugin`版本，不同版本的`android studio`要求的`gradle plugin`版本不同。

```
buildscript {
    repositories {
        jcenter()
    }
    dependencies {
        classpath 'com.android.tools.build:gradle:2.1.0-alpha1'
    }
}

allprojects {
    repositories {
        jcenter()
    }
}
```

项目中每个`module`都有一个`build.gradle`

* 声明是Android程序:`apply plugin: 'com.android.application'`
* 编译SDK的版本: `compileSdkVersion 21`
* build tools的版本 `buildToolsVersion "21.1.1"`
* 编译，混淆配置等等