---
title: ExoPlayer多个实例导致播放失败
permalink: exoplayerduo-ge-shi-li-dao-zhi-bo-fang-shi-bai
id: 89
updated: '2016-08-05 08:17:24'
date: 2016-08-05 08:11:22
tags:
---

切换视频源的时候，重新创建了一个ExoPlayer实例，并且没有释放之前的ExoPlayer导致视频播放不了。

错误信息如下
```
08-05 11:10:10.586 28237-21861/com.huami.midong E/ExoPlayerImplInternal: Internal track renderer error.
                                                                         com.google.android.exoplayer.ExoPlaybackException: com.google.android.exoplayer.MediaCodecTrackRenderer$DecoderInitializationException: Decoder init failed: OMX.qcom.video.decoder.avc, MediaFormat(1, video/avc, -1, 59046, 1920, 1080, 0, 1.0, -1, -1, null, 2000000, false, -1, -1, -1, -1, -1)
                                                                             at com.google.android.exoplayer.MediaCodecTrackRenderer.notifyAndThrowDecoderInitError(MediaCodecTrackRenderer.java:414)
                                                                             at com.google.android.exoplayer.MediaCodecTrackRenderer.maybeInitCodec(MediaCodecTrackRenderer.java:400)
                                                                             at com.google.android.exoplayer.MediaCodecTrackRenderer.onInputFormatChanged(MediaCodecTrackRenderer.java:768)
                                                                             at com.google.android.exoplayer.MediaCodecVideoTrackRenderer.onInputFormatChanged(MediaCodecVideoTrackRenderer.java:333)
                                                                             at com.google.android.exoplayer.MediaCodecTrackRenderer.readFormat(MediaCodecTrackRenderer.java:524)
                                                                             at com.google.android.exoplayer.MediaCodecTrackRenderer.doSomeWork(MediaCodecTrackRenderer.java:507)
                                                                             at com.google.android.exoplayer.SampleSourceTrackRenderer.doSomeWork(SampleSourceTrackRenderer.java:129)
                                                                             at com.google.android.exoplayer.ExoPlayerImplInternal.doSomeWork(ExoPlayerImplInternal.java:434)
                                                                             at com.google.android.exoplayer.ExoPlayerImplInternal.handleMessage(ExoPlayerImplInternal.java:213)
                                                                             at android.os.Handler.dispatchMessage(Handler.java:98)
                                                                             at android.os.Looper.loop(Looper.java:135)
                                                                             at android.os.HandlerThread.run(HandlerThread.java:61)
                                                                             at com.google.android.exoplayer.util.PriorityHandlerThread.run(PriorityHandlerThread.java:40)
                                                                          Caused by: com.google.android.exoplayer.MediaCodecTrackRenderer$DecoderInitializationException: Decoder init failed: OMX.qcom.video.decoder.avc, MediaFormat(1, video/avc, -1, 59046, 1920, 1080, 0, 1.0, -1, -1, null, 2000000, false, -1, -1, -1, -1, -1)
                                                                             at com.google.android.exoplayer.MediaCodecTrackRenderer.maybeInitCodec(MediaCodecTrackRenderer.java:400) 
                                                                             at com.google.android.exoplayer.MediaCodecTrackRenderer.onInputFormatChanged(MediaCodecTrackRenderer.java:768) 
                                                                             at com.google.android.exoplayer.MediaCodecVideoTrackRenderer.onInputFormatChanged(MediaCodecVideoTrackRenderer.java:333) 
                                                                             at com.google.android.exoplayer.MediaCodecTrackRenderer.readFormat(MediaCodecTrackRenderer.java:524) 
                                                                             at com.google.android.exoplayer.MediaCodecTrackRenderer.doSomeWork(MediaCodecTrackRenderer.java:507) 
                                                                             at com.google.android.exoplayer.SampleSourceTrackRenderer.doSomeWork(SampleSourceTrackRenderer.java:129) 
                                                                             at com.google.android.exoplayer.ExoPlayerImplInternal.doSomeWork(ExoPlayerImplInternal.java:434) 
                                                                             at com.google.android.exoplayer.ExoPlayerImplInternal.handleMessage(ExoPlayerImplInternal.java:213) 
                                                                             at android.os.Handler.dispatchMessage(Handler.java:98) 
                                                                             at android.os.Looper.loop(Looper.java:135) 
                                                                             at android.os.HandlerThread.run(HandlerThread.java:61) 
                                                                             at com.google.android.exoplayer.util.PriorityHandlerThread.run(PriorityHandlerThread.java:40) 
                                                                          Caused by: android.media.MediaCodec$CodecException: Error 0xffffffea
                                                                             at android.media.MediaCodec.native_configure(Native Method)
                                                                             at android.media.MediaCodec.configure(MediaCodec.java:577)
                                                                             at com.google.android.exoplayer.MediaCodecVideoTrackRenderer.configureCodec(MediaCodecVideoTrackRenderer.java:328)
                                                                             at com.google.android.exoplayer.MediaCodecTrackRenderer.maybeInitCodec(MediaCodecTrackRenderer.java:389)
                                                                             at com.google.android.exoplayer.MediaCodecTrackRenderer.onInputFormatChanged(MediaCodecTrackRenderer.java:768) 
                                                                             at com.google.android.exoplayer.MediaCodecVideoTrackRenderer.onInputFormatChanged(MediaCodecVideoTrackRenderer.java:333) 
                                                                             at com.google.android.exoplayer.MediaCodecTrackRenderer.readFormat(MediaCodecTrackRenderer.java:524) 
                                                                             at com.google.android.exoplayer.MediaCodecTrackRenderer.doSomeWork(MediaCodecTrackRenderer.java:507) 
                                                                             at com.google.android.exoplayer.SampleSourceTrackRenderer.doSomeWork(SampleSourceTrackRenderer.java:129) 
                                                                             at com.google.android.exoplayer.ExoPlayerImplInternal.doSomeWork(ExoPlayerImplInternal.java:434) 
                                                                             at com.google.android.exoplayer.ExoPlayerImplInternal.handleMessage(ExoPlayerImplInternal.java:213) 
                                                                             at android.os.Handler.dispatchMessage(Handler.java:98) 
                                                                             at android.os.Looper.loop(Looper.java:135) 
                                                                             at android.os.HandlerThread.run(HandlerThread.java:61) 
                                                                             at com.google.android.exoplayer.util.PriorityHandlerThread.run(PriorityHandlerThread.java:40) 
```

原因：设备上能使用的`hardware decoder`数量有限，所以要及时释放ExoPlayer

There will be a limit on the maximum number of hardware decoders that you can instantiate, which you're hitting.

参考：https://github.com/google/ExoPlayer/issues/273