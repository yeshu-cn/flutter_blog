---
title: SeeBar自定义样式笔记
date: 2017-10-11 18:00:54
tags:
---

自定义进度条颜色和thumb的圆角seekbar效果图

![效果图](http://oxnkcigpr.bkt.clouddn.com/seekbar.png)

* seekbar高度为4dp用`maxHeight`,`minHeight`控制
* thumb的半径是10dp,通过`thumbOffset `,`paddingStart `,`paddingEnd `属性控制，使其圆心显示在刻度位置

布局文件

```xml
<SeekBar
        android:layout_width="match_parent"
        android:layout_height="wrap_content"
        android:maxHeight="4dp"
        android:minHeight="4dp"
        android:progressDrawable="@drawable/bg_time_bar"
        android:thumbOffset="5dp"
        android:paddingStart="5dp"
        android:paddingEnd="5dp"
        android:thumb="@drawable/thumb_time_bar"/>
```


bg\_time_bar.xml

```xml
<?xml version="1.0" encoding="utf-8"?>
<layer-list xmlns:android="http://schemas.android.com/apk/res/android">
    
    <item android:id="@android:id/background">
        <shape>
            <corners android:radius="2dp"/>
            <solid android:color="#99ffffff"/>
        </shape>
    </item>

    <!-- 进度条 -->
    <item android:id="@android:id/progress">
        <clip>
            <shape>
                <corners android:radius="2dip"/>

                <solid android:color="@color/progress"/>
            </shape>
        </clip>
    </item>
</layer-list>

```

thumb\_time_bar.xml

```
<?xml version="1.0" encoding="utf-8"?>
<layer-list xmlns:android="http://schemas.android.com/apk/res/android">
    <item>
        <shape
            android:shape="oval">
            <solid android:color="#e2ffffff"/>
            <size
                android:width="10dp"
                android:height="10dp"/>
        </shape>
    </item>

    <item>
        <shape
            android:shape="oval">
            <solid android:color="#ffffff"/>
            <size
                android:width="6dp"
                android:height="6dp"/>
        </shape>
    </item>
</layer-list>

```