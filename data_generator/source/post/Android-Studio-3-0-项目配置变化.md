---
title: ' Android Studio 3.0 项目配置变化'
date: 2017-11-10 16:06:23
tags:
---

# Android Studio 3.0 项目配置变化

官方文档：https://developer.android.com/studio/build/gradle-plugin-3-0-0-migration.html

Android studio 3.0会自动升级Android plugin至3.0.0。

## 升级Gradle版本，Android plugin要求Gradle版本最低为4.1
Edit the URL in `gradle-wrapper.properties` to the following:

```
distributionUrl=\
  https\://services.gradle.org/distributions/gradle-4.1-all.zip

```

## Apply the plugin 

Edit the `build.gradle` file as follows:


```
buildscript {
    repositories {
        ...
        // You need to add the following repository to download the
        // new plugin.
        google()
    }

    dependencies {
        classpath 'com.android.tools.build:gradle:3.0.0'
    }
}

```

## 使用新的依赖机制(implemention, api)提高编译速度
> 按照官方的描述，gradle3.0 之前，构建系统的依赖关系被认为是一种完全错误的方式，
> 举一个例子：app 依赖了库 libX，库 libX又依赖库 libY。

>app：
>>compile 'libX'

>libX：
>>compile 'libY'
	
>如果在 app 中调用了 libY 的方法，这个时候如果 libY 中的方法做了改变，那么由于 libY 被和 libX 和 app 都有依赖被依赖关系，这时候如果构建 libY 势必会导致 libX 和 app 也重新构建。

>这应该是个完全错误的依赖方式，正确的方式应该是既然 app 只依赖了 libX 那就不应该知道 libY 中的 api，然而这在构建系统3.0（gradle 插件）之前都是这样存在的，因此 3.0 做了改变，引入了新的依赖形式，api 和 implementation 来替换 compile。

>implementation：表示我依赖你，但是你的 api 不会被我重新分享出去了。

>api：表示我依赖你，但是你的 api 会被我重新分享出去了

>那么在看上面的例子就变成了：

>app：

>>	implementation 'libX'

>libX：

>>	api 'libY'

>由于存在之前的这种依赖传递的错误机制，因此我们项目中很可能就出现了这种依赖传递之后导致一个小修改就把所有库都构建一遍的情况，因此我们花一些时间将一些库的compile 都替换成 api 和 impementation 对我们是有好处的，一来有效缩短构建时间，而来真正搞清楚项目中依赖的情况，那些 api 需要依赖传递，哪些不需要。

>当然我们还是可以继续使用 compile，不过这种方式已经是过时的了，我们只要更新了最新插件，那么新建了项目就会发现所有的 compile 都会被换成了 implementation。相关的修改还有 androidTestImplementation 和 testImplementation，对应的是原来的androidTestCompile 和 testCompile。


from: 加快编译速度 http://halohoop.com/2017/06/13/meals-speedup_gradle_build/

## 重命名apk文件方法变化

```
// If you use each() to iterate through the variant objects,
// you need to start using all(). That's because each() iterates
// through only the objects that already exist during configuration time—
// but those object don't exist at configuration time with the new model.
// However, all() adapts to the new model by picking up object as they are
// added during execution.
android.applicationVariants.all { variant ->
    variant.outputs.all {
        outputFileName = "${variant.name}-${variant.versionName}.apk"
    }
}

```

	

	