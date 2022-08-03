---
title: Fragment使用中的常见异常
date: 2017-09-05 11:21:00
tags:
---

## 正确使用Fragment
如果系统重建Fragment会调用不带参数都构造函数，所以想要恢复保存参数需要使用`setArguments`方法设置参数`Bundle`。在Fragment重建时`Bundle`会自动保存下来。

```
public static MyFragment newInstance() {
    Bundle args = new Bundle();
    
    MyFragment fragment = new MyFragment();
    fragment.setArguments(args);
    return fragment;
}

public void onCreate() {
	Bundle args = getArguments();
	//...
}
```

```java
    @Override
    public View onCreateView(LayoutInflater inflater, ViewGroup container, Bundle savedInstanceState) {
        return inflater.inflate(R.layout.fragement, container, false); 
    }
```


`inflate(@LayoutRes int resource, @Nullable ViewGroup root, boolean attachToRoot)`参数说明：

1. root不为null, attachToRoot为true时，将生成的View添加到root中
2. root不为null, attachToRoot为false时，生成一个带params的View
3. root为null, attachToroot为false时, 生成一个不带params的View


**Fragment和Activity的数据交互**

为了解耦合,保持Fragment的独立性

1. Activity可以直接调用Fragment的public方法
2. Fragment通过callback通知Activity


## 使用getChildFragmentManager时的"no activity"异常

触发流程

1. 使用Fragment.getChildFragmentManager
2. Fragment重复使用，再次attatch

```
java.lang.IllegalStateException: No activity
	at android.app.FragmentManagerImpl.moveToState(FragmentManager.java:1060)
	at android.app.FragmentManagerImpl.moveToState(FragmentManager.java:1055)
	at android.app.FragmentManagerImpl.dispatchActivityCreated(FragmentManager.java:1864)
	at android.app.Fragment.performActivityCreated(Fragment.java:1714)
	at android.app.FragmentManagerImpl.moveToState(FragmentManager.java:919)
	at android.app.FragmentManagerImpl.moveToState(FragmentManager.java:1073)
	at android.app.BackStackRecord.run(BackStackRecord.java:698)
	at android.app.FragmentManagerImpl.execPendingActions(FragmentManager.java:1458)
	at android.app.FragmentManagerImpl$1.run(FragmentManager.java:443)
	at android.os.Handler.handleCallback(Handler.java:808)
	at android.os.Handler.dispatchMessage(Handler.java:103)
	at android.os.Looper.loop(Looper.java:193)
	at android.app.ActivityThread.main(ActivityThread.java:5332)
	at java.lang.reflect.Method.invokeNative(Native Method)
	at java.lang.reflect.Method.invoke(Method.java:515)
	at com.android.internal.os.ZygoteInit$MethodAndArgsCaller.run(ZygoteInit.java:829)
	at com.android.internal.os.ZygoteInit.main(ZygoteInit.java:645)
	at dalvik.system.NativeStart.main(Native Method)

```

Fragment destory时会将mChildFragmentManager.mHost重置为null

```java
void performDestroy() {
    if (mChildFragmentManager != null) {
        mChildFragmentManager.dispatchDestroy();
    }
	//...
}

public void dispatchDestroy() {
    moveToState(Fragment.INITIALIZING, false);
    mHost = null;
}
```

导致Fragment再次attach时 mChildFragmentManager.mHost = null

```java
public void dispatchActivityCreated() {
    mStateSaved = false;
    moveToState(Fragment.ACTIVITY_CREATED, false);
}

 void moveToState(int newState, int transit, int transitStyle, boolean always) {
    if (mHost == null && newState != Fragment.INITIALIZING) {
        throw new IllegalStateException("No activity");
    }

   	//...
}
```

Fragment attach时mChildFragmentManager != null

```java
final public FragmentManager getChildFragmentManager() {
    if (mChildFragmentManager == null) {
        instantiateChildFragmentManager();
			//...
    }
    return mChildFragmentManager;
}
    
void instantiateChildFragmentManager() {
    mChildFragmentManager = new FragmentManagerImpl();
    mChildFragmentManager.attachController(mHost, new FragmentContainer() {
        //...
    }, this);
}
    
```

