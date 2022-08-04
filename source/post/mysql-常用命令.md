---
title: mysql 常用命令
date: 2017-11-16 17:38:05
tags:
---

# Mysql常用命令


## 配置环境变量，使用mysql命令
Mac下安装mysql需要配置环境变量，否则无法使用mysql命令

1. `vim ~/.bash_profile` 编辑环境变量，添加mysql命令路径

```
export PATH=${PATH}:/usr/local/mysql/bin
```

2. `source ～/.bash_profile` 使配置文件立刻生效


## 常用命令

* 连接数据库   

		格式： mysql -h主机地址 -u用户名 －p用户密码 (中间不需要空格)
		mysql -u username -p　　
		mysql -h110.110.110.110 -uroot -pabcd123
* 退出数据连接

		exit	
	
* 查看数据库
  		
  		show databases;
* 创建数据库  
	
		create database dbname;			
* 删除数据库  
	
		drop database dbname;
* 打开数据库  
	
		use dbname;
* 查看当前使用的数据库  
	
		select database():
* 查看数据库中表信息
	
		show tables();






