---
title: 自定义View和自定义ViewGroup
permalink: zi-ding-yi-viewhe-zi-ding-yi-viewgroup
id: 76
updated: '2016-05-11 07:37:11'
date: 2016-05-11 07:36:12
tags:
---

## 原理
绘制`View`的三个流程

1. `measure`->`onMeasure`计算出`view`的大小`mMeasureWidth`和`mMeasuredHeight`，并置`mPrivateFlags`状态为已测量`PFLAG_MEASURED_DIMENSION_SET`
2. `layout`->`onLayout`根据子`view`的大小计算所有自`view`的位置坐标`mLeft`,`mTop`,`mBottom`,`mRight`,并置`mPrivateFlags3`为已布局`PFLAG3_IS_LAID_OUT`
3. `draw`->`onDraw`根据前面计算的坐标绘制`View`的具体内容

Android中应用程序是按消息机制执行的，每次处理一个消息，如果该消息引起`View`的状态变化，则在代码中仅仅做一些状态表示，然后发送一个异步消息，而不是立即重绘。然后在下一次消息处理中，根据保存的状态数据，绘制不同的界面效果。

layout_width意义：自己期望父视图给自己的大小，可以近似的看做是自己的大小设定。将和父视图的layout_width一起确定自己的大小。


## CustomView

可以参考`TextView`,`ImageView`源码

1. 继承自View
2. 重写onMeasure()方法
3. 重写onDraw()方法

protected void onMeasure(int widthMeasureSpec, int heightMeasureSpec)
1. `widthMeasureSpec`, `heightMeasureSpec`由父视图通过xml中定义的`layout_width`,`layout_height`结合自己的大小算出来的子视图的大小`规格`
2. 在该函数中我们需要通过自己的**实际大小**结合**规格**算出最后的结果
3. `resolveSize(width, widthMeasureSpec)`函数实现上述功能，第一个参数表示**实际大小**，第二个参数表示父视图传给我们的**规格**
4. `setMeasuredDimension `函数来设置最终的大小

View没有子视图，所以不需要去调用子视图的`measure()`,不需要调用子视图的`layout()`


```java
public class CustomView extends View {
    private Paint mPaint;
    private Drawable mDrawable;

    public CustomView(Context context) {
        super(context);
        init();
    }

    public CustomView(Context context, AttributeSet attrs) {
        this(context, attrs, 0);
    }

    public CustomView(Context context, AttributeSet attrs, int defStyleAttr) {
        this(context, attrs, defStyleAttr, 0);
    }

    @TargetApi(Build.VERSION_CODES.LOLLIPOP)
    public CustomView(Context context, AttributeSet attrs, int defStyleAttr, int defStyleRes) {
        super(context, attrs, defStyleAttr, defStyleRes);
        TypedArray a = context.getTheme().obtainStyledAttributes(
                attrs,
                R.styleable.CustomView,
                defStyleAttr, defStyleRes
        );

        mDrawable = a.getDrawable(R.styleable.CustomView_bg);
        a.recycle();

        init();
    }

    private void init() {
        mPaint = new Paint();
        mPaint.setAntiAlias(true);
        mPaint.setColor(Color.RED);
        mPaint.setStyle(Paint.Style.STROKE);
    }

    @Override
    protected void onDraw(Canvas canvas) {
        drawBackground(canvas);
    }

    private void drawBackground(Canvas canvas) {
        //getIntrinsicWidth获取的是图片拉伸后的大小
        int width = mDrawable.getIntrinsicWidth();
        int height = mDrawable.getIntrinsicHeight();
        mDrawable.setBounds(getPaddingLeft(), getPaddingTop(), getWidth() - getPaddingRight(), getHeight() - getPaddingBottom());
        mDrawable.draw(canvas);
        canvas.drawRect(0, 0, getWidth(), getHeight(), mPaint);
    }



    @Override
    protected void onMeasure(int widthMeasureSpec, int heightMeasureSpec) {
        //如果不重写，自定义View在默认情况下不管是math_parent还是warp_content都能占满父容器的剩余空间。具体原因跟下代码就知道了。
        //super.onMeasure(widthMeasureSpec, heightMeasureSpec);
        int width = mDrawable.getIntrinsicWidth() + getPaddingLeft() + getPaddingRight();
        int height = mDrawable.getIntrinsicHeight() + getPaddingTop() + getPaddingBottom();
        //view的大小由自己想要的大小和Constraints imposed by the parent确定
        //其中widthMeasureSpec由parent调用childWidthMeasureSpec = getChildMeasureSpec(parentWidthMeasureSpec, mPaddingLeft + mPaddingRight, lp.width);获取
        //获取childMeasureSpec需要由父控件的规格+自己想要的规格综合确定
        setMeasuredDimension(resolveSize(width, widthMeasureSpec), resolveSize(height, heightMeasureSpec));
    }

}
```

