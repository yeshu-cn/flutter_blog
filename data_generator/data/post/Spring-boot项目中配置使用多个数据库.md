---
title: Spring boot项目中配置使用多个数据库
permalink: sprint-boot-multiple-datasource
id: 10
updated: '2015-03-31 02:14:20'
date: 2015-03-30 09:47:21
tags:
---

#####Spring boot项目中配置使用多个数据库  

__使用JdbcTemplate操作数据库__  
1. Spring boot项目中配置多个DataSource, 通过hibernate连接mysql数据库得到多个DataSource
2. 根据DataSource获取相应JdbcTemplate
3. 使用JdbcTemplate来操作数据库
参考网站：
http://xantorohara.blogspot.jp/2013/11/spring-boot-jdbc-with-multiple.html

__Spring访问数据库的方法__
1. 使用HibernateTemplate
2. 使用HibernateDaoSupport
3. 使用JdbcTemplate
4. 使用JpaRepository
5. 使用Hibernate Session 执行hql,sql


问题：  
不知道Spring boot配置多个DataSource后如何得到每个数据库对应的SessionFactory 
 



