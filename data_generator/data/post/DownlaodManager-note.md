---
title: DownlaodManager note
date: 2016-09-21 17:56:13
tags:
---

###### android 5.1.1 (22)，Honor:CHM-TL00H:手机上系统数据库缺少字段造成下载失败

```
java.lang.NullPointerException: Attempt to invoke virtual method 'java.lang.String android.net.Uri.getLastPathSegment()' on a null object reference
	at android.app.DownloadManager.enqueue(DownloadManager.java:950)
```

###### DownloadManager disable造成下载失败

禁用／开启DownloadManager方法：设置－>引用程序->下载管理器－>Enable/Disable

```
java.lang.IllegalArgumentException: Unknown URL content://downloads/my_downloads
```

###### 源码分析

```java
	//ContentResolver.java文件中
    public final @Nullable Uri insert(@NonNull Uri url, @Nullable ContentValues values) {
        Preconditions.checkNotNull(url, "url");
        IContentProvider provider = acquireProvider(url);
        if (provider == null) {
        		//DownloadManager disable造成下载失败
            throw new IllegalArgumentException("Unknown URL " + url);
        }
        try {
            long startTime = SystemClock.uptimeMillis();
            //insert时数据库该手机上数据库缺少个字段造成return null
            Uri createdRow = provider.insert(mPackageName, url, values);
            long durationMillis = SystemClock.uptimeMillis() - startTime;
            maybeLogUpdateToEventLog(durationMillis, url, "insert", null /* where */);
            return createdRow;
        } catch (RemoteException e) {
            // Arbitrary and not worth documenting, as Activity
            // Manager will kill this process shortly anyway.
            return null;
        } finally {
            releaseProvider(provider);
        }
    }
```

###### 需先判断DownloadManager是否可用，在进行下载

参考Gmail inbox做法,下载前检测DownloadManager是否可用，如果不可用提示用户DownloadManager is disabled. Please enable it. 

[how to enable android download manager ](http://stackoverflow.com/questions/21551538/how-to-enable-android-download-manager)

```java
private static boolean isEnableDownloadManager(Context context) {
        ApplicationInfo ai = null;
        try {
            ai = context.getPackageManager().getApplicationInfo("com.android.providers.downloads", 0);
        } catch (PackageManager.NameNotFoundException e) {
            return false;
        }

        return ai.enabled;
    }
```

###### Url不合法会崩溃,需要检查Url

```java
Uri resource = Uri.parse(apkPath);
DownloadManager.Request request;
//url不合法会崩溃
request = new DownloadManager.Request(resource);
```

使用`URLUtil.isValidUrl(url)`来判断url是否合法（`www.qq.com`这种是不合法的，必需有`http://`等）

[check url is valid](http://stackoverflow.com/questions/4905075/how-to-check-if-url-is-valid-in-android)


###### try catch 会不会影响性能

在不抛出异常等情况下，不会影响性能。try catch范围等大小也不会影响性能，只是影响代码可读性。
