---
title: ActionBar使用总结
permalink: actionbarshi-yong-zong-jie
id: 17
updated: '2015-06-03 03:23:41'
date: 2015-06-03 03:22:57
tags:
---

#ActionBar使用 
资料：<http://developer.android.com/training/basics/actionbar/index.html>

##基本使用
__Android 3.0(API Level 11)后开始使用ActionBar__

__Android 3.0以上版本使用ActionBar__

* manifest文件中最小sdk版本设置为11：<uses-sdk android:minSdkVersion="11">
* 使用Theme.Holo（或者它子类）主题

__兼容Android 2.1及以后版本使用Android__
* 使用v7 appcompat Library
* Activity继承ActionBarActivity
* 主题使用AppCompate.Light(或它的子类)：<activity android:theme="@style/Theme.AppCompat.Light">

__ActionBar上添加Buttons__
只支持Android3.0 及以上版本

```xml
res/menu/main_activity_actions.xml
<menu xmlns:android="http://schemas.android.com/apk/res/android" >
    <!-- Search, should appear as action button -->
    <item android:id="@+id/action_search"
          android:icon="@drawable/ic_action_search"
          android:title="@string/action_search"
          android:showAsAction="ifRoom" />
    <!-- Settings, should always be in the overflow -->
    <item android:id="@+id/action_settings"
          android:title="@string/action_settings"
          android:showAsAction="never" />
</menu>
```
使用v7 appcompat library 兼容 Android 2.1 及以上版本

```xml
res/menu/main_activity_actions.xml
<menu xmlns:android="http://schemas.android.com/apk/res/android"
      xmlns:yourapp="http://schemas.android.com/apk/res-auto" >
    <!-- Search, should appear as action button -->
    <item android:id="@+id/action_search"
          android:icon="@drawable/ic_action_search"
          android:title="@string/action_search"
          <!--使用兼容包不能使用android:xx -->
          yourapp:showAsAction="ifRoom"  />
    ...
</menu>
```
代码片段

```java
@Override
public boolean onCreateOptionsMenu(Menu menu) {
    // 为ActionBar扩展菜单项
    MenuInflater inflater = getMenuInflater();
    inflater.inflate(R.menu.main_activity_actions, menu);
    return super.onCreateOptionsMenu(menu);
}

@Override
public boolean onCreateOptionsMenu(Menu menu) {
    // Inflate the menu items for use in the action bar
    MenuInflater inflater = getMenuInflater();
    inflater.inflate(R.menu.main_activity_actions, menu);
    return super.onCreateOptionsMenu(menu);
}

@Override
public boolean onOptionsItemSelected(MenuItem item) {
    // Handle presses on the action bar items
    switch (item.getItemId()) {
        case R.id.action_search:
            openSearch();
            return true;
        case R.id.action_settings:
            openSettings();
            return true;
        default:
            return super.onOptionsItemSelected(item);
    }
}

//为下级Activity启动向上返回父Activity功能
<application ... >
    ...
    <!-- The main/home activity (it has no parent activity) -->
    <activity
        android:name="com.example.myfirstapp.MainActivity" ...>
        ...
    </activity>
    <!-- A child of the main activity -->
    <activity
        android:name="com.example.myfirstapp.DisplayMessageActivity"
        android:label="@string/title_activity_display_message"
        android:parentActivityName="com.example.myfirstapp.MainActivity" >
        <!-- Parent activity meta-data to support 4.0 and lower -->
        <meta-data
            android:name="android.support.PARENT_ACTIVITY"
            android:value="com.example.myfirstapp.MainActivity" />
    </activity>
</application>

@Override
public void onCreate(Bundle savedInstanceState) {
    super.onCreate(savedInstanceState);
    setContentView(R.layout.activity_displaymessage);

    getSupportActionBar().setDisplayHomeAsUpEnabled(true);
    // If your minSdkVersion is 11 or higher, instead use:
    // getActionBar().setDisplayHomeAsUpEnabled(true);
}
```

__ActionBar上添加Navigation Tabs__

##ActionBar样式设置
__基本样式__

* Theme.Holo
* Theme.Holo.Light
* Theme.AppCompat
* Theme.AppCompat.Light
* Theme.AppCompat.Light.DarkActionBar

__自定义样式__

仅支持3.0及其以后

```xml
res/values/themes.xml
<?xml version="1.0" encoding="utf-8"?>
<resources>
    <!-- 应用于程序或者活动的主题 -->
    <style name="CustomActionBarTheme"
           parent="@style/Theme.Holo">
        <item name="android:actionBarStyle">@style/MyActionBar</item>
        <item name="android:actionBarTabTextStyle">@style/MyActionBarTabText</item>
        <item name="android:actionMenuTextColor">@color/actionbar_text</item>
    </style>

    <!-- ActionBar 样式 -->
    <style name="MyActionBar"
           parent="@style/Widget.Holo.ActionBar">
        <item name="android:titleTextStyle">@style/MyActionBarTitleText</item>
    </style>

    <!-- ActionBar 标题文本 -->
    <style name="MyActionBarTitleText"
           parent="@style/TextAppearance.Holo.Widget.ActionBar.Title">
        <item name="android:textColor">@color/actionbar_text</item>
    </style>

    <!-- ActionBar Tab标签 文本样式 -->
    <style name="MyActionBarTabText"
           parent="@style/Widget.Holo.ActionBar.TabText">
        <item name="android:textColor">@color/actionbar_text</item>
    </style>
</resources>
```
使用Support库兼容2.1及其以后版本

