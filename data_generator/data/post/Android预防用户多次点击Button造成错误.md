---
title: Android预防用户多次点击Button造成错误
tags: |-

  - case
permalink: android-preventing-double-click-on-a-button
id: 47
updated: '2015-10-09 13:41:11'
date: 2015-10-09 13:37:17
---



项目中怀疑DialogFragment dismiss时比较慢，从而使用户有机会用户多次点击dialog上的button，造成删除数据时，统计次数出错。

虽然不确定bug是这个原因造成的，但是编程时也可以注意下预防该情况。

解决方案：

**Android Preventing Double Click On A Button**  
https://stackoverflow.com/questions/5608720/android-preventing-double-click-on-a-button/20672997#20672997

看着看着发现里面中文注释，好亲切。。