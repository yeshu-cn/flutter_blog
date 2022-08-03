---
title: RecyclerView
date: 2016-09-01 16:11:55
tags:
---





`scrapped view` 是指依然attached在`RecyclerView`上，但是已经被标记了`删除`或者`复用`的`View` 。



RecyclerView三个内部类

* Recycler: 管理可复用的和正在使用的`View`

```java
	//由Adapter调用，返回新生成的View,或者scrap,detached View. 如果adpter通知了该position的数据没有变化，则直接使用这个View，而不会重新去绑定数据
	public View getViewForPosition(int position) {
	
	}
```

* ViewCacheExtension: 用户自定义的缓存策略

```java
public abstract static class ViewCacheExtension {

	abstract public View getViewForPositionAndType(Recycler recycle, int position, int type);
	
}
```

* RecycledViewPool:让你可以在多个`RecyclerView`之间共享，复用`View`




三级缓存

1. 先从Recycler中查找
2. 再从用户自定义的缓存中查找
3. 再从RecycledViewPool中查找


















