---
title: ExoPlayer2-使用
date: 2017-11-20 17:25:05
tags:
---

# ExoPlayer2-使用

https://google.github.io/ExoPlayer/guide.html

## 缺点

* 使用ExoPlayer时，Android版本必须在Android 4.1(API level 16)以后，因为ExoPlayer播放音频、视频是基于Android 4.1上增加的`MediaCodec`接口实现的
* Widevine这个数字版权管理功能只能在Android 4.4(API level 19)后才能使用


## Library overView

ExoPlayer library 最核心的部分是`ExoPlayer`接口。它提供了视频播放中最常用的功能，如播放，暂停，拖动，缓冲视频。`ExoPlayer`将视频的加载和渲染抽象为如下三个组件：

* MediaSource
		
		负责媒体的下载，播放，决定已缓冲的媒体是否可读。`MediaSource`通过`ExoPlayer.prepare`函数注入使用
* TrackSelector 
		
		负责从`MediaSource`中获取媒体块数据，提供给`Renderer`渲染使用。在player创建的时候注入使用
* LoadControl

		负责`MediaSource`中何时、如何缓冲数据的策略，在player创建时注入使用

Library中针对常用情况对三个组件有默认的实现，为了方便自定义扩展功能，他们都是通过注入的方式传入ExoPlayer。

## Getting started

使用ExoPlayer步骤

1. 项目中添加`Library`依赖
2. 创建`SimpleExoPlayer`实例
3. 关联Player到View(显示视频画面，接收用户输入)
4. 为Player准备好`MediaSource`,并播放
5. 播放结束后，释放player资源


### 添加`library`以来
项目`build.gradle`文件中添加仓库地址

```
repositories {
    jcenter()
    google()
}
```

module `build.gradle`文件中添加以来

```
//添加库的全部特性
implementation 'com.google.android.exoplayer:exoplayer:r2.X.X'

```

或者按需添加


```
compile 'com.google.android.exoplayer:exoplayer-core:r2.X.X'
compile 'com.google.android.exoplayer:exoplayer-dash:r2.X.X'
compile 'com.google.android.exoplayer:exoplayer-ui:r2.X.X'

```

完整的`ExoPlayer libray`包含如下独立的`library module`


* exoplayer-core: Core functionality (required).
* exoplayer-dash: Support for DASH content.
* exoplayer-hls: Support for HLS content.
* exoplayer-smoothstreaming: Support for SmoothStreaming content.
* exoplayer-ui: UI components and resources for use with ExoPlayer.
		

### 创建player

```java
// 1. Create a default TrackSelector
Handler mainHandler = new Handler();
BandwidthMeter bandwidthMeter = new DefaultBandwidthMeter();
TrackSelection.Factory videoTrackSelectionFactory =
    new AdaptiveTrackSelection.Factory(bandwidthMeter);
TrackSelector trackSelector =
    new DefaultTrackSelector(videoTrackSelectionFactory);

// 2. Create the player
SimpleExoPlayer player =
    ExoPlayerFactory.newSimpleInstance(context, trackSelector);
```

### 关联Player到View

`ExoPlayer library`提供`SimpleExoPlayerView`,它包含`PlaybackControlView`和`Surface`。可以在layout.xml文件中直接使用它，关联代码如下：

```java
// Bind the player to the view.
simpleExoPlayerView.setPlayer(player);

```

如果需要自定义视频的控制和视频渲染，可以使用`SimpleExoPlayer`的如下方法

* `setVideoSurfaceView`
* `setVideoTExtureview`
* `setVideoSurfaceHolder`
* `setVideoSurface`

### Player准备

`MediaSource`代表着媒体资源，所以需要在`ExoPlayer.prepare`时就创建好,并传入一个`MediaSource`。ExoPlayer library中提供了默认如下默认的实现：

* DashMediaSource -> DASH
* SsMediaSource -> SmoothStreaming
* HlsMediaSource -> HLS
* ExtractorMediaSource -> regular media files

播放mp4文件代码示例：

```java
// Measures bandwidth during playback. Can be null if not required.
DefaultBandwidthMeter bandwidthMeter = new DefaultBandwidthMeter();
// Produces DataSource instances through which media data is loaded.
DataSource.Factory dataSourceFactory = new DefaultDataSourceFactory(context,
    Util.getUserAgent(context, "yourApplicationName"), bandwidthMeter);
// Produces Extractor instances for parsing the media data.
ExtractorsFactory extractorsFactory = new DefaultExtractorsFactory();
// This is the MediaSource representing the media to be played.
MediaSource videoSource = new ExtractorMediaSource(mp4VideoUri,
    dataSourceFactory, extractorsFactory, null, null);
// Prepare the player with the source.
player.prepare(videoSource);

```

