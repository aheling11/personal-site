---
title: "链表题汇总"
date: 2020-02-15T21:23:15+08:00
Author: HeLing
Tags:[
"链表",
"刷题"
]
categories: [
    "面试",
]
draft: false
---

# 链表题汇总

[TOC]

## 1.反转链表

### 问题描述

> LeetCode: 输入一个链表，反转链表后，输出链表的所有元素。
>
> **示例**:
>
> 输入: 1->2->3->4->5->NULL
>
> 输出: 5->4->3->2->1->NULL

### 问题分析

这道算法题，说直白点就是：如何让后一个节点指向前一个节点。下面的代码中定义了一个next节点用来保存反转后的头节点。

### Solution

```java
/**
 * Definition for singly-linked list.
 * public class ListNode {
 *     int val;
 *     ListNode next;
 *     ListNode(int x) { val = x; }
 * }
 */
class Solution {
    public ListNode reverseList(ListNode head) {
        ListNode next = null;
        ListNode pre = null;
   
        while(head != null){
            // 存储head后的节点
            next = head.next;
            // 将head指向前面那个节点,头结点指向null
            head.next = pre;
            // pre重新指向head
            pre = head;
            head = next;
        }
        return pre;
    }
}
```

## 2.反转链表 II

### 问题描述

> 反转从位置 m 到 n 的链表。请使用一趟扫描完成反转。
>
> 说明:
> 1 ≤ m ≤ n ≤ 链表长度。
>
> 示例:
>
> 输入: 1->2->3->4->5->NULL, m = 2, n = 4
> 输出: 1->4->3->2->5->NULL
>
> 来源：力扣（LeetCode）
> 链接：https://leetcode-cn.com/problems/reverse-linked-list-ii

### 问题分析

这道算法题需要对链表比较熟悉，设置一个pre变量记录反转开始前的那个节点，再设置一个cur变量记录反转开始的第一个节点。如图所示，以示例的数据为例，第一次循环后，第二次循环，也只操作cur和pre，节点3和节点2之间并不进行操作。

![示例](https://github.com/aheling11/algsLearning/blob/master/Doc/image/1.png?raw=true)



### Solution

```java
public static ListNode reverseBetween(ListNode head, int m, int n) {
        if (head == null){
            return head;
        }
        ListNode dummyhead = new ListNode(0);
        dummyhead.next = head;
        ListNode pre = dummyhead;
        for (int i = 1; i < m; i++) {
            pre = pre.next;
        }
        ListNode cur = pre.next; // cur的值不会变
        for (int i = m; i < n; i++) {
            ListNode next = cur.next;
            cur.next = next.next;
            next.next = pre.next;
            pre.next = next;

        }
        return dummyhead.next;

    }
```





