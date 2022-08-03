---
title: Android permission
date: 2017-11-23 18:03:47
tags:
---

# Android 6.0权限变化和申请

https://developer.android.com/training/permissions/requesting.html

AdnroidManifest.xml中还是要依旧申明权限

系统权限分为两类：正常权限和危险权限

* 正常权限不会给用户带来隐私问题，安装的时候会默认赋予
* 危险权限会授予访问用户隐私数据，安装的时候会默认禁用掉

## 检查权限

```java
int permissionCheck = ContextCompat.checkSelfPermission(thisActivity,
        Manifest.permission.WRITE_CALENDAR);
```

返回值  
`PackageManager.PERMISSION_GRANTED`, `PackageManager.PERMISSION_DENIED`

## 请求权限

```java
ActivityCompat.requestPermissions(thisActivity,
                new String[]{Manifest.permission.READ_CONTACTS},
                MY_PERMISSIONS_REQUEST_READ_CONTACTS);



@Override
public void onRequestPermissionsResult(int requestCode,
        String permissions[], int[] grantResults) {
    switch (requestCode) {
        case MY_PERMISSIONS_REQUEST_READ_CONTACTS: {
            // If request is cancelled, the result arrays are empty.
            if (grantResults.length > 0
                && grantResults[0] == PackageManager.PERMISSION_GRANTED) {

                // permission was granted, yay! Do the
                // contacts-related task you need to do.

            } else {

                // permission denied, boo! Disable the
                // functionality that depends on this permission.
            }
            return;
        }

        // other 'case' lines to check for other
        // permissions this app might request
    }
}

```

`requestPermission`会弹出一个系统的对话框，用户可以选择`拒绝`或者`允许`权限申请

![](https://developer.android.com/images/training/permissions/request_permission_dialog.png)

* 用户点击允许时，权限申请成功
* 用户点击拒绝时，权限申请失败
* 用户点击拒绝，并勾选不在提示时，下次申请权限将直接失败
* 多次选择拒绝后，再次申请权限才会出现不在提示的`checkbox`


Fragment中使用`FragmentCompat.requestPermissions()`才会触发`onRequestPermmissionsResult()`回调


## 判断用户有没有点击过拒绝过授予权限


```java
ActivityCompat.shouldShowRequestPermissionRationale(thisActivity,
            Manifest.permission.READ_CONTACTS)
```

* 用户没点击过拒绝，将返回false
* 用户点击过拒绝，没有勾选不在提示，返回true
* 用户勾选了不在提示，并拒绝，返回false

## 权限和权限组

当您授予权限组中的一个权限时，系统将自动授予app整个权限组的权限，例如：

> 例如，假设您在应用清单中列出了 READ_CONTACTS 和 WRITE_CONTACTS。如果您请求 READ_CONTACTS 且用户授予了此权限，那么，当您请求 WRITE_CONTACTS 时，系统将立即授予您该权限，不会与用户交互。


权限组：https://developer.android.com/guide/topics/security/permissions.html#perm-groups
