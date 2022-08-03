---
title: Sqlite3命令
date: 2017-11-09 18:41:51
tags:
---

# Sqlite3 命令

1. miui rom中不包含sqlite3命令
2. Mac中有sqlite3命令，可以导出数据文件到电脑上执行

**常用命令**

打开数据库

`sqlite3 data.db` (data.db是数据库文件名)

退出

`.exit`

查询表数据

`select * from table;`

查看数据库创建的命令，了解数据库结构

`.schema`

帮助命令，查看所有命令

`.help`

查看数据库中有哪些表

`.tables`

查看数据库信息

`.database`



