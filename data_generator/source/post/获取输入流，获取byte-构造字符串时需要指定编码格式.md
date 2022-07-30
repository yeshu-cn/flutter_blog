---
title: '获取输入流，获取byte[],构造字符串时需要指定编码格式'
permalink: zi-fu-chuan-bian-ma-wen-ti
id: 11
updated: '2015-04-03 02:25:36'
date: 2015-04-03 02:14:56
tags:
---



    
	这里获取byte时需要指定编码格式
	byte[] bytes = "志同道合".getBytes("utf-8")  
    
	根据byte构造字符串时需要指定编码格式
	String str = new String(bytes, "utf-8");
    
	打开网页获取网页内容时，需要指定编码格式。不然容易造成中文乱码    
	BufferedReader in = new BufferedReader(new InputStreadReader(connection.getInputStream(), "utf-8"));    
  
如果不指定编码格式，程序会采用系统默认的编码格式。这样如果在linux和windows之间交互就容易造成编码错误问题。
  