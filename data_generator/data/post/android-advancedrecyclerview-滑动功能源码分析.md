---
title: android-advancedrecyclerview 滑动功能源码分析
date: 2016-10-13 10:57:43
tags:
---

带着问题去阅读源码



### 问题

#### 如何实现滑动显示菜单的界面

itemView的布局

```xml
<?xml version="1.0" encoding="utf-8"?>
<!-- NOTE: should use FrameLayout or RelativeLayout for parent of the "@id/container" view (for Android 2.3 compatibility) -->
<FrameLayout
    style="@style/commonListItemStyle"
    xmlns:android="http://schemas.android.com/apk/res/android"
    xmlns:tools="http://schemas.android.com/tools"
    android:layout_width="match_parent"
    android:layout_height="@dimen/list_item_height"
    android:background="@drawable/bg_swipe_item_neutral">

    <FrameLayout
        android:id="@+id/container"
        android:layout_width="match_parent"
        android:layout_height="match_parent"
        android:clickable="true"
        android:foreground="?attr/selectableItemBackground"
        tools:ignore="UselessParent">

        <TextView
            android:id="@android:id/text1"
            android:layout_width="match_parent"
            android:layout_height="match_parent"
            android:layout_gravity="top|left"
            android:gravity="center"
            tools:ignore="RtlHardcoded"/>

    </FrameLayout>
</FrameLayout>


```

其中`container`就是正常情况下显示的item界面，菜单的界面是通过设置根容器`FrameLayout`的background实现，如下就是菜单的布局

```xml
<layer-list xmlns:android="http://schemas.android.com/apk/res/android">
    <item>
        <color android:color="@color/bg_swipe_group_item_pinned"/>
    </item>
    <item android:right="16dp">
        <bitmap
            android:src="@drawable/ic_item_swipe_pinned"
            android:gravity="right|center_vertical"/>
    </item>
</layer-list>
```

滑动时动态设置background以实现菜单的显示

```java
//设置菜单的显示
@Override
public void onSetSwipeBackground(MyViewHolder holder, int position, int type) {
    int bgRes = 0;
    switch (type) {
        case Swipeable.DRAWABLE_SWIPE_NEUTRAL_BACKGROUND:
                //没有滑动时显示默认背景
            bgRes = R.drawable.bg_swipe_item_neutral;
            break;
        case Swipeable.DRAWABLE_SWIPE_LEFT_BACKGROUND:
                //向左滑动时设置左菜单
            bgRes = R.drawable.bg_swipe_item_left;
            break;
        case Swipeable.DRAWABLE_SWIPE_RIGHT_BACKGROUND:
                //向右滑动时设置右菜单
            bgRes = R.drawable.bg_swipe_item_right;
            break;
    }

    //菜单界面，其实就是itemView的background
    holder.itemView.setBackgroundResource(bgRes);
}
```

监听holder.itemView的点击事件即为菜单的点击事件  
监听holder.itemView.container的点击事件即为item的点击事件

```java
public SwipeableExampleAdapter(AbstractDataProvider dataProvider) {
    //...
    mItemViewOnClickListener = new View.OnClickListener() {
        @Override
        public void onClick(View v) {
                //点击了holder.itemView
            onItemViewClick(v);
        }
    };
    mSwipeableViewContainerOnClickListener = new View.OnClickListener() {
        @Override
        public void onClick(View v) {
                //点击了item.itemView.container
            onSwipeableViewContainerClick(v);
        }
    };
    //...

}


private void onItemViewClick(View v) {
    if (mEventListener != null) {
        //pinned为true表示显示了菜单界面，这里即意味着菜单被点击了
        mEventListener.onItemViewClicked(v, true); // true --- pinned
    }
}

private void onSwipeableViewContainerClick(View v) {
    if (mEventListener != null) {
        //意味着item被点击了
        mEventListener.onItemViewClicked(RecyclerViewAdapterUtils.getParentViewHolderItemView(v), false);  // false --- not pinned
    }
}
```

#### 触摸事件判断是在哪里处理的

RecyclerViewSwipeManager中注册了RecyclerView.OnItemTouchListener,以实现将RecyclerView中的触摸事件转移到RecyclerViewSwipeManager中的`onInterceptTouchEvent`,`onTouchEvent`判断

```java
//new RecyclerViewSwipeManager时实例化Listener
public RecyclerViewSwipeManager() {
    mInternalUseOnItemTouchListener = new RecyclerView.OnItemTouchListener() {
        @Override
        public boolean onInterceptTouchEvent(RecyclerView rv, MotionEvent e) {
                //将RecyclerView的touch事件转移给自己处理
            return RecyclerViewSwipeManager.this.onInterceptTouchEvent(rv, e);
        }

        @Override
        public void onTouchEvent(RecyclerView rv, MotionEvent e) {
            RecyclerViewSwipeManager.this.onTouchEvent(rv, e);
        }

        @Override
        public void onRequestDisallowInterceptTouchEvent(boolean disallowIntercept) {
            RecyclerViewSwipeManager.this.onRequestDisallowInterceptTouchEvent(disallowIntercept);
        }
    };
    //...
}
```

