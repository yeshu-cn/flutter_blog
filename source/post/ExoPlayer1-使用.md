---
title: ExoPlayer1-使用
date: 2017-11-17 17:58:12
tags:
---

# ExoPlayer1-使用

https://google.github.io/ExoPlayer/guide-v1.html

三个重要的概念：`TrackRenderer`,`SampleSource`,`DataSource`

## TrackRenderer

* `TrackRenderer`负责播放指定类型的媒体如视频，音频或文字。
* `MediaCodecVideoTrackRenderer` 是负责播放视频的实现
* `MediaCodecAudioTrackRenderer` 是负责播放音频的实现
* `TextTrackRenderer` 负责显示文字

`MediaCodecVidoTrackRenderer`和`MediaCodecAudioTrackRenderer`都是利用Android的`MediaCodec`类实现解码数据（支持的格式：https://developer.android.com/guide/appendix/media-formats.html）

ExoPlayer使用一般流程

```
// 1. Instantiate the player.
player = ExoPlayer.Factory.newInstance(RENDERER_COUNT);
// 2. Construct renderers.
MediaCodecVideoTrackRenderer videoRenderer = ...
MediaCodecAudioTrackRenderer audioRenderer = ...
// 3. Inject the renderers through prepare.
player.prepare(videoRenderer, audioRenderer);
// 4. Pass the surface to the video renderer.
player.sendMessage(videoRenderer, MediaCodecVideoTrackRenderer.MSG_SET_SURFACE, surface);
// 5. Start playback.
player.setPlayWhenReady(true);
...
player.release(); // Don’t forget to release when done!

```

## SampleSource

`TrackRender`的构造函数需要传入一个`SampleSource`实例，`SampleSource`负责提供媒体的数据信息和格式。ExoPlayer library中提供了几种不同格式数据的`SampleSource`实现: 

* `ExtractorSampleSource`- For formats such as FMP4,MP4,M4A,MKV,WebM,MP3,AAC,MPEG-TS,MPEG-PS,OGG,FLV and WAV
* `ChunkSampleSource` - For DASH 	and SmoothStreaming playbacks.
* `HlsSampleSource` - For HLS playbacks


## DataSource
 
 负责给`SampleSource`加载媒体数据，最常见的实现有：
 
 * `DefaultUriDataSource` - For playing media that can be either local or loaded over the network
 * `AssetDataSource` - For playing media stored in the `assets` folder of application's apk
 * `ChunkSource` - For DASH, 加载并提供媒体数据块

 
## 传统媒体的播放流程 （Traditional media playbacks）
 
 传统媒体就是指：FMP4, MP4, M4A, MKV, WebM, MP3, AAC, MPEG-TS, MPEG-PS, OGG, FLV and WAV. 
 
 ```java
Allocator allocator = new DefaultAllocator(BUFFER_SEGMENT_SIZE);
DataSource dataSource = new DefaultUriDataSource(context, null, userAgent);
ExtractorSampleSource sampleSource = new ExtractorSampleSource(
    	uri, dataSource, allocator, BUFFER_SEGMENT_COUNT * BUFFER_SEGMENT_SIZE);
MediaCodecVideoTrackRenderer videoRenderer = new MediaCodecVideoTrackRenderer(
    	context, sampleSource, MediaCodecSelector.DEFAULT, MediaCodec.VIDEO_SCALING_MODE_SCALE_TO_FIT);
MediaCodecAudioTrackRenderer audioRenderer = new MediaCodecAudioTrackRenderer(
    	sampleSource, MediaCodecSelector.DEFAULT);
 ```
 
## 自适应媒体播放 （Adaptive media playbacks）
就是直播视频，选择视频清晰度的技术
 
