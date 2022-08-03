---
title: Flutter 代码生成
date: 2022-06-08 10:03:24
tags: flutter
categories: flutter
---

# Flutter 代码生成

## 通过Android Studio插件生成
[Dart Data Class](https://plugins.jetbrains.com/plugin/12429-dart-data-class)

生成代码
`command + n`


## 通过json_serializable，利用Dart Build System生成
[json_serializable](https://pub.dev/packages/json_serializable)
[json_annotation](https://pub.dev/packages/json_annotation)

生成代码
```bash
$ flutter pub run build_runner build
// 或者
$ flutter packages pub run build_runner build --delete-conflicting-outputs  
```

## Dart Data class和json_serializable对比
`Dart Data Clss`生成代码不依赖第三方，不对代码造成任何影响。但是生成的代码块都在一个文件中，都是些结构类似的模版代码，而且如果字段和json key不一致的话，需要手动去修改代码。解析Json的时候也不能直观的从Class类文件结构看出Json格式。

`json_serializable`缺点就是依赖了三方，并且需要运行命令行生成代码文件。优点利用注解，执行命令生成代码，貌似也是Flutter项目的通用做法，算是共识了，部门合作的时候只需要添加lib依赖就可以了，不用安装插件。而且可以通过注解方便的修改key和字段的对应关系，也能更直观的了解Json的数据格式。它将生成的代码放在`*.g.dart`文件中，帮我们屏蔽掉很多模版代码。

其实这两种的区别的本质是：一个通过命令行加配置文件生成代码，一个是通过界面+用户输入信息生成代码。

## Android Studio 插件的实现
[dart data plugin源码](https://github.com/andrasferenczi/dart-data-plugin)
1. `plugin.xml`中`action`声明了插件菜单
2. `MapAction`其中的`processAction`就是用来生成`toMap`,`fromMap`代码的
3. 执行`buildPlugin`任务会生成对应的插件jar,直接本地安装插件就可以使用

## json_serializable 的实现
[flutter code generation](https://www.raywenderlich.com/22180993-flutter-code-generation-getting-started#toc-anchor-016)

1. 创建Annotations
2. 创建Generators
3. build.yaml中配置builder对应的Generator
4. 生成代码`flutter pub run build_runner build`