---
title: ExoPlayer2-名词介绍
date: 2017-11-20 15:02:15
tags:
---

# ExoPlayer2-名词介绍

学习ExoPlayer之前一堆的视频相关的名词概念不清楚，代码都看不懂

## 什么是Widevine

> Widevine是google在ICS版本上新推出的一种DRM数字版权管理功能，有这个功能的话，就能从google指定的服务器上，下载经过google加密的版权文件，例如视频、应用等等。
> 

[Widevine DRM简介](http://blog.csdn.net/beautyfuel/article/details/56277988)

## H264 视频编码技术

> 1．低码率（Low Bit Rate）：和MPEG2和MPEG4 ASP等压缩技术相比，在同等图像质量下，采用H.264技术压缩后的数据量只有MPEG2的1/8，MPEG4的1/3。  
> 2．高质量的图象：H.264能提供连续、流畅的高质量图象（DVD质量）。  
> 3．容错能力强：H.264提供了解决在不稳定网络环境下容易发生的丢包等错误的必要工具。  
> 4．网络适应性强：H.264提供了网络抽象层（Network Abstraction Layer），使得H.264的文件能容易地在不同网络上传输（例如互联网，CDMA，GPRS，WCDMA，CDMA2000等）。
> 
> from:https://baike.baidu.com/item/H.264/1022230?fr=aladdin&fromid=7338504&fromtitle=H264


## WebM 格式视频

> WebM 格式，其实是以 Matroska（就是我们熟知的 MKV）容器格式为基础开发的新容器格式，里面包括了 VP8 视频和 Ogg Vorbis 音轨  
> Google 说 WebM 格式相当有效率，应该可以在上网本、平板电脑、手持设备等中流畅地使用，当然自家的 Youtube 也会支持 WebM 的播放。
> 
> from:https://baike.baidu.com/item/WebM/2455966?fr=aladdin
> 


## VP9 视频编码标准

> VP9是一个由Google开发的开放格式、无使用授权费的视频压缩标准。VP9在开发初期曾被命名为Next Gen Open Video （NGOV，下一代开放视频）与VP-Next。VP9将是VP8的后继者。  
> 
> VP9相比VP8有着很多的提升。在比特率方面，VP9比VP8提高2倍图像画质，H265的画质也比H264高2倍。
>   
> VP9一大的优势是没有版税。和H.264(2013年cisco已将H.264开源)和H.265不同，它免费进行使用。
> 
> from:https://baike.baidu.com/item/VP9

## 视频中码率是什么意思

> 码率也叫比特率，表示经过压缩编码后的视音频数据每秒需要用多少个比特来表示，即把每秒显示的图像进行压缩后的数据量，一般采用的单位是kbps即千位每秒。  
> 一般来说码率越大，处理出来的文件就越接近原始文件，但文件体积与码率是成正比的，所以几乎所有的编码格式重视的都是如何用最低的码率达到最少的失真，
> 
> https://zhidao.baidu.com/question/585324055.html


## VP9和H265区别

> 尽管Google在不同场合都宣称VP9编码效果高于H.264之类的，但是H.264及后续的H.265与VP9的差距并不是技术上的，二者都能支持8K视频，满足未来一段时间内视频编码的需求都是没问题的，而VP9的杀手锏是无版权费，肯定会受到厂商的热烈欢迎的。不过VP9也有不利之处，进度上要慢于H.264及H.265。

> H.265与VP9现在还谈不上谁是最后的胜利者，这场竞赛也不是赢家通吃的，因为Google的目标是提供多一个选择，而不是完全取代H.264/H.265，很多厂商都会同时支持这两种标准的。

[编码技术的发展和什么叫视频的硬解，软解](http://www.expreview.com/32376-all.html)

* 第一代编码标准: MPEG-2、H.264、VC-1  
* 第二代编码标准：H.265、VP9  
* 4k视频编码技术：4K视频编码：H.264、H.265、VP9

## 4K视频

> 4K数字电影是指分辨率为4096×2160的数字电影，故又被称之为2160P，即横向有4千个像素点，是目前分辨率最高的数字电影。目前国内大多数的数字电影是2K的，分辨率为2048×1080，还有部分数字电影是1.3K（1280×1024）的，而所谓有农村电影放映的是1K（1024×768）的。真正意义上的4K电影由4K摄像机拍摄，用4K放映机放映。
> 
> from:https://baike.baidu.com/item/4K%E7%94%B5%E5%BD%B1/9022651?fr=aladdin

## HDCP是什么

> HDCP（High -bandwidth Digital Content Protection）：高带宽数字内容保护技术。HDTV（高清电视）时代即将来临，为了适应高清电视的高带宽，出现了HDMI。HDMI是一种高清数字接口标准，它可以提供很高的带宽，无损地传输数字视频和音频信号。为了保证HDMI或者DVI传输的高清晰信号不会被非法录制，就出现了高带宽数字内容保护技术，即HDCP技术。HDCP技术规范由Intel领头完成。当用户进行非法复制时，该技术会进行干扰，降低复制出来的影像的质量，从而对内容进行保护。
> 
> https://baike.baidu.com/item/HDCP/2654587?fr=aladdin


## AAC(高级音频编码)

> AAC，全称Advanced Audio Coding，是一种专为声音数据设计的文件压缩格式。与MP3不同，它采用了全新的算法进行编码，更加高效，具有更高的“性价比”。利用AAC格式，可使人感觉声音质量没有明显降低的前提下，更加小巧。苹果ipod、诺基亚手机支持AAC格式的音频文件。
> 
> 优点：相对于mp3，AAC格式的音质更佳，文件更小。

> 不足：AAC属于有损压缩的格式，与时下流行的APE、FLAC等无损格式相比音质存在“本质上”的差距。加之，传输速度更快的USB3.0和16G以上大容量MP3正在加速普及，也使得AAC头上“小巧”的光环不复存在。

> from:https://baike.baidu.com/item/aac/382962?fr=aladdin


## TS文件

> ts是日本高清摄像机拍摄下进行的封装格式，全称为MPEG2-TS。ts即"Transport Stream"的缩写。MPEG2-TS格式的特点就是要求从视频流的任一片段开始都是可以独立解码的。

> 而MPEG-TS则主要应用于实时传送的节目，比如实时广播的电视节目。
> 
> from: https://baike.baidu.com/item/TS%E6%96%87%E4%BB%B6/9554188

## FMP4(Fragment mp4)

> A fragmented MP4 contains a series of segments which can be requested individually if your server supports byte-range requests.

> from:https://stackoverflow.com/questions/35177797/what-exactly-is-fragmented-mp4fmp4-how-is-it-different-from-normal-mp4

## DASH, HLS, SmoothSreaming adaptive playback

自适应流媒体播放，之前的文章中有记录，略...



