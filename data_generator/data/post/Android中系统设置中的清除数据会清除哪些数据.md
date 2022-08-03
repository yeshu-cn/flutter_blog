---
title: Android中系统设置中的清除数据会清除哪些数据
permalink: >-
  androidzhong-xi-tong-she-zhi-zhong-de-qing-chu-shu-ju-jiu-jing-hui-qing-chu-na-xie-shu-ju
id: 33
updated: '2015-09-06 16:04:53'
date: 2015-09-06 16:04:07
tags:
---


		会删除/data/data/com.packagename/目录下除lib目录外的所有文件.
		包括数据库，SharePreference文件，缓存文件等。
		但不会删除sd卡上的文件