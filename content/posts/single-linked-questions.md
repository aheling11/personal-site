---
title: "链表题汇总"
date: 2020-02-15T21:23:15+08:00
Author: Jeffrey
tags: [
  "链表",
  "数据结构"
]
categories: [
  "修炼内功",
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



## 3.合并两个有序链表

### 问题描述

> 将两个有序链表合并为一个新的有序链表并返回。新链表是通过拼接给定的两个链表的所有节点组成的。 
>
> 示例：
>
> 输入：1->2->4, 1->3->4
> 输出：1->1->2->3->4->4
>
> 来源：力扣（LeetCode）
> 链接：https://leetcode-cn.com/problems/merge-two-sorted-lists

### 问题分析

此题有递归和迭代两种实现方式。

### Solution

1. 迭代

```java
public ListNode mergeTwoLists_iter(ListNode l1, ListNode l2) {
        ListNode dhead = new ListNode(0);
        ListNode prev = dhead;
        while (l1 != null && l2 != null){
            if (l1.val < l2.val){
                prev.next = l1;
                l1 = l1.next;
            } else {
                prev.next = l2;
                l2 = l2.next;
            }
            prev = prev.next;
        }
        if (l1 != null){
            prev.next = l1;
        }
        if (l2 != null){
            prev.next = l2;
        }
        return dhead.next;
    }
```



2. 递归

   ```java
   public ListNode mergeTwoLists(ListNode l1, ListNode l2) {
       if(l1 == null){
           return l2;
       }
       if(l2 == null){
           return l1;
       }
       if (l1.val < l2.val){
           l1.next = mergeTwoLists(l1.next, l2);
           return l1;
       } else {
           l2.next = mergeTwoLists(l1, l2.next);
           return l2;
       }
   }
   ```