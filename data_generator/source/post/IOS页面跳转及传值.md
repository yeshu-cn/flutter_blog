---
title: IOS页面跳转及传值
permalink: iosxue-xi
id: 12
updated: '2015-06-19 09:56:24'
date: 2015-04-10 02:31:54
tags:
---


####IOS页面跳转及传值
Ios中可以通过Storyboard图形界面配置页面跳转，也可以通过写代码进行跳转
	
    //页面跳转时，通过重写prepareForSegue函数来设置数据传值
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
    
    }
    //通过prepareForSegue方法来主动调用跳转
    self.prepareForSegue(<#segue: UIStoryboardSegue#>, sender: <#AnyObject?#>)


####概念
Storyboard：用户管理sence和segue的一个容器。
Sence:相当于一个页面(ViewController)。
       在iphone中，segue有：push，modal，和custom三种不同的类型，这些类型的区别在与新页面出现的方式。
而在ipad中，有push，modal，popover，replace和custom五种不同的类型。
segue:表示两个场景(ViewController)之间的跳转关系，和Android的Intent类似。