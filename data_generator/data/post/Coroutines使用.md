---
title: Coroutines使用
date: 2020-04-30 17:04:35
tags:
categories: Android
---

## Android上为什么使用Coroutines
* 方便的管理长时间运行的任务
* 提供`main-safe`的方法，主线程可以安全调用的方法、

## Coroutines使用    

```kotlin
// Dispatchers.Main
suspend fun fetchDocs() {
    // Dispatchers.Main
    val result = get("developer.android.com")
    // Dispatchers.Main
    show(result)
}
// Dispatchers.Main
suspend fun get(url: String) =
    // Dispatchers.Main
    withContext(Dispatchers.IO) {
        // Dispatchers.IO
        /* perform blocking network IO here */
    }
    // Dispatchers.Main
```

> Well written suspend functions are always safe to call from the main thread (or main-safe).

使用`withContext`来实现`main-safe`的方法，`withContext`有性能优势，即使多次调用也可以避免线程的切换开销

三个调度器
* Dispatchers.IO （执行网络或IO操作）
* Dispatchers.Default (适合执行占用大量CPU资源的工作，例如排序、解析JSON等)
* Dispatchers.Main (主线程)

### scope的来源
suspend方法必须在scope中启动，可以是GlobalScope, viewModelScope或者实现CoroutineScope接口。

```kotlin
class MyActivity : AppCompatActivity(), CoroutineScope by MainScope() {
    override fun onDestroy() {
        // cancel is extension on CoroutineScope
        cancel() 
    }

    /*
     * Note how coroutine builders are scoped: if activity is destroyed or any of the launched coroutines
     * in this method throws an exception, then all nested coroutines are cancelled.
     */
        fun showSomeData() = launch { // <- extension on current activity, launched in the main thread
           // ... here we can use suspending functions or coroutine builders with other dispatchers
           draw(data) // draw in the main thread
        }
    }
```

### structured concurrency管理协程
> A leaked coroutine can waste memory, CPU, disk, or even launch a network request that’s not needed.

没有妥善管理好生命周期的协程，可能会造成资源的浪费。所以Kotlin提供了`structured concurreny`来管理协程的运行和生命周期。

通过`structured concurrency`提供如下能力：
* When a **scope cancels**, all of its **coroutines cancel**.
* When a **suspend fun returns**, all of its **work is done**.
* When a **coroutine errors**, its **caller or scope is notified**.

`coroutines`必须运行在`CoroutineScope`中，`CoroutineScope`就是用来追踪管理所有的`coroutines`。

> A CoroutineScope keeps track of all your coroutines, and it can cancel all of the coroutines started in it.

### CoroutineScope启动coroutines的两种方式
* `launch`:只负责启动，不会返回任何结果
* `async`:启动并返回一个结果，调用`await`获取返回值

```kotlin
scope.launch {
    // This block starts a new coroutine 
    // "in" the scope.
    // 
    // It can call suspend functions
   fetchDocs()
}
```
注意：`launch`启动的协程会跑出异常，`async`则不会，因为它设计的初衷时通过`await`方法取得结果或异常。


### 并发处理
`suspend functions`中使用`coroutineScope`或者`supervisorScope`来同时启动多个协程。

`coroutineScope`可以保证当`suspend`方法返回时，它里面的所有协程都已经执行完毕。

> Structured concurrency guarantees that when a suspend function returns, all of its work is done.


```kotlin
suspend fun fetchTwoDocs() {
    coroutineScope {
        launch { fetchDoc(1) }
        async { fetchDoc(2) }
    }
}
```
* `coroutinesScope`：当其中一个协程失败时，会取消它所启动的所有协程
* `supervisorScope`：当其中一个协程失败时，不会影响它所启动的其他协程

### 异常错误处理
通过`try/catch`不错错误异常

通过async启动协程可能会丢失异常
```kotlin
val unrelatedScope = MainScope()
// example of a lost error
suspend fun lostError() {
    // async without structured concurrency
    unrelatedScope.async {
        throw InAsyncNoOneCanHearYou("except")
    }
}
```
`async`设计初衷是假设您会通过`await`来获取结果或异常，但是如果你没有调用它，就会造成异常丢失。

> Structured concurrency guarantees that when a coroutine errors, its caller or scope is notified.

