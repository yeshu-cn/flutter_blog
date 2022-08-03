---
title: 使用sharepreference还是database?
date: 2019-05-31 11:15:57
tags:
categories: 架构设计
---



Shared Preferences: 保存配置等数据意义独立的数据，数据量可预期的小数据。

DB: 关系型数据库，数据间存在关联关系的，使用数据库能很方便的获取处理数据。数据量不可预期，存储的内容会不停的增加




> Shared Preferences : Settings, Name value store, uncategorized data, and ad-hoc data storage. A good way to have global data is to save them to shared pref. If it's a complex object, gson it.

> DB: multiple instances of similar data, Categorized data
> 
> from:https://www.reddit.com/r/androiddev/comments/281x95/when_should_we_choose_sqlite_db_over/ci6lvh0/
> 