解决方法就是在Fragment desotry时，将其FragmentManager也设置为null

参考资料：

* https://issuetracker.google.com/issues/36963722
* https://stackoverflow.com/questions/27980543/viewpager-on-dialogfragment-java-lang-illegalstateexception-no-activity


## Fragment detach后使用mHost报错

只能在attached Activity之前调用，所以，在实例化对象后立刻调用

```java
public void setArguments(Bundle args) {
	if (mIndex > 0) {
		throw new IllegalStateException("Fragment already active");
	}
	
	mArguments = args;
}
```

Fragment detache了后调用getResources()会报错

```java
final public Resources getResources() {
    if (mHost == null) {
        throw new IllegalStateException("Fragment " + this + " not attached to Activity");
    }
    return mHost.getContext().getResources();
}
```

## Fragment 重影问题

**问题原因**

Activity因为内存不足悲销毁重建时，其中Fragment也会被销毁重建。如果此时Activity onCreate中addFragment多次，就会造成重影问题

**模拟系统销毁Activity的方法**

手机的 "设置" - "开发者选项" - 打开"不保留活动"

## BackStackRecored 不能commit多次

```java
    int commitInternal(boolean allowStateLoss) {
        if (mCommitted) {
            throw new IllegalStateException("commit already called");
        }
        if (FragmentManagerImpl.DEBUG) {
            Log.v(TAG, "Commit: " + this);
            LogWriter logw = new LogWriter(Log.VERBOSE, TAG);
            PrintWriter pw = new FastPrintWriter(logw, false, 1024);
            dump("  ", null, pw, null);
            pw.flush();
        }
        mCommitted = true;
        if (mAddToBackStack) {
            mIndex = mManager.allocBackStackIndex(this);
        } else {
            mIndex = -1;
        }
        mManager.enqueueAction(this, allowStateLoss);
        return mIndex;
    }
```

## Fragment重复使用错误

1. Fragment不能同时加到两个不同的containerView中
2. Fragment不能同时add两个不同的tag

```java
private void doAddOp(int containerViewId, Fragment fragment, String tag, int opcmd) {
    fragment.mFragmentManager = mManager;

    if (tag != null) {
        if (fragment.mTag != null && !tag.equals(fragment.mTag)) {
            throw new IllegalStateException("Can't change tag of fragment "
                    + fragment + ": was " + fragment.mTag
                    + " now " + tag);
        }
        fragment.mTag = tag;
    }

    if (containerViewId != 0) {
        if (fragment.mFragmentId != 0 && fragment.mFragmentId != containerViewId) {
            throw new IllegalStateException("Can't change container ID of fragment "
                    + fragment + ": was " + fragment.mFragmentId
                    + " now " + containerViewId);
        }
        fragment.mContainerId = fragment.mFragmentId = containerViewId;
    }

    Op op = new Op();
    op.cmd = opcmd;
    op.fragment = fragment;
    addOp(op);
}
```

## 源码阅读

**主要成员**

* Activity

		final Handler mHandler = new Handler();
		//即FragmentManager
   		final FragmentController mFragments = FragmentController.createController(new HostCallbacks());
		
* Fragment
 		
 		里面有个ChildFragmentManager
	
* FragmentManager
		
		具体实现类是FragmentManagerImpl，有个moveToState()方法，用于切换状态，回调Fragment中的相关声明周期

	
* BackStackRecord

		就是FragmentTransaction，里面包含一个用于保存add,replace,commit等操作的双向链表，是一个runable。
		commit是通过mFragmentManager中的mHandler来执行这个BackStackRecord runnable.
		
	
**参考资料**  

* moveToState函数，Fragment生命周期函数调用解释（http://www.jianshu.com/p/c8391673babe）
* 比较全面的源码解析（http://www.jianshu.com/p/bd4a8be309c8）
