---
title: 制作Gif演示图片
date: 2016-10-09 17:56:57
tags:
---

1. `$ adb shell screenrecord /mnt/sdcard/test.mp4` 录制视频
2. `$ adb pull /mnt/sdcard/test.mp4` 获取视频
3. 利用PicGif等软件或者在线网站将mp4转换为`240*360`左右大小的gif图片

不过转换出来的图片想清楚的话，尺寸会很大。尺寸缩小的话，画质又不清楚。


