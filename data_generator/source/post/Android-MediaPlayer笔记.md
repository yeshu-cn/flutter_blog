---
title: Android MediaPlayer笔记
permalink: android-mediaplayerbi-ji
id: 48
updated: '2015-10-16 12:54:30'
date: 2015-10-16 12:51:38
tags:
---


# 笔记
You can play back the audio data only to the standard output device. Currently, that is the mobile device speaker or a Bluetooth headset. You cannot play sound files in the conversation audio during a call.

## Manifest 声明
* Internet Permission - If you are using MediaPlayer to stream network-based content, your application must request network access.  
`<uses-permission android:name="android.permission.INTERNET" />`

* Wake Lock Permission - If your player application needs to keep the screen from dimming or the processor from sleeping, or uses the MediaPlayer.setScreenOnWhilePlaying() or MediaPlayer.setWakeMode() methods, you must request this permission.  
`<uses-permission android:name="android.permission.WAKE_LOCK" />`

## MediaPlayer使用
One of the most important components of the media framework is the MediaPlayer class. An object of this class can fetch, decode, and play both audio and video with minimal setup. It supports several different media sources such as:

* Local resources
* Internal URIs, such as one you might obtain from a * Content Resolver
* External URLs (streaming)

Android支持播放的媒体格式：<https://developer.android.com/guide/appendix/media-formats.html>

播放/res/raw/中文件
```java
// no need to call prepare(); create() does that for you
MediaPlayer mediaPlayer = MediaPlayer.create(context, R.raw.sound_file_1);
mediaPlayer.start();
```

a URI available locally in the system
```java
Uri myUri = ....; // initialize Uri here
MediaPlayer mediaPlayer = new MediaPlayer();
mediaPlayer.setAudioStreamType(AudioManager.STREAM_MUSIC);
mediaPlayer.setDataSource(getApplicationContext(), myUri);
mediaPlayer.prepare();
mediaPlayer.start();
```

Playing from a remote URL via HTTP streaming
```java
String url = "http://........"; // your URL here
MediaPlayer mediaPlayer = new MediaPlayer();
mediaPlayer.setAudioStreamType(AudioManager.STREAM_MUSIC);
mediaPlayer.setDataSource(url);
mediaPlayer.prepare(); // might take long! (for buffering, etc)
mediaPlayer.start();
```
__Note:__ If you're passing a URL to stream an online media file, the file must be capable of progressive download.

__Caution:__ You must either catch or pass IllegalArgumentException and IOException when using setDataSource(), because the file you are referencing might not exist.

### Asynchronous Preparation
the call to `prepare()` can take a long time to execute, because it might involve fetching and decoding media data.

remember that anything that takes more than a tenth of a second to respond in the UI will cause a noticeable pause and will give the user the impression that your application is slow.

this pattern is so common when using `MediaPlayer` that the framework supplies a convenient way to accomplish this task by using the `prepareAsync()` method. This method starts preparing the media in the background and returns immediately. When the media is done preparing, the `onPrepared()` method of the `MediaPlayer.OnPreparedListener`, configured through `setOnPreparedListener()` is called.


### Managing State
When you call stop(), however, notice that you cannot call start() again until you prepare the MediaPlayer again.

状态表：<https://developer.android.com/images/mediaplayer_state_diagram.gif>

calling its methods from the wrong state is a common cause of bug

### Releasing the MediaPlayer
you should always take extra precautions to make sure you are not hanging on to a `MediaPlayer` instance longer than necessary. When you are done with it, you should always call `release()` to make sure any system resources allocated to it are properly released. For example, if you are using a MediaPlayer and your activity receives a call to onStop(), you must release the `MediaPlayer`, because it makes little sense to hold on to it while your activity is not interacting with the user (unless you are playing media in the background, which is discussed in the next section). When your activity is resumed or restarted, of course, you need to create a new `MediaPlayer` and prepare it again before resuming playback.

释放资源
```java
mediaPlayer.release();
mediaPlayer = null;
```
资源浪费场景
if you forgot to release the `MediaPlayer` when your activity is stopped, but create a new one when the activity starts again.此时横竖屏切换

## Using a Service with MediaPlayer

### Running asynchronously
in fact,if you're running an activity and a service from the same application, they use the same thread (the "main thread") by defaul

Service中播放语音
```java
public class MyService extends Service implements MediaPlayer.OnPreparedListener {
    private static final String ACTION_PLAY = "com.example.action.PLAY";
    MediaPlayer mMediaPlayer = null;

    public int onStartCommand(Intent intent, int flags, int startId) {
        ...
        if (intent.getAction().equals(ACTION_PLAY)) {
            mMediaPlayer = ... // initialize it here
            mMediaPlayer.setOnPreparedListener(this);
            mMediaPlayer.prepareAsync(); // prepare async to not block main thread
        }
    }

    /** Called when MediaPlayer is ready */
    public void onPrepared(MediaPlayer player) {
        player.start();
    }
}
```

### Handling asynchronnous errors
It's important to remember that when an error occurs, the `MediaPlayer` moves to the Error state (see the documentation for the `MediaPlayer` class for the full state diagram) and you must reset it before you can use it again.
```java
public class MyService extends Service implements MediaPlayer.OnErrorListener {
    MediaPlayer mMediaPlayer;

    public void initMediaPlayer() {
        // ...initialize the MediaPlayer here...

        mMediaPlayer.setOnErrorListener(this);
    }

    @Override
    public boolean onError(MediaPlayer mp, int what, int extra) {
        // ... react appropriately ...
        // The MediaPlayer has moved to the Error state, must be reset!
    }
}
```

### Using wake locks
the Android system tries to conserve battery while the device is sleeping, the system tries to shut off any of the phone's features that are not necessary, including the CPU and the WiFi hardware. However, if your service is playing or streaming music,

