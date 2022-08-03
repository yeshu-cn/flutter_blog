---
title: MediaPlayer使用
permalink: mediaplayershi-yong
id: 88
updated: '2016-08-05 08:10:38'
date: 2016-08-05 08:04:11
tags:
---


MediaPlayer有时没有回调OnCompletionListener,并报错：｀MediaPlayer finalized without being released｀

```java
        MediaPlayer mediaPlayer = MediaPlayer.create(mContext, rawId);
        mediaPlayer.setOnCompletionListener(new MediaPlayer.OnCompletionListener() {
            @Override
            public void onCompletion(MediaPlayer mp) {
                mp.release();
            }
        });
        mediaPlayer.start();
```

原因：成员变量被gc回收了，导致没有回调成功（或者播放至一半就停了）。保持mediaPlayer引用，防止被改成回收




参考：http://stackoverflow.com/questions/15023037/garbage-collection-causes-mediaplayer-finalized-without-being-released