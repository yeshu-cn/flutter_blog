---
title: SVN使用笔记
permalink: svnshi-yong-bi-ji
id: 19
updated: '2015-06-04 07:27:30'
date: 2015-06-04 07:26:04
tags:
---

#SVN使用笔记
简要记录下自己使用过的一些命令

__trunk__:开发主目录
__branch__：发布版本时，用于修复bug。修复完毕后需要将代码合并到trunk中去
__tags__:经过测试无bug，发布版本时的代码

##Mac上创建Svn服务
创建svn仓库

		svnadmin create ~/svn/myproject

创建三个默认的空目录

	cd ~/svn/myproject
	mkdir trunk
	mkdir branch
	mkdir tags

配置svn用户信息

	cd conf/
	编辑目录下svnserve.conf passwd authz文件

启动服务：

	svnserve -d -r ~/svn/myproject


##Svn命令管理项目

导入项目

	svn import -m "new project" cscrobot svn://192.168.2.2/myproject/trunk/cscrobot
	注意：这里cscrobot是一个子项目个根目录，svn只会导入cscrobot目录中的文件，所以需要在后面路径中加上/cscrobot，svn才会帮你创建一个cscrobot目录

创建tags

	svn copy svn://192.168.2.2/myproject/trunk svn://192.168.2.2/myproject/tags/release-1.3 -m "1.3 released"

##资料
解释trunk,branch,tags三个目录的使用场景：  
<http://www.chinasb.org/archives/2011/04/1709.shtml>
创建和删除 branch, tags:  
<http://blog.csdn.net/yangzhongxuan/article/details/7519948>