但是通过`structured concurrency`可以确保怎么也不会丢失异常

```kotlin
suspend fun foundError() {
    coroutineScope {
        async { 
            throw StructuredConcurrencyWill("throw")
        }
    }
}
```
### ViewModel中启动coroutines
> Structured concurrency guarantees when a scope cancels, all of its coroutines cancel.

取消`scope`会取消它里面的所有协程。

使用`viewModelScope`需要倒入依赖`lifecycle-viewmodel-ktx:2.1.0-alpha04`。

```
class MyViewModel(): ViewModel() {
    fun userNeedsDocs() {
        // Start a new coroutine in a ViewModel
        viewModelScope.launch {
            fetchDocs()
        }
    }
}
```

`viewModelScope`会在生命周期结束时(onCleared()调用时)自动取消里面的所有协程，所以即使如下代码也是安全的。

```
fun runForever() {
    // start a new coroutine in the ViewModel
    viewModelScope.launch {
        // cancelled when the ViewModel is cleared
        while(true) {
            delay(1_000)
            // do something every second
        }
    }
}
```
### Room中使用Coroutines

> Note: Room uses its own dispatcher to run queries on a background thread. Your code should not use withContext(Dispatchers.IO) to call suspending room queries. It will complicate the code and make your queries run slower.

1. 添加依赖
```
//Kotlin Extensions and Coroutines support for Room
implementation "androidx.room:room-ktx:$room_version"
```
2. 在方法前加上`suspend`
```kotlin
@Dao
interface ProductsDao {
   // Because this is marked suspend, Room will use it's own dispatcher
   //  to run this query in a main-safe way.
   @Query("select * from ProductListing ORDER BY dateStocked ASC")
   suspend fun loadProductsByDateStockedAscending(): List<ProductListing>

   // Because this is marked suspend, Room will use it's own dispatcher
   //  to run this query in a main-safe way.
   @Query("select * from ProductListing ORDER BY dateStocked DESC")
   suspend fun loadProductsByDateStockedDescending(): List<ProductListing>
} 
```

### 将Callback转换为Coroutines
```kotlin
suspend fun execute(): MyResultType {
    return suspendCoroutine<MyResultType> { continuation ->
        myRepository.myRemoteCall()
            .subscribeOn(Schedulers.io())
            .observeOn(AndroidSchedulers.mainThread())
            .subscribe(
                { result -> onSuccess(continuation, result) },
                { throwable -> onError(continuation, throwable) })
    }
}
private fun onSuccess(
    continuation: Continuation,
    result: MyResultType) {
    ...
    continuation.resume(result)
}
private fun onError(
    continuation: Continuation,
    throwable: Throwable) {
    ...
    continuation.resumeWithException(throwable)
}
```
## 提供main-safe的接口方法
最佳实践，每个层面的接口都是`main-safe`的方法
* WebApi
* Dao
* Repository
* UseCase

## Coroutines单元测试
导入依赖：kotlinx-coroutines-test

使用`runBlocking`或`runBlockingTest`测试
```kotlin
@Test
fun whenRefreshTitleSuccess_insertsRows() = runBlockingTest {
   val titleDao = TitleDaoFake("title")
   val subject = TitleRepository(
           MainNetworkFake("OK"),
           titleDao
   )

   subject.refreshTitle()
   Truth.assertThat(titleDao.nextInsertedOrNull()).isEqualTo("OK")
}

```

`runBlocking`和`runBlockingTest`区别(没看懂这两个东西作用和区别)
> Important: The function runBlockingTest will always block the caller, just like a regular function call. The coroutine will run synchronously on the same thread. You should avoid `runBlocking` and `runBlockingTest` in your application code and prefer launch which returns immediately.
>
> `runBlockingTest` should only be used from tests as it executes coroutines in a test-controlled manner, while `runBlocking` can be used to provide blocking interfaces to coroutines.



## 资料
* [协程使用官方介绍](https://developer.android.com/kotlin/coroutines)
* [协程的使用介绍](https://medium.com/androiddevelopers/coroutines-on-android-part-i-getting-the-background-3e0e54d20bb)
* [codelabs](https://codelabs.developers.google.com/codelabs/kotlin-coroutines/#9)

