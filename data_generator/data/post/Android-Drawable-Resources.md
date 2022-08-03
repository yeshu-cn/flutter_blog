---
title: Android Drawable Resources
permalink: android-drawable-resources
id: 49
updated: '2015-10-27 13:10:21'
date: 2015-10-27 13:05:09
tags:
---

# Drawable Resources
A drawable resource is a general concept for a graphic that can be drawn to the screen.

There are several different types of drawables:
* Bitmap File  
* Nine-Patch File  
* Layer List  
* State List  
* Level List  
* Transition Drawable  
* Inset Drawable  
* Clip Drawable  
* Shape Drawable  


## Layer List
A `LayerDrawable` is a drawable object that manages an array of other drawables. Each drawable in the list is drawn in the order of the list—the last drawable in the list is drawn on top.

Each drawable is represented by an `<item>` element inside a single `<layer-list>` element.

`<layer-list>` This must be the root element. Contains one or more ｀<item>｀ elements.

命名空间：
```xml 
xmlns:android="http://schemas.android.com/apk/res/android"

```

`<item>`Must be a child of a <selector> element. Accepts child ｀<bitmap>｀ elements.

example

```xml
<?xml version="1.0" encoding="utf-8"?>
<layer-list xmlns:android="http://schemas.android.com/apk/res/android">
    <item>
        <shape>
            <solid android:color="#ff0000" />
        </shape>
    </item>


    <item android:left="2dp" android:right="2dp" android:top="2dp" android:bottom="2dp">
        <shape>
            <solid android:color="#ffffff" />
        </shape>
    </item>
</layer-list>
```

```xml
<?xml version="1.0" encoding="utf-8"?>
<layer-list xmlns:android="http://schemas.android.com/apk/res/android">
    <item>
      <bitmap android:src="@drawable/android_red"
        android:gravity="center" />
    </item>
    <item android:top="10dp" android:left="10dp">
      <bitmap android:src="@drawable/android_green"
        android:gravity="center" />
    </item>
    <item android:top="20dp" android:left="20dp">
      <bitmap android:src="@drawable/android_blue"
        android:gravity="center" />
    </item>
</layer-list>
```

## State List
最常用的selector

## Level List
Android 电量图标显示用到的技术

## Transition Drawable

## Inset Drawable

## Clip Drawable

## Scale Drawable

## Shape Drawabel

`android:shape=["rectangle" | "oval" | "line" | "ring"]`　缺省值是rectangle

`<stroke>`边框颜色

`<solid>`填充颜色

`<padding>`不知道什么效果

`<gradient>`填充渐变颜色

`<corners>`设置圆角  
__如何设置特定上下左右位置圆角__ Every corner must (initially) be provided a corner radius greater than 1, or else no corners are rounded. If you want specific corners to not be rounded, a work-around is to use android:radius to set a default corner radius greater than 1, but then override each and every corner with the values you really want, providing zero ("0dp") where you don't want rounded corners.

```xml
<?xml version="1.0" encoding="utf-8"?>
<!-- android:shape默认缺省值：rectangle -->
<shape xmlns:android="http://schemas.android.com/apk/res/android"
    android:shape="rectangle">
    <!--<gradient-->
    <!--android:startColor="#FFFF0000"-->
    <!--android:endColor="#80FF00FF"-->
    <!--android:angle="45"/>-->
    <!--<padding android:left="7dp"-->
    <!--android:top="7dp"-->
    <!--android:right="7dp"-->
    <!--android:bottom="7dp" />-->
    <solid android:color="@color/colorPrimary"/>
    <stroke
        android:color="@color/colorAccent"
        android:width="2px"/>

</shape>
```
