---
title: 'Jboss,Tomcat，mysql问题笔记'
permalink: ri-ji
id: 8
updated: '2015-01-05 15:29:51'
date: 2015-01-05 13:57:35
tags:
---


#####Jboss使用
**Jboss和tomcat区别，为什么使用jboss**  
     
     基于Tomcat内核，青胜于蓝。
     JBoss在Tomcat的基础上，对其进行本地化，将Tomcat 以内嵌的方式集成到 JBoss 中。
     并发的性能比tomcat高，混合的连接模式支持最大达到10000个并发客户端的同时访问。（所以移动客户端的服务器准备用它）
     
#####Tomcat使用
**如何配置一个tomcat服务器下多个网站**
	
    编辑server.xml文件，其中可以设置每个网站访问的Url和网站目录位置
    
#####MySql使用
**mysql用户权限体系**  
	
    权限控制包括数据库链接的权限和不同用户对数据库的增删改查等权限
    默认的安装的mysql用户名root，密码为空
    默认情况下MYSQL数据库的系统数据库mysql系统表user内用户权限只提供localhost本机登陆；需要更改权限才能实现远程连接MYSQL数据库。
    查看数据中所有用户信息：select host,user from user;
    
**windows上表名不区分大小写，linux上区分大小写（字段两个平台都区分大小写）**
	
    通过修改my.ini文件设置windows平台也区分表名的大小写。而且还可以编辑通过my.ini文件来修改数据库的编码格式

