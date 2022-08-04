---
title: DialogFragment使用笔记
permalink: dialogfragmentshi-yong-bi-ji
id: 79
updated: '2016-05-17 03:08:25'
date: 2016-05-17 03:07:41
tags:
---

1. DialogFragment默认边框有黑色阴影
	
2. 去掉黑色阴影

```java
    @Override
    public void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);

        setStyle(STYLE_NORMAL, R.style.Theme_Common_Dialog_Alert);
    }
```

```xml
<?xml version="1.0" encoding="utf-8"?>
<resources>
    <style name="Theme.Common.Dialog.Alert" parent="android:Theme.Panel">
    	<!-- 让Dialog背景为灰色，默认false是背景高亮 -->	
        <item name="android:backgroundDimEnabled">true</item>
    </style>
</resources> 
```

3. 设置Dialog固定宽高,在xml中设置是无效的

```java
    @Override
    public void onResume() {
        super.onResume();
        if (getShowsDialog()) {
            //Dialog显示时，设置Dialog的固定宽度。
            getDialog().getWindow().setLayout(getActivity().getResources().getDimensionPixelSize(R.dimen.dialog_min_width), LinearLayout.LayoutParams.WRAP_CONTENT);
        }
    }
```
	

4. 设置Dialog无标题，点击外部是否消失

```java
    @Override
    public View onCreateView(LayoutInflater inflater, ViewGroup container, Bundle savedInstanceState) {
        if (getShowsDialog()) {
            getDialog().requestWindowFeature(Window.FEATURE_NO_TITLE);
            getDialog().setCanceledOnTouchOutside(false);
        }
			
		//....
    }
```
