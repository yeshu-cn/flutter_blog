* 页面跳转渐变动画


todo: 
* 处理参数错误，没有数据的情况(404)
* markdown显示不了图片
* markdown显示不了目录
* 界面显示自适应
* 用flutter写个界面，来创建日志和生成json api?
* 返回键用不了呀


## 中文标点显示异常

渲染的中文标点正常
$ flutter run -d chrome --web-renderer canvaskit

渲染的中文标点会居中，不正常
$ flutter run -d chrome --web-renderer html

参考：https://docs.flutter.dev/development/platform-integration/web/renderers

