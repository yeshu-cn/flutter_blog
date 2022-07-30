---
title: HashMap源码笔记
permalink: hashmapyuan-ma-bi-ji
id: 84
updated: '2016-05-31 07:42:40'
date: 2016-05-30 11:51:11
tags:
---


数组：寻址容易，插入和删除困难

链表：寻址困难，插入和删除容易

HashMap:寻址容易，插入和删除也容易

实现原理:数组+链表的方式实现快速读取和修改

```java
    public V put(K key, V value) {
        if (table == EMPTY_TABLE) {
            inflateTable(threshold);
        }
        if (key == null)
            return putForNullKey(value);
        int hash = hash(key);
        //通过hash快速计算得到数组的index
        int i = indexFor(hash, table.length);
        for (Entry<K,V> e = table[i]; e != null; e = e.next) {
            Object k;
            if (e.hash == hash && ((k = e.key) == key || key.equals(k))) {
                V oldValue = e.value;
                e.value = value;
                e.recordAccess(this);
                return oldValue;
            }
        }

        modCount++;
        addEntry(hash, key, value, i);
        return null;
    }
```

```java
    final Entry<K,V> getEntry(Object key) {
        if (size == 0) {
            return null;
        }

        int hash = (key == null) ? 0 : hash(key);
        //e = e.next,处理hash冲突时遍历链表获取值，叫链地址法
        for (Entry<K,V> e = table[indexFor(hash, table.length)];
             e != null;
             e = e.next) {
            Object k;
            if (e.hash == hash &&
                ((k = e.key) == key || (key != null && key.equals(k))))
                return e;
        }
        return null;
    }
```

这两个函数就是将key转换为index的地方

    其中h是hash值，length是数组的长度，这个按位与的算法其实就是h%length求余，一般什么情况下利用该算法，典型的分组。例如怎么将100个数分组16组中，就是这个意思。应用非常广泛。

```java
    final int hash(Object k) {
        int h = hashSeed;
        if (0 != h && k instanceof String) {
            return sun.misc.Hashing.stringHash32((String) k);
        }

        h ^= k.hashCode();
        h ^= (h >>> 20) ^ (h >>> 12);
        return h ^ (h >>> 7) ^ (h >>> 4);
    }


    static int indexFor(int h, int length) {
        return h & (length-1);
    }
```

hash冲突的解决方法
1. 开放定址法
2. 再哈希法
3. 链地址法
4. 建立一 公共溢出区


使用注意

* HashMap存在一个默认75%的负载因子，当容量超过负载因子时会resize。resize会重新计算各个元素的索引。所以最好初始化时就声明好大小。
* Android中在数据量不大的情况下可以用`SparseArray`,`ArrayMap`代替，它们能节省内存空间。 


`SparseArray`,`ArrayMap`优点：节省内存空间，用到了二分查找，避免了自动装箱。

```java
    static int binarySearch(int[] array, int size, int value) {
        int lo = 0;
        int hi = size - 1;

        while (lo <= hi) {
            final int mid = (lo + hi) >>> 1;
            final int midVal = array[mid];

            if (midVal < value) {
                lo = mid + 1;
            } else if (midVal > value) {
                hi = mid - 1;
            } else {
                return mid;  // value found
            }
        }
        return ~lo;  // value not present
    }
```

资料

* http://www.jianshu.com/p/8b372f3a195d
* http://blog.csdn.net/lcore/article/details/8885961