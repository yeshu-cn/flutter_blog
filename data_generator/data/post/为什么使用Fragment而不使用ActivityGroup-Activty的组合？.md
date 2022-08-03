---
title: 为什么使用Fragment而不使用ActivityGroup+Activty的组合？
permalink: wei-shi-yao-shi-yong-fragmenter-bu-shi-yong-activitygroupactivtyde-zu-he
id: 32
updated: '2015-09-06 15:58:54'
date: 2015-09-06 15:43:59
tags:
---

将完整的屏幕当做很多碎片模块，当做多个可重用的组件。可以使用两种方案

1. ActivityGroup + Activity
2. Activity + Fragment

为什么第一种被淘汰？

1. 从设计上来说Activity就是一个界面，这种ActivityGroup+Activity来实现一个界面的实现方式不符合设计逻辑。

2.新设计的Fragment机制，性能和提供的功能比第一种方案更加好。 