> 自适应流媒体技术，就是能够智能感知你的下载速度，然后动态调节视频的编码速率，为你提供最高质量、最平滑的视频演播的技术。 [detail](https://zhidao.baidu.com/question/2117519251785432747.html)

常见的技术方案有

 * 苹果的HLS
 * 微软的Microsoft Smooth Streaming(SmoothStreaming)
 * 国际标准DASH

#### DASH and SmoothStreaming

`ChunkSampleSource`构造函数需要传入`ChunkSource`和`LoadControl`。`ChuckSource` providing media chunks from which to load and read samples.  有如下两种实现

* `DashChunkSource`：provides DASH playback using the FMP4 and WebM container formats
* `SmoothStreamingChunkSource`：provides SmoothStreaming playback using the FMP4 container format.

`ChunkSource`的实现类需要传入`FormatEvaluator`和`DataSource`

* `FormatEvaluator`负责管理使用的格式
* `DataSource`负责提供数据
* `LoadControl`负责处理缓冲策略

```java
LoadControl loadControl = new DefaultLoadControl(new DefaultAllocator(BUFFER_SEGMENT_SIZE));
DefaultBandwidthMeter bandwidthMeter = new DefaultBandwidthMeter();

// Build the video renderer.
DataSource videoDataSource = new DefaultUriDataSource(context, bandwidthMeter, userAgent);
ChunkSource videoChunkSource = new DashChunkSource(manifestFetcher,
    DefaultDashTrackSelector.newVideoInstance(context, true, false), videoDataSource,
    new AdaptiveEvaluator(bandwidthMeter), LIVE_EDGE_LATENCY_MS, elapsedRealtimeOffset, null, null,
    DemoPlayer.TYPE_VIDEO);
ChunkSampleSource videoSampleSource = new ChunkSampleSource(videoChunkSource, loadControl,
    VIDEO_BUFFER_SEGMENTS * BUFFER_SEGMENT_SIZE);
MediaCodecVideoTrackRenderer videoRenderer = new MediaCodecVideoTrackRenderer(context,
    videoSampleSource, MediaCodecSelector.DEFAULT,
    MediaCodec.VIDEO_SCALING_MODE_SCALE_TO_FIT);

// Build the audio renderer.
DataSource audioDataSource = new DefaultUriDataSource(context, bandwidthMeter, userAgent);
ChunkSource audioChunkSource = new DashChunkSource(manifestFetcher,
    DefaultDashTrackSelector.newAudioInstance(), audioDataSource, null, LIVE_EDGE_LATENCY_MS,
    elapsedRealtimeOffset, null, null, DemoPlayer.TYPE_AUDIO);
ChunkSampleSource audioSampleSource = new ChunkSampleSource(audioChunkSource,
    loadControl, AUDIO_BUFFER_SEGMENTS * BUFFER_SEGMENT_SIZE);
MediaCodecAudioTrackRenderer audioRenderer = new MediaCodecAudioTrackRenderer(
    audioSampleSource, MediaCodecSelector.DEFAULT);

```

> In this code, `manifestFetcher` is an object responsible for loading the DASH manifest that defines the media. The `videoAdaptationSetIndex` and `audioAdaptationSetIndex` variables index components of the initially loaded manifest that correspond to video and audio respectively.



### HLS

HLS播放需要使用到`HlsSampleSource`,`HlsChunkSource`

example:

```java
LoadControl loadControl = new DefaultLoadControl(new DefaultAllocator(BUFFER_SEGMENT_SIZE));
DefaultBandwidthMeter bandwidthMeter = new DefaultBandwidthMeter();
PtsTimestampAdjusterProvider timestampAdjusterProvider = new PtsTimestampAdjusterProvider();
DataSource dataSource = new DefaultUriDataSource(context, bandwidthMeter, userAgent);
HlsChunkSource chunkSource = new HlsChunkSource(true /* isMaster */, dataSource, url, manifest,
    DefaultHlsTrackSelector.newDefaultInstance(context), bandwidthMeter, timestampAdjusterProvider,
    HlsChunkSource.ADAPTIVE_MODE_SPLICE);
HlsSampleSource sampleSource = new HlsSampleSource(chunkSource, loadControl,
    MAIN_BUFFER_SEGMENTS * BUFFER_SEGMENT_SIZE);
MediaCodecVideoTrackRenderer videoRenderer = new MediaCodecVideoTrackRenderer(context, sampleSource,
    MediaCodecSelector.DEFAULT, MediaCodec.VIDEO_SCALING_MODE_SCALE_TO_FIT);
MediaCodecAudioTrackRenderer audioRenderer = new MediaCodecAudioTrackRenderer(sampleSource,
    MediaCodecSelector.DEFAULT);

```

## notes

好像只有自适应媒体的播放才有`loadControl`控制缓冲策略，传统媒体都是直接播放

[视频播放的相关协议](https://www.zhihu.com/collection/200537456)