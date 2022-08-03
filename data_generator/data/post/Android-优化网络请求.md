---
title: Android 优化网络请求
date: 2017-11-21 17:20:45
tags:
---

# Android 优化网络请求

https://developer.android.com/training/efficient-downloads/efficient-network-access.html


这篇文章介绍无线模块消耗电量的原因，并给出优化方案：
 
* 预先获取数据
* 聚合网络请求

## Understand The Radio State Machine

`Radio`下文就叫无线模块

处于运行状态的无线模块会消耗大量电量，所以无线模块会在不同的模式间切换来节省消耗。

典型的无线模块会在三种不同的状态间切换：

1. **Full power**： 进行网络请求时，高功耗  
2. **Low power**：中间状态，电量消耗只有Full power 的一半
3. **Standby**：没有网络请求时的待机状态，低功耗

low power 和 standby 状态会处于低功耗，但是会造成延迟网络请求。因为low power状态转换为full power状态需要1.5秒的时间，standy 状态转换为 full power 状态需要2秒的时间。

为了减少状态切换造成的网络请求延时，无线模块会延迟向低功耗状态的转换

![](https://developer.android.com/images/efficient-downloads/mobile_radio_state_machine.png)

不同的设备（2G,3G,LTE,etc.）的延时时间不同


## Understand how apps can impact the radio state machine

根据上图

* 每18秒请求一个1秒的数据，一分钟内可以请求3次，获取3秒的数据。此时会让无线模块一直处于耗电状态
* 聚合网络请求，一次请求3秒数据。此时无线模块仅仅只会有20秒处于耗电状态

上面例子中：同样时间内，请求同样时长数据，聚合网络请求会大大的减少耗电量

![](https://developer.android.com/images/efficient-downloads/graphs.png)

## Prefetch Data (预取数据)

### how

* 聚合多个网络请求为一个单独的网络请求
* 不能过度使用预取数据的策略，因为如果用户用不到数据，会造成流量等的浪费

### 优点

1. 减少无线模块激活的次数，从而减少耗电量
2. 减少无线模块状态切换时造成的延时
3. 减少网络带宽的要求
4. 减少网络请求次数，提高app性能
5. 预取数据带来的用户体验的提升


### 预取数据时防止用户不用数据造成的流量浪费

在wifi的情况下预取数据，非wifi的情况下不预取

## Batch Transfer and Connections (聚合数据传输和网络连接)

在3G的情况下，每一次网络请求都会有20秒左右的处于电池的高功耗状态

所以假设每隔20秒请求一下数据，会使无线模块一直处于高功耗状态。

## Reduce Connections

就是叫你减少网络连接，聚合网络请求

## 使用Network Profiler

利用network profiler可以清楚的看到网络请求发送的频率和具体内容，方便我们调试优化网络请求










