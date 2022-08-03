---
title: Android Status bar颜色无法改变
permalink: android-5-0zhi-qian-she-bei-status-baryan-se-wu-fa-gai-bian
id: 24
updated: '2015-07-23 06:42:04'
date: 2015-07-23 06:26:30
tags:
---

5.0之前设备不支持改变status bar颜色
#####资料
Android Material: Status bar color won't change

The status bar is a system window owned by the operating system.On pre-5.0 Android devices, applications do not have permission to alter its color, so this is not something that the AppCompat library can support for older platform versions. The best AppCompat can do is provide support for coloring the ActionBar and other common UI widgets within the application.

来源：http://stackoverflow.com/questions/26496411/android-material-status-bar-color-wont-change