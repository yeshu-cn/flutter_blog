---
title: Canvas 绘制阴影
permalink: canvase-hui-zhi-yin-ying
id: 67
updated: '2016-04-07 08:34:04'
date: 2016-04-07 08:30:43
tags:
---



使用`Paint`的`setShadowLayer`方法

```
//If radius is 0, then the shadow layer is removed.
public void setShadowLayer(float radius, float dx, float dy, int shadowColor);
```

注意：该方法不支持硬件加速，所以使用前需要调用`View.setLayerType(LAYER_TYPE_SOFTWARE, null);`才会有效果