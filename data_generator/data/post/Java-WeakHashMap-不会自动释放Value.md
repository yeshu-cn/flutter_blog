---
title: Java WeakHashMap 不会自动释放Value
date: 2016-09-23 18:03:25
tags:
---



WeakHashMap中只有key才是WeakReference,可以被gc自动回收，但是Value是强引用，需要调用get/put方法才会触发回收




> 1. 如果构造函数中指定了ReferenceQueue，那么事后程序员可以通过该队列清理引用
> 2. 如果构造函数中没有指定了ReferenceQueue，那么 GC 会自动清理引用
> 3. 当弱引用指向的对象只能通过弱引用（没有强引用或弱引用）访问时，GC会清理掉该对象，之后，引用对象会被放到ReferenceQueue中

参考：[Java WeakHashMap源码解析](http://liujiacai.net/blog/2015/09/27/java-weakhashmap/) 写的很详细

```java
public class WeakReference<T> extends Reference<T> {

    public WeakReference(T r) {
        super(r, null);
    }

	//q是用来指向自己的，让gc清理“引用”这个对象
    public WeakReference(T r, ReferenceQueue<? super T> q) {
        super(r, q);
    }
}
```

Entry对象是个引用对象

```java
public class WeakHashMap<K, V> extends AbstractMap<K, V> implements Map<K, V> {
	private final ReferenceQueue<K> referenceQueue;
	
	private static final class Entry<K, V> extends WeakReference<K> implements Map.Entry<K, V> {
		Entry(K key, V object, ReferenceQueue<K> queue) {
			//只有 key是weakReference
			super(key, queue);
			//...
		}
	}
	
	//...
}
```





```java
public V put(K key, V value) {
		//这个函数中处理了referenceQueuqe中对象的手动删除
        poll();
        int index = 0;
        Entry<K, V> entry;
		
		//...
        if (entry == null) {
            modCount++;
            if (++elementCount > threshold) {
                rehash();
                index = key == null ? 0 : (Collections.secondaryHash(key) & 0x7FFFFFFF)
                        % elementData.length;
            }
            //实例化Entry时，传入了referenceQueue,所以该Entry对象需要自己手动释放
            entry = new Entry<K, V>(key, value, referenceQueue);
            entry.next = elementData[index];
            elementData[index] = entry;
            return null;
        }
        V result = entry.value;
        entry.value = value;
        return result;
    }
```


删除referenceQueue中的无效的Entry,释放内存空间

```
void poll() {
        Entry<K, V> toRemove;
        while ((toRemove = (Entry<K, V>) referenceQueue.poll()) != null) {
            removeEntry(toRemove);
        }
    }
```