```java
//attach recyclerView的时候注册Listener
public void attachRecyclerView(@NonNull RecyclerView rv) {
    //...
    mRecyclerView.addOnItemTouchListener(mInternalUseOnItemTouchListener);
    //..
}
```
RecyclerView中如果有touchListener消费了事件，则事件将不会继续传递给后续的函数,如下代码：

```java
//RecyclerView.java
public boolean onInterceptTouchEvent(MotionEvent e) {
    if (mLayoutFrozen) {
        // When layout is frozen,  RV does not intercept the motion event.
        // A child view e.g. a button may still get the click.
        return false;
    }
    if (dispatchOnItemTouchIntercept(e)) {
        cancelTouch();
        //如果事件被listener处理了，则到此结束了
        return true;
    }

    //...
｝

private boolean dispatchOnItemTouchIntercept(MotionEvent e) {
    final int action = e.getAction();
    if (action == MotionEvent.ACTION_CANCEL || action == MotionEvent.ACTION_DOWN) {
        mActiveOnItemTouchListener = null;
    }

    final int listenerCount = mOnItemTouchListeners.size();
    for (int i = 0; i < listenerCount; i++) {
        final OnItemTouchListener listener = mOnItemTouchListeners.get(i);
        if (listener.onInterceptTouchEvent(this, e) && action != MotionEvent.ACTION_CANCEL) {
            mActiveOnItemTouchListener = listener;
            //注意此处listener注册是有优先级的，只要有一个消费了就直接返回，剩余的listener不会再被调用了
            return true;
        }
    }
    return false;
}
    
```

#### 如何判断滑动还是滚动

RecyclerViewSwipeManager中`onInterceptTouchEvent`,`onTouchEvent`判断

```java
boolean onInterceptTouchEvent(RecyclerView rv, MotionEvent e) {
    final int action = MotionEventCompat.getActionMasked(e);

    switch (action) {
        case MotionEvent.ACTION_UP:
        case MotionEvent.ACTION_CANCEL:
            if (handleActionUpOrCancel(e, true)) {
                return true;
            }
            break;

        case MotionEvent.ACTION_DOWN:
            if (!isSwiping()) {
                handleActionDown(rv, e);
            }
            break;

        case MotionEvent.ACTION_MOVE:
            if (isSwiping()) {
                    //这个isSwiping()判断其实是不需要的，作者说有bug才加上这个。我没遇到这个bug
                // NOTE: The first ACTION_MOVE event will come here. (maybe a bug of RecyclerView?)
                handleActionMoveWhileSwiping(e);
                return true;
            } else {
                if (handleActionMoveWhileNotSwiping(rv, e)) {
                    //如果是滑动事件，则拦截
                    return true;
                }
            }
            break;
    }

    return false;
}

void onTouchEvent(RecyclerView rv, MotionEvent e) {
    final int action = MotionEventCompat.getActionMasked(e);

    switch (action) {
        case MotionEvent.ACTION_UP:
        case MotionEvent.ACTION_CANCEL:
            handleActionUpOrCancel(e, true);
            break;

        case MotionEvent.ACTION_MOVE:
            //滑动View
            handleActionMoveWhileSwiping(e);
            break;
    }
}
```

onInterceptTouchEvent中的ACTION_DOWN纪录按下时的状态，ACTION_MOVE中判断是滚动还是滑动，

如果是滑动则拦截事件,将以后ACTION_MOVE事件交由`onTouchEvent`中的`handleActionMoveWhileSwiping()`进行View的滑动。

如果是滚动事件，则不拦截，默认是RecyclerView的滚动

#### 详细看看是如何判断是滑动事件的

```java
//精简了下代码
private boolean handleActionMoveWhileNotSwiping(RecyclerView rv, MotionEvent e) {
        //...
        final int dx = (int) (e.getX() + 0.5f) - mInitialTouchX;
        final int dy = (int) (e.getY() + 0.5f) - mInitialTouchY;

        final int scrollAxisDelta; //滚动的距离
        final int swipeAxisDelta;        //滑动的距离

        scrollAxisDelta = dy;
        swipeAxisDelta = dx;

        //如果滚动的距离大于mTouchSlop，那么表示发生了滚动，直接返回false,让默认代码处理RecyclerView的滚动
        if (Math.abs(scrollAxisDelta) > mTouchSlop) {
            // scrolling occurred
            return false;
        }
        
        //如果滑动距离过小，那也不处理，返回false
        if (Math.abs(swipeAxisDelta) <= mTouchSlop) {
            return false;
        }
        
         //...
         return true;
    }
```

