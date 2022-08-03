---
title: Ghost 利用Code Injection实现代码高亮
permalink: ghost-li-yong-code-injectionshi-xian-dai-ma-gao-liang
id: 71
updated: '2016-04-18 11:23:55'
date: 2016-04-18 11:20:01
tags:
---


在Code Injdection中的Blog Header中直接粘贴如下代码：

```html
<link rel="stylesheet" href="//cdnjs.cloudflare.com/ajax/libs/highlight.js/8.9.1/styles/github.min.css">  
<script src="//cdnjs.cloudflare.com/ajax/libs/highlight.js/8.9.1/highlight.min.js"></script>  
<script>hljs.initHighlightingOnLoad();</script>  
<style>  
  pre {
    word-wrap: normal;
    -moz-hyphens: none;
    -ms-hyphens: none;
    -webkit-hyphens: none;
    hyphens: none;
    font-size: 0.7em;
    line-height: 1.3em;
  }
    pre code, pre tt {
    white-space: pre;
  }
</style>  
```

其中style不知道什么意思，测试了一下去掉它也可以。

参考：<http://blog.overstuffedgorilla.com/syntax-highlighting-on-ghost/>