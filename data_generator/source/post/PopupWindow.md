---
title: PopupWindow
date: 2017-04-27 15:19:58
tags:
---


# PopupWindow 

生成`PopupWindow`

```java

    final View contentView = LayoutInflater.from(context).inflate(R.layout.guide_view, null);
    contentView.measure(View.MeasureSpec.UNSPECIFIED, View.MeasureSpec.UNSPECIFIED);
    mPopupWindow = new PopupWindow(contentView, ViewGroup.LayoutParams.MATCH_PARENT, contentView.getMeasuredHeight());
```

设置属性

```java
    mPopupWindow.setBackgroundDrawable(new ColorDrawable()); //设置背景
    mPopupWindow.setOutsideTouchable(true); //设置可以接收外部action_outside事件
    mPopupWindow.setFocusable(true);    //设置PopuoWindow处理所有事件，否则会将事件传递給后面的View
```

显示

```java
    //显示在制定View下方，当下方空间不够时会显示到上方
    mPopupWindow.showAsDropDown(View view);
    //显示在制定的坐标位置
    mPopuoWindow.showAtLocation();
```

### 点击返回键和touch outside隐藏popupwindow

popupWindow默认显示出来后，点击返回和touch outside不会隐藏，popupWindow对返回键和outside events的默认处理就是隐藏界面，只是默认的popupWindow接收不到outside touch events 和 key events

#### 让它可以接收到outside touch events, 实现touch outside隐藏
android 6.0以下需要设置背景

```java
mPopupWindow.setBackgroundDrawable(new ColorDrawable());
mPopupWindow.setOutsideTouchable(true);
```

android 6.0只需要

```java
mPopupWindow.setOutsideTouchable(true);
```

但是上面只是实现了touch outside隐藏，因为现在popupwindow focusable为false,接收不到key events, 所以返回键无效,并且现在的touch events底层的window也能接收到点击事件


#### 让它可以接收到key events, 实现点击返回键隐藏
```java
mPopupWindow.setFocusable(true);//当前的window接收并处理所有的key events
```

#### 完整的实现

```java
mPopupWindow.setBackgroundDrawable(new ColorDrawable());
mPopupWindow.setOutsideTouchable(true);
mPopupWindow.setFocusable(true);
```



## WindowManager.LayoutParams

* FLAG\_NOT\_FOCUSABLE (focusable时，能收到按键事件，并且touch events只交给当前window处理，不往底层传递)
        
        this window won't ever get key input focus, so the user can not send key or other button events to it. Those will instead go to whatever focusable window is behind it. This flag will also enable FLAG_NOT_TOUCH_MODAL whether or not that is explicitly set.



* FLAG\_NOT\_TOUCH_MODAL（not touch modal时，outside touch events会发送给自己消费，不往底层传递(focusable时就会自动变成这个状态)）

         even when this window is focusable (its FLAG_NOT_FOCUSABLE is not set), allow any pointer events outside of the window to be sent to the windows behind it. Otherwise it will consume all pointer events itself, regardless of whether they are inside of the window.

        
* FLAG\_NOT\_TOUCHABLE （能否接收到touch events）
    
        Window flag: this window can never receive touch events.



* FLAG\_WATCH\_OUTSIDE\_TOUCH (not touch modal 时，能否接收到outside touch events)
        
        if you have set FLAG_NOT_TOUCH_MODAL, you can set this flag to receive a single special MotionEvent with the action MotionEvent.ACTION_OUTSIDE for touches that occur outside of your window. Note that you will not receive the full down/move/up gesture, only the location of the first down as an ACTION_OUTSIDE.


 