```xml
res/values/themes.xml
<?xml version="1.0" encoding="utf-8"?>
<resources>
    <!-- 应用于程序或者活动的主题 -->
    <style name="CustomActionBarTheme"
           parent="@style/Theme.AppCompat">
        <item name="android:actionBarStyle">@style/MyActionBar</item>
        <item name="android:actionBarTabTextStyle">@style/MyActionBarTabText</item>
        <item name="android:actionMenuTextColor">@color/actionbar_text</item>

        <!-- 支持库兼容 -->
        <item name="actionBarStyle">@style/MyActionBar</item>
        <item name="actionBarTabTextStyle">@style/MyActionBarTabText</item>
        <item name="actionMenuTextColor">@color/actionbar_text</item>
    </style>

    <!-- ActionBar 样式 -->
    <style name="MyActionBar"
           parent="@style/Widget.AppCompat.ActionBar">
        <item name="android:titleTextStyle">@style/MyActionBarTitleText</item>

        <!-- 支持库兼容 -->
        <item name="titleTextStyle">@style/MyActionBarTitleText</item>
    </style>

    <!-- ActionBar 标题文本 -->
    <style name="MyActionBarTitleText"
           parent="@style/TextAppearance.AppCompat.Widget.ActionBar.Title">
        <item name="android:textColor">@color/actionbar_text</item>
        <!-- 文本颜色属性textColor是可以配合支持库向后兼容的 -->
    </style>

    <!-- ActionBar Tab标签文本样式 -->
    <style name="MyActionBarTabText"
           parent="@style/Widget.AppCompat.ActionBar.TabText">
        <item name="android:textColor">@color/actionbar_text</item>
        <!-- 文本颜色属性textColor是可以配合支持库向后兼容的 -->
    </style>
</resources>
```

__设置Navigation Tags样式__

仅支持Android 3.0及其以上版本

```xml
res/values/themes.xml
<?xml version="1.0" encoding="utf-8"?>
<resources>
    <!-- 应用于程序或活动的主题 -->
    <style name="CustomActionBarTheme"
           parent="@style/Theme.Holo">
        <item name="android:actionBarTabStyle">@style/MyActionBarTabs</item>
    </style>

    <!-- ActionBar tabs 标签样式 -->
    <style name="MyActionBarTabs"
           parent="@style/Widget.Holo.ActionBar.TabView">
        <!-- 标签指示器 -->
        <item name="android:background">@drawable/actionbar_tab_indicator</item>
    </style>
</resources>

```

使用Support库，兼容Android 2.1及其以上版本

```xml
res/values/themes.xml

<?xml version="1.0" encoding="utf-8"?>
<resources>
    <!-- 应用于程序或活动的主题 -->
    <style name="CustomActionBarTheme"
           parent="@style/Theme.AppCompat">
        <item name="android:actionBarTabStyle">@style/MyActionBarTabs</item>

        <!-- 支持库兼容 -->
        <item name="actionBarTabStyle">@style/MyActionBarTabs</item>
    </style>

    <!-- ActionBar tabs 样式 -->
    <style name="MyActionBarTabs"
           parent="@style/Widget.AppCompat.ActionBar.TabView">
        <!-- 标签指示器 -->
        <item name="android:background">@drawable/actionbar_tab_indicator</item>

        <!-- 支持库兼容 -->
        <item name="background">@drawable/actionbar_tab_indicator</item>
    </style>
</resources>
```

##Overlaying the Action Bar

仅支持Android 3.0及其以上
```xml
<resources>
    <!-- the theme applied to the application or activity -->
    <style name="CustomActionBarTheme"
           parent="@android:style/Theme.Holo">
        <item name="android:windowActionBarOverlay">true</item>
    </style>
</resources>
```

使用Support库，兼容Android 2.1及其上版本

```xml
<resources>
    <!-- 为程序或者活动应用的主题样式 -->
    <style name="CustomActionBarTheme"
           parent="@android:style/Theme.AppCompat">
        <item name="android:windowActionBarOverlay">true</item>

        <!-- 兼容支持库 -->
        <item name="windowActionBarOverlay">true</item>
    </style>
</resources>
```
注意：使用Support库时，样式熟悉不能是`android:paddingTop="?android:attr/actionBarSize"`，而是`android:paddingTop="?attr/actionBarSize"`。

__使用 actionBarSize 属性来指定顶部margin或padding的高度__

```xml
<RelativeLayout xmlns:android="http://schemas.android.com/apk/res/android"
    android:layout_width="match_parent"
    android:layout_height="match_parent"
    android:paddingTop="?android:attr/actionBarSize">
    ...
</RelativeLayout>
```