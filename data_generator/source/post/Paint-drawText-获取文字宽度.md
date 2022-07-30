---
title: Paint.drawText()获取文字宽度
permalink: paint-drawtext-huo-qu-wen-zi-kuan-du
id: 57
updated: '2016-03-09 12:38:21'
date: 2016-03-09 11:59:58
tags:
---

```java
String str = "Hello";  
canvas.drawText( str , x , y , paint);  
  
//1. 粗略计算文字宽度  
Log.d(TAG, "measureText=" + paint.measureText(str));  
  
//2. 计算文字所在矩形，可以得到宽高  
Rect rect = new Rect();  
paint.getTextBounds(str, 0, str.length(), rect);  
int w = rect.width();  
int h = rect.height();  
Log.d(TAG, "w=" +w+"  h="+h);  
  
//3. 精确计算文字宽度  
int textWidth = getTextWidth(paint, str);  
Log.d(TAG, "textWidth=" + textWidth);  

//第二个参数是一个数组.传进去个长度跟字符串长度相同的float数组,方法调用后,里边塞的是每个字符的长度.  
    public static int getTextWidth(Paint paint, String str) {  
        int iRet = 0;  
        if (str != null && str.length() > 0) {  
            int len = str.length();  
            float[] widths = new float[len];  
            paint.getTextWidths(str, widths);  
            for (int j = 0; j < len; j++) {  
                iRet += (int) Math.ceil(widths[j]);  
            }  
        }  
        return iRet;  
    }  

```

资料：

* <http://www.eoeandroid.com/thread-13672-1-1.html?_dsign=773b5e0d>
* <http://blog.csdn.net/chuekup/article/details/7518239>


`measureText()`比`getTextBounds`多加上了左右的间距(Advance value)
 <http://stackoverflow.com/questions/7549182/android-paint-measuretext-vs-gettextbounds>

`getTextWidths()` ：Return the advance widths for the characters in the string。
主要看回答中的两张图就明白了。
<http://stackoverflow.com/questions/20103312/paint-gettextwidths-what-is-advance-width>

所以`measureText()`和`getTextWidths()`方法获取的宽度是相同的，测试过了。
