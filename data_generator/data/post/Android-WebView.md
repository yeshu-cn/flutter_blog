---
title: Android WebView
date: 2016-09-14 16:13:12
tags:
---

##### WebView默认会保存表单数据，输入表单时会弹出一个历史列表的下拉窗口

```java
	/**
     * Sets whether the WebView should save form data. The default is true.
     */
    public abstract  void setSaveFormData(boolean save);
```

禁用

```java
webview.getSettings().setSaveFormData(false);
webview.clearFormData();
```

[disabling autosuggestion on webview](http://stackoverflow.com/questions/7404798/disabling-autosuggestion-on-webview)

##### webView默认禁用javascript,造成加载html页面交互异常

```java
	/**
     * Tells the WebView to enable JavaScript execution.
     * <b>The default is false.</b>
     *
     * @param flag true if the WebView should execute JavaScript
     */
    public abstract void setJavaScriptEnabled(boolean flag);
```


启用javascript

```java
mWebView = (WebView) findViewById(R.id.webview);
WebSettings webSettings = mWebView.getSettings();
webSettings.setJavaScriptEnabled(true);
```
