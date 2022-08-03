---
title: DialogFragment调用dismiss()过快
date: 2018-08-28 11:22:27
tags:
---

DialogFragment的创建显示过程和dismiss()调用是一个异步操作

所以dimiss()必须在Dialog完全显示后才能调用，否则会出现异常，如：

```
MyDialog dialog = MyDialog.newInstance();
dialog.show(getSupportFragmentManager(), "");
dialog.dismissAllowingStateLoss();

log:
----->dismissAllowingStateLoss  
----->onActivityCreated
```

onActivityCreated在dismissAllowingStateLoss后执行会造成两种可能

* Dialog创建成功，一直显示，不会隐藏
* onActivityCreated中mDialog为null,导致程序崩溃 




