---
title: "布隆过滤器(Bloom Filter)"
date: 2020-07-16T20:12:40+08:00
draft: false
Author: Jeffrey
tags: [
  "算法",
  "数据结构",
]
categories: [
  "修炼内功",
]
---

## 应用背景

在我们开发软件的过程中，在很多场景下，我们都需要一个能迅速判断一个元素是否在一个集合中。譬如：

- 网页爬虫对URL的去重，避免爬取相同的URL地址

- 反垃圾邮件，从数十亿个垃圾邮件列表中判断某邮箱是否垃圾邮箱（同理，垃圾短信）

我们可能很快就能想到用哈希表这种数据结构来实现，判断一个数是否存在重复，时间复杂度只要O(1)，拿到要判断的数，hash一下，找到对应的桶位置，看有没有被占用就行了。

当数据量小的时候使用哈希表可能没什么问题，但当数据量海量的时候，哈希表可能就顶不住了。

为啥顶不住呢？空间不够用了

试想一下1亿条数据，全部存在哈希表里，那就是1亿个键值对，就算key和value都是Int型，分别占4个字节，一对就是8个字节，1亿 * 8字节  = 0.75G内存，还有哈希表为了避免哈希冲突，一般存储效率都不是很高，我们都会设置一个负载因子，在Java的HashMap里这个负载因子的大小默认为0.75，意味着我们总是只使用最大容量*负载因子大小的空间来存储数据。总的来说为了进行数据查重，我们得花1G的内存，当我们数据量更大更复杂的时候，这个开销会更大，这个时候，布隆过滤器（Bloom Filter）就应运而生。在继续介绍布隆过滤器的原理时，先讲解下关于哈希函数的预备知识。



### 哈希函数

哈希函数的概念是：将任意大小的数据转换成特定大小的数据的函数，转换后的数据称为哈希值或哈希编码。下面是一幅示意图：

![布隆1](https://tva1.sinaimg.cn/large/007S8ZIlgy1ggt415h221j30ai08rwew.jpg)

可以明显的看到，原始数据经过哈希函数的映射后称为了一个个的哈希编码，数据得到压缩。哈希函数是实现哈希表和布隆过滤器的基础。



## 实现原理

### 布隆过滤器（Bloom Filter）概念

布隆过滤器（英语：Bloom Filter）是1970年由一个叫布隆的小伙子提出的。它实际上是一个很长的二进制向量和一系列随机映射函数。布隆过滤器可以用于检索一个元素是否在一个集合中。它的优点是空间效率和查询时间都远远超过一般的算法，缺点是有一定的误识别率和删除困难。

### 布隆过滤器数据结构



![image-20200716210825725](https://tva1.sinaimg.cn/large/007S8ZIlgy1ggt4bfcbjaj31cs0qce0s.jpg)





布隆过滤器的原理是，当一个元素被加入集合时，通过K个散列函数将这个元素映射成一个位数组中的K个点，把它们置为1。检索元素时，我们只要看看这些点是不是都是1就知道集合中有没有它了：

1. 如果这些点有任何一个0，则被检索元素一定不在
2. 如果都是1，则被检索元素很可能在，但不能保证一定在

这就是布隆过滤器的基本思想。



再具体举个例子

布隆过滤器是一个 bit 向量或者说 bit 数组，长这样：

![img](https://pic4.zhimg.com/80/v2-530c9d4478398718c15632b9aa025c36_1440w.jpg)

如果我们要映射一个值到布隆过滤器中，我们需要使用**多个不同的哈希函数**生成**多个哈希值，**并对每个生成的哈希值指向的 bit 位置 1，例如针对值 “baidu” 和三个不同的哈希函数分别生成了哈希值 1、4、7，则上图转变为：

![img](https://pic4.zhimg.com/80/v2-a0ee721daf43f29dd42b7d441b79d227_1440w.jpg)

Ok，我们现在再存一个值 “tencent”，如果哈希函数返回 3、4、8 的话，图继续变为：

![img](https://pic1.zhimg.com/80/v2-c0c20d8e06308aae1578c16afdea3b6a_1440w.jpg)

值得注意的是，4 这个 bit 位由于两个值的哈希函数都返回了这个 bit 位，因此它被覆盖了。现在我们如果想查询 “dianping” 这个值是否存在，哈希函数返回了 1、5、8三个值，结果我们发现 5 这个 bit 位上的值为 0，**说明没有任何一个值映射到这个 bit 位上**，因此我们可以很确定地说 “dianping” 这个值不存在。而当我们需要查询 “baidu” 这个值是否存在的话，那么哈希函数必然会返回 1、4、7，然后我们检查发现这三个 bit 位上的值均为 1，那么我们可以说 “baidu” **存在了么？答案是不可以，只能是 “baidu” 这个值可能存在。**

## **如何选择哈希函数个数和布隆过滤器长度**

很显然，过小的布隆过滤器很快所有的 bit 位均为 1，那么查询任何值都会返回“可能存在”，起不到过滤的目的了。布隆过滤器的长度会直接影响误报率，布隆过滤器越长其误报率越小。

另外，哈希函数的个数也需要权衡，个数越多则布隆过滤器 bit 位置位 1 的速度越快，且布隆过滤器的效率越低；但是如果太少的话，那我们的误报率会变高。

![img](https://pic4.zhimg.com/80/v2-05d4a17ec47911d9ff0e72dc788d5573_1440w.jpg)k 为哈希函数个数，m 为布隆过滤器长度，n 为插入的元素个数，p 为误报率

如何选择适合业务的 k 和 m 值呢，这里直接贴一个公式：

![img](https://pic4.zhimg.com/80/v2-1ed5b79aa7ac2e9cd66c83690fdbfcf0_1440w.jpg)

如何推导这个公式这里只是提一句，因为对于使用来说并没有太大的意义，你让一个高中生来推会推得很快。k 次哈希函数某一 bit 位未被置为 1 的概率为：

![[公式]](https://www.zhihu.com/equation?tex=%281-%5Cfrac%7B1%7D%7Bm%7D%29%5E%7Bk%7D)

插入n个元素后依旧为 0 的概率和为 1 的概率分别是：

![[公式]](https://www.zhihu.com/equation?tex=%5Cleft%28+1-%5Cfrac%7B1%7D%7Bm%7D+%5Cright%29%5E%7Bnk%7D) ![[公式]](https://www.zhihu.com/equation?tex=1-+%5Cleft%28+1-%5Cfrac%7B1%7D%7Bm%7D+%5Cright%29%5E%7Bnk+%7D)

标明某个元素是否在集合中所需的 k 个位置都按照如上的方法设置为 1，但是该方法可能会使算法错误的认为某一原本不在集合中的元素却被检测为在该集合中（False Positives），该概率由以下公式确定

![[公式]](https://www.zhihu.com/equation?tex=%5Cleft%5B+1-+%5Cleft%28+1-%5Cfrac%7B1%7D%7Bm%7D+%5Cright%29%5E%7Bnk%7D+%5Cright%5D%5E%7Bk%7D%5Capprox%5Cleft%28+1-e%5E%7B-kn%2Fm%7D+%5Cright%29%5E%7Bk%7D)



## 参考资料

https://www.jasondavies.com/bloomfilter/

https://zhuanlan.zhihu.com/p/43263751












