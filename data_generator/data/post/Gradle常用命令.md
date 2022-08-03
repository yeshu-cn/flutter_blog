---
title: Gradle常用命令
permalink: gradlechang-yong-ming-ling-2
id: 56
updated: '2016-03-09 03:11:05'
date: 2016-03-09 03:07:57
tags:
---

* `./gradlew -v` 查看版本号
* `./gradlew clean` 清除/app目录下的build文件夹，并下载项目所需要的依赖
* `./gradlew build` /app/build/outputs/apk目录下生产debug和release的apk文件
* `./gradlew assembleDebug` 编译并打Debug包
* `./gradlew assembleRelease` 编译并打Release的包
* `./gradlew installRelease` Release模式打包并安装
* `./gradlew uninstallRelease` 卸载Release模式包
* `./gradlew assembleWandoujiaRelease`  打包wandoujia渠道的release版本
* `./gradlew assembleWandoujia` 生成wandoujia渠道的Release和Debug版本
* `./gradlew assembleRelease` 把Product Flavor下的所有渠道的Release版本都打出来

from:<https://segmentfault.com/a/1190000004050697>