### 控制播放

当player准备好了以后，可以如下方法控制播放：

* setPlayWhenReady
* seekTo
* setRepeatMode
* setPlaybackParameters


### 释放资源

播放结束后需要释放`video decoders`等有限的资源给其他应用使用，调用`ExoPlayer.release`释放资源。

## MediaSource

`MediaSource`实例不能重复使用，如果需要多次初始化player,每次都必须使用新的实例

* DashMediaSource
* SsMediaSource
* HlsMediaSource
* ExtractorMediaSource
* MergingMediaSource
* LoopingMediaSource
* ContractenatingMediaSource
* DynamicConcatenatingMediaSource

### 加载字幕文件

提供一个视频文件和字幕文件，`mergingMediaSource`可以将他们合并为一个资源来播放

```java
// Build the video MediaSource.
MediaSource videoSource = new ExtractorMediaSource(videoUri, ...);
// Build the subtitle MediaSource.
Format subtitleFormat = Format.createTextSampleFormat(
    id, // An identifier for the track. May be null.
    MimeTypes.APPLICATION_SUBRIP, // The mime type. Must be set correctly.
    selectionFlags, // Selection flags for the track.
    language); // The subtitle language. May be null.
MediaSource subtitleSource = new SingleSampleMediaSource(
    subtitleUri, dataSourceFactory, subtitleFormat, C.TIME_UNSET);
// Plays the video with the sideloaded subtitle.
MergingMediaSource mergedSource =
    new MergingMediaSource(videoSource, subtitleSource);
```


### 循环播放视频

有两种方法

* ExoPlayer.setRepeatMode (推荐)
* 使用LoopingMediaSource

	```java
	MediaSource source = new ExtractorMediaSource(videoUri, ...);
	// Plays the video twice.
	LoopingMediaSource loopingSource = new LoopingMediaSource(source, 2);
	
	```

### 播放视频列表

`ConcatenatingMediaSource`可以实现无缝播放视频列表，视频列表的文件格式和视频清晰度都可以不同。

```java
MediaSource firstSource = new ExtractorMediaSource(firstVideoUri, ...);
MediaSource secondSource = new ExtractorMediaSource(secondVideoUri, ...);
// Plays the first video, then the second video.
ConcatenatingMediaSource concatenatedSource =
    new ConcatenatingMediaSource(firstSource, secondSource);
```

`DynamicConcatenatingMediaSource`和`ConcatenatingMediaSource`类似，只是可以播放过程中添加，删除播放列表内容。

**注意`MediaSource`不能重复添加，或者添加之前删除过的`MediaSource`。需要使用新的实例**

### 播放视频A两次，后播放视频B(A,A,B)

```java
MediaSource firstSource = new ExtractorMediaSource(firstVideoUri, ...);
MediaSource secondSource = new ExtractorMediaSource(secondVideoUri, ...);
// Plays the first video twice.
LoopingMediaSource firstSourceTwice = new LoopingMediaSource(firstSource, 2);
// Plays the first video twice, then the second video.
ConcatenatingMediaSource concatenatedSource =
    new ConcatenatingMediaSource(firstSourceTwice, secondSource);
```

or

```java
MediaSource firstSource = new ExtractorMediaSource(firstVideoUri, ...);
MediaSource secondSource = new ExtractorMediaSource(secondVideoUri, ...);
// Plays the first video twice, then the second video.
ConcatenatingMediaSource concatenatedSource =
    new ConcatenatingMediaSource(firstSource, firstSource, secondSource);

```

**注意此处firstSource这个`MediaSource`实例使用了两次，仅限特殊函数才能使用同一实例**

## Player Events

常用的方法有

* addListener
* removeListener
* addVideoListener
* setVideoDebugListener
* setAudioDebugListener


## Sending messages to components

* sendMessages
* blockingSendMessages

## 自定义

可以自定义实现如下组件

* Renderer -> 自定义Renderer支持新类型的媒体
* TrackSelector -> 自定义如何提供数据给Renderer
* LoadControl -> 自定义缓存策略
* Extractor -> 自定义实现支持新的格式
* MediaSource -> 自定义如何提供数据给Renderer
* DataSource -> 自定义如何下载数据，例如通过自定义协议下载数据或者通过本地缓存加载数据


## 数字版权保护

这里介绍如何在Android 4.4及以上版本的设备上播放，DRM相关的媒体，用不到，略...



## 支持的格式

https://google.github.io/ExoPlayer/supported-formats.html



















