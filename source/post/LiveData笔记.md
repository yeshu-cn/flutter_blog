---
title: LiveData笔记
date: 2018-06-01 15:39:38
tags:
---


# LiveData

原来LiveData只要调用setValue就会回调onChange(),不关心数据值是否真的发生变化了。不过会关心observer的state

from:https://developer.android.com/topic/libraries/architecture/livedata

* LiveData是一个可被监听其中数据变化的Observer
* LiveData is lifecycle-aware,知道组件的生命周期变化
* LiveData只会在`active lifecycle state`状态才会触发数据变化的回调
* `activite lifecycle state`是指在lifecycle的`STARTED`和`RESUMED`状态之间
* LiveData会在`LifeCycle`状态变化为`DESTORYED`时，removed掉observer


## LiveData优点

* 观察者模式确保数据和UI显示一致
* Lifecycle机制自动注销observer,确保不会内存泄漏
* UI不可见的时候不会更新界面，减少由此触发的程序崩溃
* 不用在自己处理生命周期相关的业务了(no more manual lifecycle handling)
* UI总会在回到前台时获取到最新的数据（always up to date data）
* 配置变化导致UI重建时，UI能收到最新的可用数据，恢复界面
* Fragment,Activity,Servie间共享数据

## LiveData使用

* 创建LiveData对象
* 创建Observer对象，实现onChanged()方法
* 通过LiveData.observer()方法注册监听

### 创建LiveData对象

```java
public class NameViewModel extends ViewModel {

// Create a LiveData with a String
private MutableLiveData<String> mCurrentName;

    public MutableLiveData<String> getCurrentName() {
        if (mCurrentName == null) {
            mCurrentName = new MutableLiveData<String>();
        }
        return mCurrentName;
    }

// Rest of the ViewModel...
}
```

LiveData放在ViewModel中，不放在Activity,Frgment中的原因

* 避免和activities,fragments产生依赖，ui只需要负责展示数据，而不必关心数据状态
* 和activities,fragments脱钩，让LiveData可以在配置发生变化时依然可用

### Observe LiveData objects

回调时机

* LiveData中的数据发生变化
* Observer的状态由inactive变化成了activie state时,仅仅只在第一次的时候。后面状态变化不会再触发了
* 如果LiveData中没有设置数据，不会触发回调


```java
public class NameActivity extends AppCompatActivity {

    private NameViewModel mModel;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);

        // Other code to setup the activity...

        // Get the ViewModel.
        mModel = ViewModelProviders.of(this).get(NameViewModel.class);


        // Create the observer which updates the UI.
        final Observer<String> nameObserver = new Observer<String>() {
            @Override
            public void onChanged(@Nullable final String newName) {
                // Update the UI, in this case, a TextView.
                mNameTextView.setText(newName);
            }
        };

        // Observe the LiveData, passing in this activity as the LifecycleOwner and the observer.
        mModel.getCurrentName().observe(this, nameObserver);
    }
}
```

### Update LiveData objects

* MutableLiveData使用setValue(T),postValue(T)方法更新数据

```java
mButton.setOnClickListener(new OnClickListener() {
    @Override
    public void onClick(View v) {
        String anotherName = "John Doe";
        mModel.getCurrentName().setValue(anotherName);
    }
});

```

### Use LiveData with Room

## Extend LiveData

```java
public class StockLiveData extends LiveData<BigDecimal> {
    private StockManager mStockManager;

    private SimplePriceListener mListener = new SimplePriceListener() {
        @Override
        public void onPriceChanged(BigDecimal price) {
            setValue(price);
        }
    };

    public StockLiveData(String symbol) {
        mStockManager = new StockManager(symbol);
    }

    @Override
    protected void onActive() {
        mStockManager.requestPriceUpdates(mListener);
    }

    @Override
    protected void onInactive() {
        mStockManager.removeUpdates(mListener);
    }
}

```

LiveData监听回调关系

* If the `Lifecycle` object is not in an activity state. then the observer isn't called even if the value changes.
* After the `Lifecycle` object is destroyed, the observer is auotmatically removed;

在多个Activity,Fragment,Service之间共享LiveData数据

```java
public class StockLiveData extends LiveData<BigDecimal> {
    private static StockLiveData sInstance;
    private StockManager mStockManager;

    private SimplePriceListener mListener = new SimplePriceListener() {
        @Override
        public void onPriceChanged(BigDecimal price) {
            setValue(price);
        }
    };

    @MainThread
    public static StockLiveData get(String symbol) {
        if (sInstance == null) {
            sInstance = new StockLiveData(symbol);
        }
        return sInstance;
    }

    private StockLiveData(String symbol) {
        mStockManager = new StockManager(symbol);
    }

    @Override
    protected void onActive() {
        mStockManager.requestPriceUpdates(mListener);
    }

    @Override
    protected void onInactive() {
        mStockManager.removeUpdates(mListener);
    }
}
```

use is as follow

```java
public class MyFragment extends Fragment {
    @Override
    public void onActivityCreated(Bundle savedInstanceState) {
        StockLiveData.get(getActivity()).observe(this, price -> {
            // Update the UI.
        });
    }
}

```

## Transform LiveData

将LiveData中的数据转换为observer中想要的数据类型

```java
LiveData<User> userLiveData = ...;
LiveData<String> userName = Transformations.map(userLiveData, user -> {
    user.name + " " + user.lastName
});

```

```java
private LiveData<User> getUser(String id) {
  ...;
}

LiveData<String> userId = ...;
LiveData<User> user = Transformations.switchMap(userId, id -> getUser(id) );
```

## Merge multiple LiveData sources

使用`MediatorLiveData`聚合多个LiveData