## CustomViewGroup

可以参考`FrameLayout`,`LinearLayout`等源码

1. 继承`ViewGroup`,并实现构造函数
2. 重写`onMeasrure()`,处理子视图的`measure`并设置自己的宽高
3. 重写`onLayout()`，处理子视图的`layout`
4. 重写`generateLayoutParams `系类函数，因为默认的LayoutParams只有`layout_width`和`layout_height`属性，处理不了`margin`。具体怎么用参考`LienarLayout`源码中怎么处理的


处理子视图的`measure`，直接调用`measureChild()`或者`measureChildWithMargins()`,`measureChildren()`

```java
    protected void measureChild(View child, int parentWidthMeasureSpec,
            int parentHeightMeasureSpec) {
            //这里父视图读取了xml中的layoutParams,综合自己情况算出子视图的规格
        final LayoutParams lp = child.getLayoutParams();
			
        final int childWidthMeasureSpec = getChildMeasureSpec(parentWidthMeasureSpec,
                mPaddingLeft + mPaddingRight, lp.width);
        final int childHeightMeasureSpec = getChildMeasureSpec(parentHeightMeasureSpec,
                mPaddingTop + mPaddingBottom, lp.height);

        child.measure(childWidthMeasureSpec, childHeightMeasureSpec);
    }
```

处理子视图的`layout`,直接调用`child.layout(.....)`



```java
public class CustomViewGroup extends ViewGroup {

    public CustomViewGroup(Context context) {
        super(context);
        init();
    }

    public CustomViewGroup(Context context, AttributeSet attrs) {
        this(context, attrs, 0);
    }

    public CustomViewGroup(Context context, AttributeSet attrs, int defStyleAttr) {
        this(context, attrs, defStyleAttr, 0);
    }

    @TargetApi(Build.VERSION_CODES.LOLLIPOP)
    public CustomViewGroup(Context context, AttributeSet attrs, int defStyleAttr, int defStyleRes) {
        super(context, attrs, defStyleAttr, defStyleRes);

        init();
    }

    private void init() {

    }

    @Override
    protected LayoutParams generateDefaultLayoutParams() {
        return super.generateDefaultLayoutParams();
    }

    @Override
    protected LayoutParams generateLayoutParams(LayoutParams p) {
        return super.generateLayoutParams(p);
    }

    @Override
    public LayoutParams generateLayoutParams(AttributeSet attrs) {
        return super.generateLayoutParams(attrs);
    }

    @Override
    protected boolean checkLayoutParams(LayoutParams p) {
        return super.checkLayoutParams(p);
    }

    @Override
    protected void onMeasure(int widthMeasureSpec, int heightMeasureSpec) {
        int childCount = getChildCount();

        int width = 0;
        int height = 0;

//        measureChildren(widthMeasureSpec, heightMeasureSpec);
        for (int i = 0; i < childCount; i++) {
            View child = getChildAt(i);
            if (child.getVisibility() != GONE) {
                measureChild(child, widthMeasureSpec, heightMeasureSpec);
                //width = width + child.getMeasuredWidth();
                width = Math.max(width, child.getMeasuredWidth());
                height = Math.max(height, child.getMeasuredHeight());
            }
        }
//        super.onMeasure(widthMeasureSpec, heightMeasureSpec);
        setMeasuredDimension(resolveSize(width, widthMeasureSpec), resolveSize(height, heightMeasureSpec));
    }

    @Override
    protected void onLayout(boolean changed, int l, int t, int r, int b) {
        for (int i = 0; i < getChildCount(); i++) {
            View child = getChildAt(i);

            int cl = 0;
            int ct = 0;
            int cb = child.getMeasuredHeight();
            int cr = child.getMeasuredWidth();
            child.layout(cl, ct, cr, cb);
        }
//        super.onLayout(changed, l, t, r, b);
    }


}
```

## 其他
measureSpec，onMeasure,onLayout,onDraw等基本概念
[http://www.eoeandroid.com/thread-556155-1-1.html]()

讲解`resolveSizeAndState`中`childMeasuredState`作用，基本上不用管它，传值0就行了。
[http://stackoverflow.com/questions/13650903/whats-the-utility-of-the-third-argument-of-view-resolvesizeandstate
]()

有讲resolveSizeAndState和MarginLayoutParams
[http://blog.csdn.net/aigestudio/article/details/43378131]()


自定义View和自定义Layout的例子，里面有将margin参数的处理
[http://blog.csdn.net/aigestudio/article/details/42989325]()

[http://blog.csdn.net/aigestudio/article/details/43907299]()
