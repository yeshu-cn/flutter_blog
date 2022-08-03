---
title: Android更新UI的几种方法
permalink: androidgeng-xin-uide-san-chong-fang-fa
id: 40
updated: '2015-09-13 10:12:58'
date: 2015-09-13 09:37:03
tags:
---

* handler发送消息给主线程更新ui
* Activity的`runOnUiThread() `方法。

```java
    /**
     * Runs the specified action on the UI thread. If the current thread is the UI
     * thread, then the action is executed immediately. If the current thread is
     * not the UI thread, the action is posted to the event queue of the UI thread.
     *
     * @param action the action to run on the UI thread
     */
    public final void runOnUiThread(Runnable action) {
        if (Thread.currentThread() != mUiThread) {
            mHandler.post(action);
        } else {
            action.run();
        }
    }
```

* `View.post(Runnable r)`方法。

```java
boolean android.view.View .post(Runnable action)

//Causes the Runnable to be added to the message queue. The runnable will be //run on the user interface thread.

```

* BroadcastReceiver运行在主线程，可以更新UI。同样其中不能进行耗时操作