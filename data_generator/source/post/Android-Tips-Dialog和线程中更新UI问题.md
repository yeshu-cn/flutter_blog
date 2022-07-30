---
title: Android  Tips (Dialog和线程中更新UI问题)
permalink: android-tips
id: 62
updated: '2016-03-30 04:29:34'
date: 2016-03-30 03:55:51
tags:
---

**DialogFragment**

* `onCreate()`中必须调用`super.onCreate(savedInstanceState);`
* 使用`newInstance()`方法来获取实例，使用setArguments来传递参数，避免在横竖屏切换的时候Fragment自动调用自己的无参构造函数，导致数据丢失。
```java
static MyDialogFragment newInstance(int num) {
        MyDialogFragment f = new MyDialogFragment();

        // Supply num input as an argument.
        Bundle args = new Bundle();
        args.putInt("num", num);
        f.setArguments(args);

        return f;
    }

    @Override
    public void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        mNum = getArguments().getInt("num");
    }

```

* Dialog重复`show()`或者重复`dismiss()`会怎么样

```
mCustomDialog = CustomDialog.newInstance();
mCustomDialog.show(getFragmentManager(), "");
mCustomDialog.show(getFragmentManager(), "");

java.lang.IllegalStateException: Fragment already added: CustomDialog{70c4f46 #0 }
```

重复`dismiss()`没反应,看源码有做判断

```
void dismissInternal(boolean allowStateLoss) {
        if (mDismissed) {
            return;
        }
        mDismissed = true;
        mShownByMe = false;
        if (mDialog != null) {
            mDialog.dismiss();
            mDialog = null;
        }
        ....
    }
```

* 线程中创建和隐藏Dialog都没有问题,就是说Dialog的创建和隐藏不算是更新UI操作
* 不能再线程中创建Toast

`java.lang.RuntimeException: Can't create handler inside thread that has not called Looper.prepare()`

Toast含有一个TN的成员，TN成员初始化时会new一个Handler,但是handler创建时会判断该线程是否`Looper.prepare()`过。
```
    public Handler(Callback callback, boolean async) {
       //省略...

        mLooper = Looper.myLooper();
        if (mLooper == null) {
            throw new RuntimeException(
                "Can't create handler inside thread that has not called Looper.prepare()");
        }
        mQueue = mLooper.mQueue;
        mCallback = callback;
        mAsynchronous = async;
    }
```

* 线程中启动Activity，关闭Activity不算更新UI.
