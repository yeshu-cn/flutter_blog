---
title: Android gradle
date: 2016-09-21 17:50:14
tags:
---


#### 项目编译发布

ProductFlavor

基本原理是利用Gradle的`mainfest merger`功能。

build.gradle 文件

```
android {
	
	defaultConfig {
		mainfestPlaceholders = [UMENG_CHANNEL_VALUE: "debug"]
	}
	
	productFlavors {
		debug {
			mainfestPlaceholders = [UMENG_CHANNEL_VLAUE: "debug"]
		}
		
		release {
			mainfestPlaceholders = [UMENG_CHANNEL_VLAUE: "debug"]
		}
	}
	
	productFlavors.all { flavor ->
		flavor.mainfestPlaceholders = [UMENG_CHANNEL_VALUE: name]
	}
}
```

AndroidMainfest.xml 文件

```
	<meta-data
        android:name="UMENG_CHANNEL"
        android:value="${UMENG_CHANNEL_VALUE}" />
```

##### 混淆mapping.txt文件位置

生成在 `build/outputs/mapping` 目录下


##### Debug启动混淆，Release不启用混淆

```
android {
	buildTypes {
		release {
			minifyEnable true //是否启用混淆
			proguardFiles getDefaultProguardFile('proguard-android.txt')
		}
	}
}
```

##### 自定义BuildConfig，Debug,Release版本开启或关闭日志

```
buildTypes {
  release {
    buildConfigField "boolean", "LOG_DEBUG", "false"
    proguardFiles getDefaultProguardFile('proguard-android.txt'), 'proguard-rules.pro'
    signingConfig signingConfigs.release
  }
  debug{
    buildConfigField "boolean", "LOG_DEBUG", "true"
  }
}

// java代码中
if(BuildConfig.LOG_DEBUG){
    //开启日志
}else{
	//关闭日志
}

```

##### 自定义BuildConfig，Debug，Release版本使用不同的服务器地址

```
buildTypes {
  release {
    buildConfigField "String", "API_SERVER_URL", "https://debug.api.com"
    proguardFiles getDefaultProguardFile('proguard-android.txt'), 'proguard-rules.pro'
    signingConfig signingConfigs.release
  }
  debug{
        buildConfigField "String", "API_SERVER_URL", "https://release.api.com"
  }
}
```

##### 签名文件配置

```
	// 将签名信息直接写在了代码里，不安全
   signingConfigs {
        release {
            storeFile file('android-app.keystore')
            storePassword '123456'
            keyAlias 'android'
            keyPassword '1234567'
        }
    }
    
	// 不要把签名信息写在代码里面
   signingConfigs {
        release {
        	// this requires system environments to be created for each project on each computer
        	//需要设置环境变量$PATH
            def keystore = System.getenv("KEYSTORE")
            storeFile file(keystore == null ? "/dev/null" : keystore)
            storePassword System.getenv("KEYSTORE_PASSWD")
            keyAlias System.getenv("KEYALIAS")
            keyPassword System.getenv("KEYALIAS_PASSWD")
        }
    }

    buildTypes {
        release {
            minifyEnabled true
            proguardFiles file('proguard-project.txt')
            signingConfig signingConfigs.release //配置release包的签名
        }

        debug {
        }
    }
```

[Sign APK without putting keystore info in build.gradle](http://stackoverflow.com/questions/20562189/sign-apk-without-putting-keystore-info-in-build-gradle)



##### 修改生成apk的名字

```
android.applicationVariants.all { variant ->  
    def file = variant.outputFile  
    variant.outputFile = new File(file.parent, file.name.replace(".apk", "-" + defaultConfig.versionName + ".apk"))  
}  
```

##### gradle 常用命令

```
./gradlew -v
./gradlew clean 
./gradlew tasks
./gradlew --help
./gradlew build
./gradlew assembleDebug
./gradlew assembleRelease
./gradlew assembleWandoujiaRelease 
./gradlew assembleWandoujia
./gradlew installRelease
./gradlew uninstallRelease
```

##### 优化编译设置

* 将gradle作为守护进程后台一直运行,Android studio本身已经是守护进程，使用命令行编译时需要设置一下。
* 设置多个project时并行编译，并行编译时各个project之间不能有依赖关系，否则可能会由于并行编译而编译失败。

`.gradle/gradle.properties`文件中加入

```
org.gradle.daemon=true 
org.gradle.parallel=true
```

##### 项目根目录下的`.gradle`目录和用户目录下的`~/.gradle`目录用途

android studio手动下载gradle放在`～／.gradle/wrapper/dists`目录下

gradle.properties文件，可以放在~/.gradle目录中，也可以放在项根目录中

```
ELEASE_STORE_FILE=～／project/android-app.keystore
RELEASE_KEY_ALIAS=android
RELEASE_STORE_PASSWORD=123456
RELEASE_KEY_PASSWORD=123456
```

放在项目根目录中则表示局部的变量，放在用户目录中表示全局的变量。可以从Android Studio中看得出来。
