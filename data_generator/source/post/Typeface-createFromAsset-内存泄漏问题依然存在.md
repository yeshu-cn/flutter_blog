---
title: Typeface.createFromAsset 内存泄漏问题依然存在
date: 2016-09-20 11:05:30
tags:
---

https://code.google.com/p/android/issues/detail?id=9904

这评论说在3.2上已经修复了该问题，新framework中也却是添加了`staem->unref()`,但是自己在5.0.2上使用自定义字体依然存在内存泄漏.不知道哪里造成的



```bash
$ adb shell dumpsys meminfo work.yeshu.tfftest
Applications Memory Usage (kB):
Uptime: 167918 Realtime: 167918

** MEMINFO in pid 8200 [work.yeshu.tfftest] **
                   Pss  Private  Private  Swapped     Heap     Heap     Heap
                 Total    Dirty    Clean    Dirty     Size    Alloc     Free
                ------   ------   ------   ------   ------   ------   ------
  Native Heap     3837     3760        0        0    12180    10072       15
  Dalvik Heap     4165     3764        0        0    32000    19470    12530
 Dalvik Other      732      732        0        0
        Stack      228      228        0        0
    Other dev        5        0        4        0
     .so mmap     1730      248      172      200
    .apk mmap      319        0       12        0
    .ttf mmap      146        0       40        0
    .dex mmap     2980        0     2876        0
    code mmap     1355        0      220        0
   image mmap     1538      876      364        0
   Other mmap      369        4      200        0
     Graphics     2720     2720        0        0
           GL     9276     9276        0        0
      Unknown     1994     1980        0        0
        TOTAL    31394    23588     3888      200    44180    29542    12545

 Objects
               Views:       32         ViewRootImpl:        1
         AppContexts:        3           Activities:        1
              Assets:        8        AssetManagers:        8
       Local Binders:       12        Proxy Binders:       16
    Death Recipients:        1
     OpenSSL Sockets:        0

 SQL
         MEMORY_USED:        0
  PAGECACHE_OVERFLOW:        0          MALLOC_SIZE:        0


 Asset Allocations
    zip:/data/app/work.yeshu.tfftest-2/base.apk:/assets/SanzenPersonalUse.ttf: 351K
    zip:/data/app/work.yeshu.tfftest-2/base.apk:/assets/SanzenPersonalUse.ttf: 351K
```

重复打开页面Asset Allocations会不停的增加

处理方法

```java
public class FontCache {
    private static Hashtable<String, Typeface> fontCache = new Hashtable<String, Typeface>();

    public static Typeface get(String name, Context context) {
        Typeface tf = fontCache.get(name);
        if(tf == null) {
            try {
                tf = Typeface.createFromAsset(context.getAssets(), name);
            }
            catch (Exception e) {
                return null;
            }
            fontCache.put(name, tf);
        }
        return tf;
    }

}
```


