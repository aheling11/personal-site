---
title: "leetcode 209. 长度最小的子数组"
date: 2020-06-19T16:18:47+08:00
draft: false
Author: HeLing
tags: [
  "双指针",
  "滑动窗口"
]
categories: [
  "修炼内功",
]
---



### 问题描述

给定一个含有 n 个正整数的数组和一个正整数 s ，找出该数组中满足其和 ≥ s 的长度最小的连续子数组，并返回其长度。如果不存在符合条件的连续子数组，返回 0。 

示例：

输入：s = 7, nums = [2,3,1,2,4,3]
输出：2
解释：子数组 [4,3] 是该条件下的长度最小的连续子数组。



### 问题分析

使用滑动窗口的思想，双指针



### Solution

```java
public int minSubArrayLen(int s, int[] nums) {
        if(nums.length < 1){
            return 0;
        }
        int minlength = Integer.MAX_VALUE;
        int left = 0;
        int right = 0;
        int sum = 0;
        while(right < nums.length){
            sum += nums[right];
            while (sum >= s){
                minlength = Math.min(minlength, right - left + 1);
                sum -= nums[left++];
            }
            right++;
        }
        return minlength == Integer.MAX_VALUE ? 0 : minlength;
    }
```

