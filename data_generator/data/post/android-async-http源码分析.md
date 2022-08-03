---
title: android-async-http源码分析
permalink: android-async-httpyuan-ma-fen-xi
id: 38
updated: '2015-09-09 09:27:08'
date: 2015-09-09 09:25:36
tags:
---


* 学习一些命名规则
* 程序设计方式

##功能特征
* 进行http请求，以回调的方式处理返回
* 非UI线程进行网络请求
* 使用线程池处理并发的资源请求
* GET/POST请求参数化
* 文件分段上传
* 体积小，90kb
* 自动重试机制
* 自动对gizp进行解码
* 使用`JsonHttpResponseHandler`解析为json格式response
* 使用`FileAsyncHttpResponseHandler`保存response为文件
* 支持cookie存储，存储在SharedPreferences中
* `BaseJsonHttpResponseHandler `中集成jackson、Gson等库
* 支持编码设置，不仅仅`UTF-8`



##使用

```java
AsyncHttpClient client = new AsyncHttpClient();
client.get("https://www.google.com", new AsyncHttpResponseHandler() {

    @Override
    public void onStart() {
        // called before request is started
    }

    @Override
    public void onSuccess(int statusCode, Header[] headers, byte[] response) {
        // called when response HTTP status is "200 OK"
    }

    @Override
    public void onFailure(int statusCode, Header[] headers, byte[] errorResponse, Throwable e) {
        // called when response HTTP status is "4XX" (eg. 401, 403, 404)
    }

    @Override
    public void onRetry(int retryNo) {
        // called when request is retried
	}
});
```

推荐编码方式

```java
import com.loopj.android.http.*;

public class TwitterRestClient {
  private static final String BASE_URL = "https://api.twitter.com/1/";

  private static AsyncHttpClient client = new AsyncHttpClient();

  public static void get(String url, RequestParams params, AsyncHttpResponseHandler responseHandler) {
      client.get(getAbsoluteUrl(url), params, responseHandler);
  }

  public static void post(String url, RequestParams params, AsyncHttpResponseHandler responseHandler) {
      client.post(getAbsoluteUrl(url), params, responseHandler);
  }

  private static String getAbsoluteUrl(String relativeUrl) {
      return BASE_URL + relativeUrl;
  }
}
```

使用`PersistentCookieStore `持久化Cookies
使用`RequestParams `添加GET/POST请求参数
使用`RequestParams `上传文件
使用`FileAsyncHttpResponseHandler `下载二进制数据



##命名
* FileWrapper
* StreamWrapper
* makeRequest()；
* makeRequestWithRetries()；

##如何实现重试机制

`RetryHandler`

```java
	
	makeRequest()
	makeRequestWithRetries()
	
	//重试次数和重试间隔时间
    private final int maxRetries;
    private final int retrySleepTimeMS;
    
    //出发重试时的场景
    static {
        // Retry if the server dropped connection on us
        exceptionWhitelist.add(NoHttpResponseException.class);
        // retry-this, since it may happens as part of a Wi-Fi to 3G failover
        exceptionWhitelist.add(UnknownHostException.class);
        // retry-this, since it may happens as part of a Wi-Fi to 3G failover
        exceptionWhitelist.add(SocketException.class);

        // never retry timeouts
        exceptionBlacklist.add(InterruptedIOException.class);
        // never retry SSL handshake failures
        exceptionBlacklist.add(SSLException.class);
    }
    
    //请求重试
    public boolean retryRequest(IOException exception, int executionCount, HttpContext context)；
    
    if (retry) {
            // resend all idempotent requests
            HttpUriRequest currentReq = (HttpUriRequest) context.getAttribute(ExecutionContext.HTTP_REQUEST);
            if (currentReq == null) {
                return false;
            }
        }
```


##如何实现解析回调

```java
public interface ResponseHandlerInterface{}

//内部存在一个Handler用于发送处理消息
public abstract class AsyncHttpResponseHandler implements ResponseHandlerInterface{}

public abstract class TextHttpResponseHandler extends AsyncHttpResponseHandelr{}
public abstract class BinaryHttpResponseHandler extends AsyncHttpResonseHandler{}
public abstract class FileAsyncHttpResponseHandler extends AsyncHttpResponseHandler{}
public abstract class DataAsyncHttpResponseHandler extends AsyncHttpResponseHandler{}

public class JsonHttpResponseHandler extends TextHttpResponseHandler{}
public abstract class BaseJsonHttpResponseHandler<JSON_TYPE> extends TextHttpResponseHandler{}

```

###AsyncHttpResponseHandler构造函数
* 没有传入参数`Looper`则获取当前线程的`Looper`。一般使用情况下即为UI线程
* 创建一个静态内部类`ResponseHandler`与此`Looper`关联，并将消息委托给`AsyncHttpResponseHandler`实例的`handleMessage`函数来处理



##如何管理网络请求

* AsyncHttpRequest：异步网络请求
* RequestHandle: 控制异步网络请求的取消和运行
* 通过标志位判断和取消网络请求

```java
AsyncHttpRequest request = new AsyncHttpRequest(client, httpContext, uriRequest, contentType, responseHandler, context);
        threadPool.submit(request);
```

##异步方式下的网络请求数据流程
* `AsyncHttpRequest`是一个线程，加入线程池，执行`run()`方法进行网络请求
* 执行完毕后，回调成员变量`TextHttpResponseHandler`的`onSuccess()`方法将返回数据交由其处理
* `TextHttpResponseHandler `（及其子类）获取数据进行解析加工

##线程池如何处理的

`AsyncHttpClient`
```java

private ExecutorService threadPool;

threadPool = Executors.newCachedThreadPool();

AsyncHttpRequest request = new AsyncHttpRequest(client, httpContext, uriRequest, contentType, responseHandler, context);

threadPool.submit(request);
```
