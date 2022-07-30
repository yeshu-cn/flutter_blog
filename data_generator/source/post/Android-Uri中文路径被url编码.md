---
title: Android Uri中文路径被url编码
permalink: android-urizhong-chuan-shu-zhong-wen-hui-bei-bian-ma-liao
id: 68
updated: '2016-04-08 07:49:49'
date: 2016-04-08 07:46:57
tags:
---

场景：  
选取相册中图片，图片路径中含有中文。此时获取图片`Uri`需要通过`Uri.decode`解码一下才能获取带有中文的路径。

```
    @Override
    protected void onActivityResult(int requestCode, int resultCode, Intent data) {
           //data.getDataString()返回的string是经过url编码的
            String path = Uri.decode(data.getDataString());

    }
```

`intent.getDataString()`返回的是经过url编码的字符串
