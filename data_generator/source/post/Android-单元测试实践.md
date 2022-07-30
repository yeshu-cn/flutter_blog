---
title: Android 单元测试实践
date: 2020-04-20 13:49:22
tags: android test 
---

# Android 单元测试

为什么以前没有写单元测试呢，有两个原因：
* 没有使用过，没有亲身体验到单元测试的好处。体验过了就知道，虽然麻烦但值的去认真写
* 以前的代码架构和代码文件组织婚论，其中Repository,Service,Utils,Manager到处调用，没有明确的层次调用关系，造成不能系统的对一个层面的api进行单元测试，掌握测试范围。

## 为什么写单元测试
* 高效，方便的测试代码，不用运行整个项目
* 对自己的代码更有信心
* 方便的判断出代码的好坏（不容易测试就是坏代码）

单元测试分为两种类型
1. Local unit tests
    * 代码可以运行在JVM
    * 运行速度快
2. Instrumented unit test:代码需要依赖Android SDK api
    * 需要运行在模拟器或者真机上
    * 运行速度慢

![-w375](media/15859009095825/15859011412084.jpg)

如果想代码进行local unit tests,但是代码依赖了 android api, 可以使用Mockito来模拟API。

## 单元测试的粒度划分

![](media/15859009095825/15859019011130.jpg)

## Android项目测试相关的目录结构

* app/src/main/java-项目源代码
* app/src/test/java-local unit test的测试代码
* app/src/androidTest/java-Instrumented unit test的测试代码

依赖
使用`testImpementation`单独给`local unit test`添加依赖
```
    testImplementation 'junit:junit:4.13'
    testImplementation "org.jetbrains.kotlinx:kotlinx-coroutines-test:1.3.3"
```
使用`androidTestImplementation`单独给`Instrumented unit test`添加依赖
```
    androidTestImplementation 'androidx.test.ext:junit:1.1.1'
    androidTestImplementation 'androidx.test.espresso:espresso-core:3.2.0'
    androidTestImplementation "org.jetbrains.kotlinx:kotlinx-coroutines-test:1.3.3"
```

## 单元测试的场景（实践）
添加单元测试的层面可以有
* WebApi：服务器接口的实现，方面的在单元测试中进行调试和验证。(unit test)
* Service: 业务服务 (unit test)
* Utils: 工具类方法(unit test)
* Repository: 针对领域model的增删改查接口（double test）
* UseCase: domain层暴露给外界的接口(double test)

double test: 就是需要伪造依赖的测试,例如
```kotlin
class RepositoryImpl(
    private val dao: Dao,
    private val webApi: WebApi
)
```
我们就需要伪造FakeDaoImpl,FakeWebApiImpl两个假的实现。


## 断言
Google Truth比junit的assert更好用
添加依赖
```
repositories {
  mavenCentral()
}
dependencies {
  testImplementation "com.google.truth:truth:1.0.1"
}

```
使用
```
import static com.google.common.truth.Truth.assertThat;
import static com.google.common.truth.Truth.assertWithMessage;

// for assertions on Java 8 types (Streams and java.util.Optional)
import static com.google.common.truth.Truth8.assertThat;


assertThat(notificationText).contains("testuser@google.com");
```

## 实例技巧
* [androidTest和test公用测试代码](https://stackoverflow.com/questions/39519347/share-test-classes-between-test-and-androidtest)
* [unit test中想使用android api，可以使用robolectric](http://robolectric.org/)

## 参考资料
* https://truth.dev/
* https://www.vogella.com/tutorials/AndroidTesting/article.html
* https://codelabs.developers.google.com/codelabs/advanced-android-kotlin-training-testing-basics/index.html?index=..%2F..index#0


