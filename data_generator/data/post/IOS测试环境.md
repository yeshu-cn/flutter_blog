---
title: IOS测试环境
permalink: ji-guang-tui-song
id: 7
updated: '2014-12-15 07:10:09'
date: 2014-12-15 02:39:10
tags:
---

    
#####_IOS测试环境名词概念_
######1. Certificates
	需要mac下导出csr证书文件和一个App ID来生成Certificate，表示一台特定的mac中调试特定app。
    分为Developer(开发证书)和Production(生产证书)两种。
######2. Identifiers	
	需要创建APP ID,表示一个特定的APP(app的唯一标识) 
######3. Devices
	需要设备的UDID,表示一台特定的设备（iphone,ipad）
######4. Provisioning Profiles
	综合上面三项信息的一个描述文件 
> 一台设备上运行应用程序的过程如下(以Developer Provisioning Profile为例):
 
> 1 检查app 的 bunld ID 是否 matches Provisioning Profile 的 App ID  
> 2 检查 app 的 entitements 是否 matches Provisioning Profile 的 entitements  
> 3 用Certificate来验证签名签名  
> 4 检查此设备的UDID是否存在于 Provisioning Profiles中 （仅在 非发布证书中）

#####_其他_
######APNS
	Apple Push Notification Server（苹果消息推送服务器）  
    消息推送数据流程：Client App Server---->APNS---->Iphone---->Client App
######MAC中请求生成CSR文件    
    1. 打开"钥匙串访问工具"
    2. Select Keychain Access > Certificate Assistant > Request a Certificate from a Certificate Authority.  
    3. 输入用户电子邮箱地址，常用名称（John Doe Dev key）。CA Email地址留空。
    4. 存储到磁盘


######参考资料
http://www.cnblogs.com/zhaoyang/p/3582436.html
    
    
     