#### 判断滑动后如何滑动View

`RecyclerViewSwipeManager中`的`onTouchEvent`的`ACTION_MOVE`事件中会调用`handleActionMoveWhileSwiping()`方法滑动holder.itemView.container

```java
private void handleActionMoveWhileSwiping(MotionEvent e) {
    mLastTouchX = (int) (e.getX() + 0.5f);
    mLastTouchY = (int) (e.getY() + 0.5f);
    mVelocityTracker.addMovement(e);

    final int swipeDistanceX = mLastTouchX - mTouchedItemOffsetX;
    final int swipeDistanceY = mLastTouchY - mTouchedItemOffsetY;
    final int swipingItemPosition = getSwipingItemPosition();

    //SwipingItemOperator会去判断得出最终的滑动方式
    mSwipingItemOperator.update(swipingItemPosition, swipeDistanceX, swipeDistanceY);
}

public void update(int itemPosition, int swipeDistanceX, int swipeDistanceY) {
    //...

    //计算好各种滑动信息后，最终又回到了RecyclerViewSwipeManager.applySlideItem()中去了执行真正的滑动了
    mSwipeManager.applySlideItem(
            mSwipingItem, itemPosition,
            mPrevTranslateAmount, translateAmount, true,
            mSwipeHorizontal, false, true);

    mPrevTranslateAmount = translateAmount;
}

//applySlideItem又会调用slideItem
private void slideItem(RecyclerView.ViewHolder holder, float amount, boolean proportionalAmount, boolean horizontal, boolean shouldAnimate) {
    if (amount == OUTSIDE_OF_THE_WINDOW_LEFT) {
            //最后使用属性动画，设置setTranslationX属性去实现移动
        mItemSlideAnimator.slideToOutsideOfWindow(holder, ItemSlidingAnimator.DIR_LEFT, shouldAnimate, mMoveToOutsideWindowAnimationDuration);
    } 
    //...
}

```

### 架构设计

看它代码觉得每个类的职责划分的很明确

`SwipeableItemAdapter` ：

1. 成员ViewHolder负责UI
2. 成员AbstractDataProvider负责数据的提供和数据的删除，恢复，移动逻辑。
3. 成员EventListener负责交互事件的处理
4. 它继承子BaseSwipeableItemAdapter,其中定义了`onGetSwipeReactionType()`,`onSetSwipeBackground()`两个函数用于实现滑动时item背景变化和菜单的显示

`SwipeableItemWrapperAdapter` : 将RecyclerViewSwipeManager和Adapter关联起来

`RecyclerViewSwipeManager`：负责监测是否时滑动事件，并处理滑动相关的逻辑

1. 成员`SwippingItemOperator` ：处理swipe result
2. 成员`ItemSlidingAnimator` ：负责View的滑动

`RecyclerViewTouchActionGuardManager`：处理显示滑动动画时，屏蔽触摸事件


### 名词解释

* `ViewHolder.itemView` 为整个ItemView视图，包括隐藏的菜单
* `ViewHolder.mContainer` 为正常情况下显示的item（即holder.itemView.container）
* `pinned` 为true表示当前滑动菜单处于显示状态
* swipteState 滑动状态

        Switeable.STATE_FLAG_IS_ACTIVE //长按选中状态  
        Switeable.STATE_FLAG_IS_SWIPING //正在滑动状态 
* swipe result 滑动结果
    
        RESULT_NONE
        RESULT_CANCELED
        RESULT_SWIPED_LEFT
        RESULT_SWIPED_UP
        RESULT_SWIPED_RIGHT
        RESULT_SWIPED_DOWN



### 看源码时查的资料


1. 属性动画介绍（setTranslationX属性实现移动效果）：http://blog.csdn.net/yanzi1225627/article/details/47850471
2. Android坐标系介绍（很详细）:http://blog.csdn.net/yanbober/article/details/50419117
3. onInterceptTouchEvent中拦截判断一次成功后，就不需要再次判断了

> RecyclerView.OnItemTouchListener中，onInterceptTouchEvent拦截了ACTION_MOVE过后，后续的ACTION_MOVE事件分发就不在走onInterceptTouchEvent了，直接分发到onTouchEvent
> 
> onInterceptTouchEvent只会执行一次（dispatchTouchEvent发现mFirstTouchTarget为null，即后面没有需要接收事件的view时，就不会进行拦截判断了）：http://www.jianshu.com/p/8c9d2bdbac57