In order to ensure that your service continues to run under those conditions, you have to use "wake locks." A wake lock is a way to signal to the system that your application is using some feature that should stay available even if the phone is idle.

__Notice:__ You should always use wake locks sparingly and hold them only for as long as truly necessary, because they significantly reduce the battery life of the device.

To ensure that the CPU continues running while your MediaPlayer is playing, call the setWakeMode() method when initializing your MediaPlayer. Once you do, the MediaPlayer holds the specified lock while playing and releases the lock when paused or stopped:


 CPU remains awake
```java
mMediaPlayer = new MediaPlayer();
// ... other initialization here ...
mMediaPlayer.setWakeMode(getApplicationContext(), PowerManager.PARTIAL_WAKE_LOCK);
```

hold a WifiLock as well
```java
WifiLock wifiLock = ((WifiManager) getSystemService(Context.WIFI_SERVICE))
    .createWifiLock(WifiManager.WIFI_MODE_FULL, "mylock");

wifiLock.acquire();
```
When you pause or stop your media, or when you no longer need the network, you should release the lock:
```java
wifiLock.release();
```

### Running as foreground service
用户需要进行交互的Activity
A foreground service holds a higher level of importance within the system—the system will almost never kill the service, because it is of immediate importance to the user. When running in the foreground, the service also must provide a status bar notification to ensure that users are aware of the running service and allow them to open an activity that can interact with the service

In order to turn your service into a foreground service, you must create a Notification for the status bar and call startForeground() from the Service. For example:
```java
String songName;
// assign the song name to songName
PendingIntent pi = PendingIntent.getActivity(getApplicationContext(), 0,
                new Intent(getApplicationContext(), MainActivity.class),
                PendingIntent.FLAG_UPDATE_CURRENT);
Notification notification = new Notification();
notification.tickerText = text;
notification.icon = R.drawable.play0;
notification.flags |= Notification.FLAG_ONGOING_EVENT;
notification.setLatestEventInfo(getApplicationContext(), "MusicPlayerSample",
                "Playing: " + songName, pi);
startForeground(NOTIFICATION_ID, notification);
```


只有真正需要时才使用`foreground service`状态，不用是release it
```java
stopForeground(true);
```

### Handling audio focus
请求获取focus
```java
AudioManager audioManager = (AudioManager) getSystemService(Context.AUDIO_SERVICE);
int result = audioManager.requestAudioFocus(this, AudioManager.STREAM_MUSIC,
    AudioManager.AUDIOFOCUS_GAIN);

if (result != AudioManager.AUDIOFOCUS_REQUEST_GRANTED) {
    // could not get audio focus.
}
```

The first parameter to `requestAudioFocus()` is an `AudioManager.OnAudioFocusChangeListener`
```java
class MyService extends Service
                implements AudioManager.OnAudioFocusChangeListener {
    // ....
    public void onAudioFocusChange(int focusChange) {
        // Do something based on focus change...
    }
}
```

`focusChange` value:  
* AUDIOFOCUS_GAIN: You have gained the audio focus.
* AUDIOFOCUS_LOSS: You have lost the audio focus for a presumably long time. You must stop all audio playback. Because you should expect not to have focus back for a long time, this would be a good place to clean up your resources as much as possible. For example, you should release the MediaPlayer.
* AUDIOFOCUS_LOSS_TRANSIENT: You have temporarily lost audio focus, but should receive it back shortly. You must stop all audio playback, but you can keep your resources because you will probably get focus back shortly.
* AUDIOFOCUS_LOSS_TRANSIENT_CAN_DUCK: You have temporarily lost audio focus, but you are allowed to continue to play audio quietly (at a low volume) instead of killing audio completely.

```java
public void onAudioFocusChange(int focusChange) {
    switch (focusChange) {
        case AudioManager.AUDIOFOCUS_GAIN:
            // resume playback
            if (mMediaPlayer == null) initMediaPlayer();
            else if (!mMediaPlayer.isPlaying()) mMediaPlayer.start();
            mMediaPlayer.setVolume(1.0f, 1.0f);
            break;

        case AudioManager.AUDIOFOCUS_LOSS:
            // Lost focus for an unbounded amount of time: stop playback and release media player
            if (mMediaPlayer.isPlaying()) mMediaPlayer.stop();
            mMediaPlayer.release();
            mMediaPlayer = null;
            break;

        case AudioManager.AUDIOFOCUS_LOSS_TRANSIENT:
            // Lost focus for a short time, but we have to stop
            // playback. We don't release the media player because playback
            // is likely to resume
            if (mMediaPlayer.isPlaying()) mMediaPlayer.pause();
            break;

        case AudioManager.AUDIOFOCUS_LOSS_TRANSIENT_CAN_DUCK:
            // Lost focus for a short time, but it's ok to keep playing
            // at an attenuated level
            if (mMediaPlayer.isPlaying()) mMediaPlayer.setVolume(0.1f, 0.1f);
            break;
    }
}
```

Keep in mind that the audio focus APIs are available only with API level 8 (Android 2.2) and above

### Performing cleanup
`Servcie`的`onDesotry()`方法中一定记得释放资源
```java
public class MyService extends Service {
   MediaPlayer mMediaPlayer;
   // ...

   @Override
   public void onDestroy() {
       if (mMediaPlayer != null) mMediaPlayer.release();
   }
}
```


## Handling the AUDIO_BECOMING_NOISY Intent

ACTION_AUDIO_BECOMING_NOISY

## Retrieving Media from a Content Resolver






参考：<http://developer.android.com/guide/topics/media/mediaplayer.html>
一篇英文，看了两个小时...






