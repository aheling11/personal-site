---
title: "Count-Min Sketch算法"
date: 2020-07-19T20:10:08+08:00
draft: true
Author: Jeffrey
tags: [
  "算法",
  "数据结构",
]
categories: [
  "修炼内功",
]
---

# Count-Min Sketch算法

## 应用背景

之前我们有了解过布隆过滤器（Bloom Filter），布隆过滤器可以很好的处理判断海量数据中某元素是否存在的问题，但是布隆过滤器并不能统计元素出现的频率。

现在假如我们有个这样的需求：