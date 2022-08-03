---
title: android canvas画虚线
permalink: android-canvashua-xu-xian
id: 58
updated: '2016-03-09 12:32:24'
date: 2016-03-09 12:30:11
tags:
---


画虚线的时候必须用path,直接drawLine的话是没效果的。

```java
        DashPathEffect pathEffect = new DashPathEffect(new float[] { 8, 8}, 1);
        Paint linePaint = new Paint();
        linePaint.reset();
        linePaint.setStyle(Paint.Style.STROKE);
        linePaint.setStrokeWidth(1);
        linePaint.setColor(Color.BLUE);
        linePaint.setAntiAlias(true);
        linePaint.setPathEffect(pathEffect);
        Path path = new Path();
        path.moveTo(200, 200);
        path.lineTo(800, 200);
        canvas.drawPath(path, linePaint);
```