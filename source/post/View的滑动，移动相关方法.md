---
title: View的滑动，移动相关方法
permalink: viewde-hua-dong-yi-dong-xiang-guan-fang-fa
id: 75
updated: '2016-05-11 07:36:05'
date: 2016-05-03 10:10:14
tags:
---

**移动View的方法：**

```java
view.layout(mOriLeft, mOriTop, mOriRight, mOriBottom); 
```

**view的内容移动流程**

`scrollTo()`/`scrllBy()`—>`invalidate()`/`postInvalidate()`——>`computeScroll()`;


**Scroller只是用来计算合适的滑动坐标**


```java
	@Override  
   public void computeScroll() {  
       
         //先判断mScroller滚动是否完成  
         if (mScroller.computeScrollOffset()) {  
           
             //这里调用View的scrollTo()完成实际的滚动  
             scrollTo(mScroller.getCurrX(), mScroller.getCurrY());  
               
             //必须调用该方法，否则不一定能看到滚动效果  
             postInvalidate();  
        }  
         super.computeScroll();  
	}
```


**Scroller使用：**

1. `scroller = new Scroller(Context)`
2. 调用`Scroller.startScroll()`或者`Scroller.fliing()`;
3. 调用`invalidate()`确保回调`computeScroll()`方法
4. 复写`computeScroll()`,并在其中调用`view.scrollTo`/`view.scrollBy`
5. 调用`invalidate()`确保刷新界面

**VelocityTracker使用**

1. `mVelocityTracker = VelocityTracker.obtain()`;使用`obtain()`方法获取实例
2. 调用`addMovement(Motion Event)`函数将`Motion event` 加入到`VelocityTracker`类中
3. 调用`computeCurrentVelocity(int)`来初始化速率单位
4. 调用`getXVelocity()`或`getYVelocity()`来获取速率


**overScrollBy使用**

1. 调用`overScrollBy`，计算需要滑动的x,y坐标和是否`clamped`（滑到顶端了）
2. `overScrollBy`会回调`onOverScrolled`方法
3. 复写`onOverScrolled`方法执行真正的继续滑动，或者回弹

总结：

1. `Scroller`使用，必须配合`computeScroll`来执行真正的滑动
2. `overScrollBy`使用，必须配合`onOverScrolled`来执行真正的滑动

`computeScroll()`和`onOverScrolled()`默认都是空函数，等着用户来复写

**函数参数详解：**

```java
protected boolean overScrollBy(int deltaX, int deltaY, int scrollX, int scrollY, int scrollRangeX, int scrollRangeY, int maxOverScrollX, int maxOverScrollY, boolean isTouchEvent)

private int mOverScrollDistance = 100;
//横向滑动
overScrollBy(deltaX, 0, (int)scrollX, getScrollY(), getScrollRangeX(), 0, mOverScrollDistance, 0, true);

public void fling(int startX, int startY, int velocityX, int velocityY, int minX, int maxX, int minY, int maxY, int overX, int overY) 

private int mOverflingDistance = 50;
//横向滑动
mScroller.fling(getScrollX(), getScrollY(), velocityX, 0, 0, getScrollRangeX(), 0, 0, mOverflingDistance, 0);

//横向回弹效果
public boolean springBack(int startX, int startY, int minX, int maxX, int minY, int maxY)
mScroller.springBack(getScrollX(), getScrollY(), 0, getScrollRangeX(), 0, 0)) 


//处理多点触碰的干扰
//获取触碰点id
mActivePointerId = event.getPointerId(0);

//获取触碰点x坐标
final int activePointerIndex = event.findPointerIndex(mActivePointerId);
float x = event.getX(activePointerIndex);

//获取触碰点velocity
int initialVelocity = (int) velocityTracker.getXVelocity(mActivePointerId);
```

资料：<http://www.eoeandroid.com/thread-553375-1-9.html?_dsign=404ec396>
将文章中的Demo运行一下就非常清楚了
