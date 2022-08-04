---
title: Git笔记
date: 2016-09-08 16:28:38
tags:
---

#### 常用命令

远程仓库的默认名称是`origin`  

* 查看分支：`git branch`  
* 创建分支：`git branch <name>`
* 切换分支：`git checkout <name>`
* 创建+切换分支：`git checkout -b <name>`
* 合并某分支到当前分支：`git merge <name>`
* 删除分支：`git branch -d <name>`
* 查看远程仓库：`git remote －v`
* 推送本地代码到远程仓库 `git push origin <branch-name>`
* 存放临时代码：`git stash, git stash pop`

#### git pull

git pull命令的作用是，取回远程主机某个分支的更新，再与本地的指定分支合并。

```bash	
#如果远程分支是与当前分支合并，则冒号后面的部分可以省略。
$ git pull <远程主机名> <远程分支名>:<本地分支名>
	
#拉取远程仓库origin master分支与当前分支合并
$ git pull origin master
```

#### 工作中git笔记

```bash
git pull --rebase
git push origin HEAD:refs/for/develop
```

#### git工作环境配置

#####  配置user.email和user.name

```bash
#Github配置成全局的
git config --global user.name "yeshu"
git config --global user.email "guan.yeshu@gamil.com"

#公司git配置成局部的
#项目目录下执行
git config user.name "xxx"
git config user.email "xxx@xx.com"

#查看当前项目使用的git信息
git config --list
```

#####  配置ssh kye访问规则

* github和公司分别生成两个不同的ssh key

```bash
$ ssh-keygen -t rsa -C "xxx@gmail.com"
```
*  `~/.ssh`目录下创建config文件

```bash
##公司的gerrit服务器
Host gerrit
	HostName www.xxx.com
	PreferredAuthentications publickey
	User xxxx
	IdentityFile ~/.ssh/id_rsa

##github
Host github
	HostName github.com
	PreferredAuthentications publickey
	User guan.yeshu@gmail.com
	IdentityFile ~/.ssh/id_rsa_github
```

#### 将本地数据推送到github中

```bash
git init
git add .
git commit -m "add data"
git remote add origin https://github.com/yeshu-cn/hexoBlog.git
git pull origin master #更新github中最新数据
git push -u origin master

```

#### git commit --amend失败

已经push后，又使用`--amend`提交导致push失败。

```bash
# 查看本地历史记录
git reflog
# 回滚（保留了修改,reset --hard会不保留修改）
git reset ebb1864
# 再重新commit提交

```


