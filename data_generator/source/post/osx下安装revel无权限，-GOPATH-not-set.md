---
title: osx下安装revel无权限，$GOPATH not set
permalink: osxxia-an-zhuang-revelwu-quan-xian-gopath-not-set
id: 45
updated: '2015-09-20 14:52:24'
date: 2015-09-20 14:51:13
tags:
---

##osx下安装revel无权限，$GOPATH not set

1. 执行`go get github.com/revel/revel`错误，提示无权限
2. 根据提示执行`sudo go get github.com/revel/revel`错误，提示没有$GOPATH not set
3. 然而已经在`~/.bash_profile`中设置了$GOPATH

```
localhost:golang yeshu$ go get github.com/revel/revel
# cd .; git clone https://github.com/revel/revel /Users/yeshu/code/golang/src/github.com/revel/revel
Agreeing to the Xcode/iOS license requires admin privileges, please re-run as root via sudo.
package github.com/revel/revel: exit status 69

localhost:golang yeshu$ sudo go get github.com/revel/revel
Password:
package github.com/revel/revel: cannot download, $GOPATH not set. For more details see: go help gopath

localhost:golang yeshu$ echo $GOPATH
/Users/yeshu/code/golang
```

还是老外的回答最好

1. 第一个无权限错误原因：You don't have write access to your GOPATH.  Typically you would set GOPATH=~/gocode or something
2. 第二个提示$GOPATH没设置原因：new environment is created when you "sudo" -- the root user does not have the GOPATH set.  (Also, you probably don't want to solve it in this way anyway) 

##这里不是GOPATH目录没有写权限问题
`Agreeing to the Xcode/iOS license requires admin privileges, please re-run as root via sudo.
`

因为系统自动更新了xcode，所以需要打开xcode同意下新的条款。（mb，xcode更新管我什么事情）

解决方案：

* 命令行执行`sudo xcodebuild -license`同意条款
* 打开xcode同意一下

参考： 
 
* https://groups.google.com/forum/#!topic/revel-framework/pWF3Cbm9cCI
* http://stackoverflow.com/questions/26197347/agreeing-to-the-xcode-ios-license-requires-admin-privileges-please-re-run-as-r