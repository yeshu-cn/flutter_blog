---
title: flavor权限，依赖，源文件配置
date: 2020-04-17 16:18:00
tags:
---
# flavor权限，依赖，源文件配置

* 为ProductFlavor设置依赖
* 为ProductFlavor设置权限
* 不同的ProductFlavor使用不同的源码文件


## 添加三种flavor
```
android {

    ...

    productFlavors {
        free {
            applicationId "com.yeshu.app.free"
            versionCode 1
            versionName "1.0.0"
        }

        premium {
            applicationId "com.yeshu.app.premium"
            versionCode 1
            versionName "1.0.0"
        }

        enterprise {
            applicationId "com.yeshu.app.enterprise"
            versionCode 1
            versionName "1.0.0"
       }
   }
   ....

}
```

## 添加特定权限
* app/src/main/AndroidManifest.xml (默认的，包含公共的信息)
* app/src/free/AndroidManifest.xml （包含flavor特定的信息）
* app/src/premium/AndroidManifest.xml
* app/src/enterprise/AndroidManifest.xml

free，preminum,enterprise对应的AnroidMainfest.xml中分别添加自己需要permission。
最终程序打包时会将flavor中的AndroidMainfest.xml和默认的AndroidMainfest.xml合并

## 添加特定依赖
使用`flavorNameImplementation`指定只有特定的flavor才依赖
```
// 所有的都会包含
Implementation 'com.android.support:support-v4:22.2.1'
// 只有free的才包含
freeImplementation 'com.google.android.gms:play-services-ads:7.8.0'
// 只有premium的才包含
premiumImplementation 'com.google.android.gms:play-services-ads:7.8.0'
```

## 使用不同的源码文件
默认的文件目录结构如下
* /src/main/java/com/yeshu/app/main/**.java（公共的源文件）
* /src/free/java/com/yeshu/app/main/**.java（free专有源文件）
* /src/premium/java/com/yeshu/app/main/**.java （premium专有源文件）

## gradle动态指定文件目录
```
    sourceSets.all { set ->
        
        if (name == "play") {
            // play flavor指定源码和资源目录
            java.srcDirs += "src/startUpAdPlay/java"
            res.srcDirs += "src/startUpAdPlay/res"
        } else {

            // 指定其他flavor的源码和资源目录
            java.srcDirs += "src/startUpAd/java"
            res.srcDirs += "src/startUpAd/res"
            manifest.srcFile "src/startUpAd/AndroidManifest.xml"
        }
    }
```

## gradle动态添加依赖
```
applicationVariants.all { variant ->
        if (!variant.flavorName.equalsIgnoreCase("play")) {
            // 非play flavor才添加某个依赖
            dependencies {
                implementation "xxxx"
            }
        }
    }
```

## 资料
* [implement flavor dependent dependencies](https://futurestud.io/tutorials/android-how-to-implement-productflavor-dependent-dependencies-with-gradle)
* [implement flavor dependent persissions](https://futurestud.io/tutorials/how-to-implement-product-flavor-dependent-permissions)
* [flavor使用官方指南](https://developer.android.com/studio/build/build-variants)

