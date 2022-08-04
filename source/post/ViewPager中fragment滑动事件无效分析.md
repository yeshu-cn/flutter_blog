---
title: ViewPager中fragment滑动事件无效分析
date: 2020-04-21 10:32:20
tags: android
categories: Android
---

原因：`ViewPager`默认的`onInterceptTouchEvent`方法中在判断出正在滑动时就拦截了触摸事件。

解决: 子`View`收到`ACTION_DOWN`时调用`requestDisallowInterceptTouchEvent(true)`请求所有的父控件不要拦截

## 源码分析
1. `ViewGroup`的`dispatchTouchEvent()`收到触摸事件
2. `ViewPager`的`onInterceptTouchEvent()`判断是否正在进行拖动(`mIsBeingDragged`)，如果正在进行拖动就拦截事件，否则就不管（所以第一次`ACTION_DOWN`就成功分发到了子`View`上）
3. 子`View`的`onTouchEvent()`收到`ACTION_DOWN`事件后调用`requestDisallowInterceptTouchEvent(true)`申请不要拦截



### ViewGroup.dispatchTouchEvent()
```java
if (actionMasked == MotionEvent.ACTION_DOWN) {
    // ACTION_DOWN清除FLAG_DISALLOW_INTERCEPT标记
    resetTouchState();
}

// 分发事件等代码...

if (canceled || actionMasked == MotionEvent.ACTION_UP || actionMasked == MotionEvent.ACTION_HOVER_MOVE) {
    // 最后事件结束了，还会清楚FLAG_DISALLOW_INTERCEPT标记
    resetTouchState();
```

所以：
> getParent().requestDisallowInterceptTouchEvent(true)是要在接收ACTION_DOWN之后，并在接收ACTION_UP或ACTION_CANCEL事件之前调用才有效。

### ViewPager.onInterceptTouchEvent()
```java
public boolean onInterceptTouchEvent(MotionEvent ev) {
    if (action != MotionEvent.ACTION_DOWN) {
        // 如果正在滑动则拦截
        if (mIsBeingDragged) {
            return true;
        }
    }
    
    switch (action) {
        case MotionEvent.ACTION_MOVE: {
            // 计算滑动距离，如果判断是滑动了则mIsBeingDragged为true
            mIsBeingDragged = true
        }
        case MotionEvent.ACTION_DOWN: {
             // 简化了，就当作第一次按下时，肯定不认为是滑动
            mIsBeingDragged = false                
        }
    }
    
    // 所以第一次ACTION_DOWN的事件是可以被分发到子view的
    return mIsBeingDragged;
}
```
### View.onTouchEvent()
```java
    override fun onTouchEvent(event: MotionEvent?): Boolean {
        if (event?.action == MotionEvent.ACTION_DOWN) {
            // 不要拦截我的事件
            parent.requestDisallowInterceptTouchEvent(true)
        }
        // 我要自己消费事件
        return true
    }
```

### View.requestDisallowInterceptTouchEvent()
```java
    @Override
    public void requestDisallowInterceptTouchEvent(boolean disallowIntercept) {
        if (disallowIntercept) {
            mGroupFlags |= FLAG_DISALLOW_INTERCEPT;
        } else {
            mGroupFlags &= ~FLAG_DISALLOW_INTERCEPT;
        }

        // Pass it up to our parent
        if (mParent != null) {
            mParent.requestDisallowInterceptTouchEvent(disallowIntercept);
        }
    }
```

**注意：**会递归请parent也不要拦截
## 参考
* https://juejin.im/post/5d5b703de51d45620923885c