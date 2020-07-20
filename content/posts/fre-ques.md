---
title: "常见算法题"
date: 2020-02-15T22:09:16+08:00
Author: Jeffrey
tags: [
  "算法",
  "数据结构",
]
categories: [
  "修炼内功",
]
draft: false
---

[TOC]



# 常见题

## 1. 寻找第K大的值

### 问题描述

> 在未排序的数组中找到第 k 个最大的元素。请注意，你需要找的是数组排序后的第 k 个最大的元素，而不是第 k 个不同的元素。
>
> 示例 1:
>
> 输入: [3,2,1,5,6,4] 和 k = 2
> 输出: 5
> 示例 2:
>
> 输入: [3,2,3,1,2,4,5,5,6] 和 k = 4
> 输出: 4
> 说明:
>
> 你可以假设 k 总是有效的，且 1 ≤ k ≤ 数组的长度。
>
> 来源：力扣（LeetCode）
> 链接：https://leetcode-cn.com/problems/kth-largest-element-in-an-array

### 问题分析

这道题有几种做法

1. 对数组进行排序，直接选出第k大的数字，这样做的时间复杂度是O(nlogn)，也就是排序的时间复杂度。
2. 利用快速排序中partition的思想，对数组进行partition操作，即随机选择一个数x，比这个数小的数放在这个数左边，假设这部分为Sa，比这个数大的放在右边，假设这部分为Sb，如果Sb中的数个数为k-1，即比x大的数的个数k-1个，那么选择出来的这个数肯定是第k大的数。平均复杂度为O(n)。
3. 使用一个大小为k的最小堆来存储最大的k个数字，接下来每次从输入的n个数中读入一个数。如果最小堆中的数字少于k个，则直接把这次读入的数放入最小堆之中，如果最小堆中已有k个数字了，也就是最小堆已满，此时我们将这个要输入的数和最小堆根节点的数进行比较，如果这个数比根节点的值还要小则不需要加进来，如果这个数比根节点的值大则将其插入堆中，替换掉一个节点的值。时间复杂度为O(nlogn)

对比：

第二种方法会修改原来的数组，而且不是很适合处理海量数据。因为一旦数组大小n很大，内存可能放不下整个数组。这个时候就可以使用第三种方法，这种方法尽管速度比第二种慢，但是更适合处理海量数据，即n很大，k较小的情况，每次读取一个数字时，判断是不是需要将其放入最小堆中就行，所以内存能放下大小为k的最小堆即可。

### Solution

1. 基于partition的方法

   ```java
   public static int findKnumber(int[] nums, int k){
       int R = nums.length - 1;
       int L = 0;
       int index = partition(nums, 0, R);
       int length = nums.length - index;
       while(length != k){
           // 如果index右边的数小于k，则在index左边继续找
           if (length < k){ 
               R = index - 1;
               index = partition(nums, L, R); //每次更新
           }
           // 如果index右边的数大于k，则在index右边继续找
           else{
               L = index + 1;
               index = partition(nums, L, R);
           }
           length = nums.length - index;
       }
       return nums[index];
   }
   
   //就是快排里的partition操作
   public static int partition(int[] arr, int L, int R){
       swap(arr, R, L + (int)(Math.random()*(R - L + 1)));
       int less = L - 1;
       int more = R;
       int cur = L;
       while(cur < more){
           if (arr[cur] < arr[R]){
               swap(arr, cur++, ++less);
           } else if(arr[cur] > arr[R]){
               swap(arr, cur, --more);
           } else {
               cur++;
           }
       }
       swap(arr, cur, R);
       return more;
   }
   
   public static void swap(int[] arr, int i, int j) {
       int temp = arr[i];
       arr[i] = arr[j];
       arr[j] = temp;
   }
   ```

   

2. 基于堆的方法

   ```java
   public static int findKnumber_withheap(int[] nums, int k){
       //构建一个最小堆
       Queue<Integer> priorityqueue = new PriorityQueue<>();
       for (int i = 0; i < nums.length; i++) {
           //如果最小堆大小小于k，直接加进来
           if (priorityqueue.size() < k){
               priorityqueue.add(nums[i]);
           }
           //如果最小堆大小大于k，并且，要加进来的数的值大于根节点的值，插入该数
           else if (nums[i] > priorityqueue.peek()){
               priorityqueue.add(nums[i]);
               priorityqueue.poll();
           }
       }
       return priorityqueue.peek();
   }
   ```

## 2. 数组中出现次数超过一半的数字

### 问题描述

> 数组中有一个数字出现的次数超过数组长度的一半，请找出这个数字。例如输入一个长度为9的数组{1,2,3,2,2,2,5,4,2}。由于数字2在数组中出现了5次，超过数组长度的一半，因此输出2。如果不存在则输出0。
>
> 链接：https://www.nowcoder.com/practice/e8a1b01a2df14cb2b228b30ee6a92163?tpId=13&tqId=11181&tPage=1&rp=1&ru=/ta/coding-interviews&qru=/ta/coding-interviews/question-ranking&from=cyc_github

### 问题分析

这道题有几种做法

1. 如果这个数组是排好序的，那么中位数肯定是我们要找的那个数字。所以这道题实际上是要我们找中位数。我们可以使用partition方法来找出中位数。

2. 这个问题实际上是一个多数投票问题，可以利用 Boyer-Moore Majority Vote Algorithm 来解决这个问题，使得时间复杂度为 O(N)。使用一个times来统计一个数字出现的次数，如果该数字下一个数字不等于这个数字则times--，否则times++，如果times == 0，将统计的数字换成当前数字。因为有一个数字出现的次数超过数组长度的一半，所以最后剩下的times记录的肯定是这个数字。

3. 基于快速排序的思想，如果partition中随机的那个数的下标是n/2，那么这个数就是这个数组的中位数，



### Solution

1. 基于partition

   ```java
   public static int MoreThanHalfNum_Solution(int [] array) {
           int L = 0;
           int R = array.length - 1;
           int midindex = array.length>>1;
           int index = partition(array, L, R);
           while (index != midindex){
               if (index < midindex){
                   L = index + 1;
                   index = partition(array, L, R);
               } else if (index > midindex){
                   R = index - 1;
                   index = partition(array, L, R);
               }
           }
           if (moretanhalf(array, array[index])){
               return array[index];
           } else {
               return 0;
           }
       }
   // 判断这个数字出现次数有没有超过数组长度的一半
   public static boolean moretanhalf(int[] arr, int number){
           int halfn = arr.length>>1;
           int times = 0;
           for (int value : arr) {
               if (value == number) {
                   times++;
               }
           }
           return times > halfn;
       }
   ```

   

2. 基于 Boyer-Moore Majority Vote Algorithm

   ```java
   public static int MoreThanHalfNum_BoyerMoore(int [] array) {
          int times = 0;
          int number = array[0];
           for (int i = 0; i < array.length; i++) {
               if (times == 0){
                   number = array[i];
                   times = 1;
               } else if (number == array[i]){
                   times++;
               } else if (number != array[i]){
                   times--;
               }
           }
           if (moretanhalf(array, number)){
               return number;
           } else {
               return 0;
           }
       }
   
       public static boolean moretanhalf(int[] arr, int number){
           int halfn = arr.length>>1;
           int times = 0;
           for (int value : arr) {
               if (value == number) {
                   times++;
               }
           }
           return times > halfn;
       }
   ```

   

## 3. 旋转数组的最小数字

### 问题描述

> 把一个数组最开始的若干个元素搬到数组的末尾，我们称之为数组的旋转。
> 输入一个非递减排序的数组的一个旋转，输出旋转数组的最小元素。
> 例如数组{3,4,5,1,2}为{1,2,3,4,5}的一个旋转，该数组的最小值为1。
> NOTE：给出的所有元素都大于0，若数组大小为0，请返回0。
>
> 链接：https://www.nowcoder.com/practice/9f3231a991af4f55b95579b44b7a01ba?tpId=13&tqId=11159&tPage=1&rp=1&ru=%2Fta%2Fcoding-interviews&qru=%2Fta%2Fcoding-interviews%2Fquestion-ranking&from=cyc_github

### 问题分析

这道题有几种做法

1. 直接遍历数组，找出最小值，显然时间复杂度为O(N)，但是这样的做法没有利用旋转数组的特性

2. 观察到数组旋转后，数组分成了两个子数组，前面那个子数组的元素都大于或等于后面子数组的元素，我们还注意到最小元素就是这两个数组的分界线。我们可以使用二分查找法的思路来寻找这个最小的元素。

   首先使用两个指针（L 和 R指针）指向数组的第一个元素和最后一个元素，第一个指针所指的元素应该是大于第二个指针所指的元素的。接着可以找到数组中间的元素，如果该元素大于等于L所指元素，则说明该元素是在第一个子数组里的，那么将第一个指针指向该中间元素。相对应的，如果中间元素小于或者等于第二个指针指向的元素，那么将第二个指针指向该中间元素。通过这样不断缩小搜索的范围，第一个指针总是指向前面的递增子数组，第二个指针总是指向后面的子数组，最终，第二个指针指向的就是最小元素，终止条件为这两个指针相邻。

   到此基本思路已完成，但是其实没有考虑完善。

   出现「1，0，1，1，1」这种数组时，三个指针所指元素都相同，无法判断中间元素属于哪个子数组，所以直接使用顺序查找。

   

### Solution

1. 二分查找

   ```java
   public int minNumberInRotateArray(int [] array) {
           if (array.length < 1){
               return 0;
           }
           int L = 0;
           int R = array.length - 1;
           int midindex = L;
           while(array[L] >= array[R]){
               midindex = (L + R) >> 1;
   
               if (array[L] == array[R] && array[L] == array[midindex]){
                   return findminnumber(array);
               }
               if (R - L == 1){
                   midindex = R;
                   break;
               }
               if (array[midindex] >= array[L]){
                   L = midindex;
               } else if(array[midindex] <= array[R]){
                   R = midindex;
               }
           }
   
           return array[midindex];
       }
       public static int findminnumber(int[] arr){
           int min = Integer.MAX_VALUE;
           for (int i = 0; i < arr.length; i++) {
               if (arr[i] < min){
                   min = arr[i];
               }
           }
           return min;
       }
   ```

   

## 4. 二进制中1的个数

### 问题描述

> 输入一个整数，输出该数二进制表示中1的个数。其中负数用补码表示。
>
> 链接：https://www.nowcoder.com/practice/8ee967e43c2c4ec193b040ea7fbb10b8?tpId=13&tqId=11164&tPage=1&rp=1&ru=/ta/coding-interviews&qru=/ta/coding-interviews/question-ranking

### 问题分析

首先复习一下2的补码，Two‘s complement，在Java中就是使用补码来表示负数的。参考来自：https://www.ruanyifeng.com/blog/2009/08/twos_complement.html

**什么是2的补码？**

它是一种数值的转换方法，要分二步完成：

第一步，每一个二进制位都取相反值，0变成1，1变成0。比如，00001000的相反值就是11110111。

第二步，将上一步得到的值加1。11110111就变成11111000。

回到这题：

1. 我们一开始想到的做法是将该数与flag（初始化为1）进行与操作，这样可以判断该数最后一位是不是1，然后对flag进行左移操作，flag变成10，来判断该数最后第二位是不是1，依次类推。

2. 但是其实有更巧妙的算法，我们首先要知道一个性质，**(n-1)&n 得到的结果相当于把整数的二进制表示中最右边的1变成0。**利用该性质可以写出代码。

   比如 n = 1010, n - 1 = 1001, (n-1)&n = 1000

   ​		 n = 1011, n - 1 = 1010, (n-1)&n = 1010

### Solution

```java
public static int NumberOf1(int n) {
        int cnt = 0;
        while (n != 0){ // 循环终止条件就是n==0，因为最终n中所有位数都会变成0
            cnt++;
            n = (n - 1) & n;
        }
        System.out.println(cnt);
        return cnt;
    }
```

## 5. 快速幂

### 问题描述

> 实现 pow(x, n) ，即计算 x 的 n 次幂函数。
>
> 示例 1:
>
> 输入: 2.00000, 10
> 输出: 1024.00000
> 示例 2:
>
> 输入: 2.10000, 3
> 输出: 9.26100
> 示例 3:
>
> 输入: 2.00000, -2
> 输出: 0.25000
> 解释: 2-2 = 1/22 = 1/4 = 0.25
> 说明:
>
> -100.0 < x < 100.0
> n 是 32 位有符号整数，其数值范围是 [−231, 231 − 1] 。
>
> 来源：力扣（LeetCode）
> 链接：https://leetcode-cn.com/problems/powx-n

### 问题分析

方法1: 暴力，直观想法，模拟该过程，将x连续乘n次

方法2: 快速幂递归版本。

x^(n) = x^(n / 2) * x^(n / 2), n为偶数。

x^(n) = x^((n - 1)/ 2) * x^((n - 1)/ 2) * x, n为奇数。

方法3: 快速幂迭代版本。

### Solution

1. 快速幂递归版本

   ```java
   		public double myPow(double x, int n) {
           return help(x, (long)(n));
       }
   
       public double help(double x, long n){
           if(n == 0) return 1;
           if(n == 1) return x;
           int flag = 1;
           if(n < 0){
               n = ~n + 1;
               flag = 0;
           }
           double result = help(x, n/2);
           if((n & 1) == 0){
               result *= result;
           } else {
               result *= result;
               result *= x;
           }
           return flag == 0 ? 1 / result : result;
       }
   ```

   

2. 快速幂迭代版本

   ```java
   public double myPow(double x, int n) {
           double base = x;
           double ans = 1;
           long t = n;
     			//位运算，取绝对值
           if (t < 0) {
               t = ~t + 1;
           }
           while(t != 0){
               if((t & 1) == 1) {
                   ans *= base;
               } 
               base  = base * base;
               t >>= 1;
           }
           return n < 0 ? 1 / ans : ans;
       }
   ```

   

## 6. 树的子结构

### 问题描述

> 输入两棵二叉树A和B，判断B是不是A的子结构。(约定空树不是任意一个树的子结构)
>
> B是A的子结构， 即 A中有出现和B相同的结构和节点值。
>
> 例如:
> 给定的树 A:
>
> ​     3
> ​    / \
>
>    4   5
>   / \
>  1   2
> 给定的树 B：
>
>    4 
>   /
>  1
> 返回 true，因为 B 与 A 的一个子树拥有相同的结构和节点值。
>
> 示例 1：
>
> 输入：A = [1,2,3], B = [3,1]
> 输出：false
> 示例 2：
>
> 输入：A = [3,4,5,1,2], B = [4,1]
> 输出：true
> 限制：
>
> 0 <= 节点个数 <= 10000
>
> 来源：力扣（LeetCode）
> 链接：https://leetcode-cn.com/problems/shu-de-zi-jie-gou-lcof

### 问题分析

思路很直接，遍历树A，如果有节点与B的根节点值相同，判断该节点下是否包含B树。遍历使用递归实现会很方便。

### Solution

1. 递归

   ```java
   	public boolean isSubStructure(TreeNode A, TreeNode B) {
           if (A == null || B == null){
               return false;
           }
           boolean result = false;
           if (A.val == B.val){
               result = DoesAHaveB(A, B);
           }
           if (!result) result = isSubStructure(A.left, B);
           if (!result) result = isSubStructure(A.right, B);
           return result;
      }
   	//A树B树一起遍历
        public static boolean DoesAHaveB(TreeNode A, TreeNode B){
          //如果B被遍历完了说明符合条件
           if (B == null){
               return true;
           }
          //如果B没被遍历完，A遍历完了，说明B比A树更大，返回FALSE
           if (A == null){
               return false;
           }
           if (A.val != B.val){
               return false;
           }
           return DoesAHaveB(A.left, B.left) && DoesAHaveB(A.right, B.right);
   
       }
   ```


## 7. 二叉树的镜像

### 问题描述

> 请完成一个函数，输入一个二叉树，该函数输出它的镜像。
>
> 例如输入：
>
> ​     4
>
>    /   \
>   2     7
>  / \   / \
> 1   3 6   9
> 镜像输出：
>
> ​     4
>
>    /   \
>   7     2
>  / \   / \
> 9   6 3   1
>
>  
>
> 示例 1：
>
> 输入：root = [4,2,7,1,3,6,9]
> 输出：[4,7,2,9,6,3,1]
>
>
> 限制：
>
> 0 <= 节点个数 <= 1000
>
> 来源：力扣（LeetCode）
> 链接：https://leetcode-cn.com/problems/er-cha-shu-de-jing-xiang-lcof
>

### 问题分析

思路很直接，遍历树，每次遍历时交换left和right节点。

### Solution

我的解法

```java
	 public TreeNode mirrorTree(TreeNode root) {
        if(root == null){
            return root;
        }
        help(root);
        return root;
    }

    public void help(TreeNode root){
        if(root == null){
            return;
        }
        TreeNode t = root.left;
        root.left = root.right;
        root.right = t;
        help(root.left);
        help(root.right);
    }
```

更简便的解法：

```java
 public TreeNode mirrorTree(TreeNode root) {
    if(root == null){
            return null;
    }
    TreeNode t = root.left;
    root.left = mirrorTree(root.right);
    root.right = mirrorTree(t);
    return root;
}

```
## 8. 对称二叉树

### 问题描述

> 给定一个二叉树，检查它是否是镜像对称的。
>
> 例如，二叉树 [1,2,2,3,4,4,3] 是对称的。
>
> ​    1
>
>    / \
>   2   2
>  / \ / \
> 3  4 4  3
> 但是下面这个 [1,2,2,null,3,null,3] 则不是镜像对称的:
>
> ​    1
>
>    / \
>   2   2
>    \   \
>    3    3
> 说明:
>
> 如果你可以运用递归和迭代两种方法解决这个问题，会很加分。
>
> 来源：力扣（LeetCode）
> 链接：https://leetcode-cn.com/problems/symmetric-tree

### 问题分析

关键字：遍历，递归，队列

解这道题的关键在于，同时遍历节点的两边，镜像遍历。

前序遍历是根左右，我们可以改一下前序遍历，得到一种根右左的遍历方式，以这两种遍历方式同时遍历，节点的值不相等时返回false，遍历完没有返回false则返回true。

### Solution

1. 递归解法

   ```java
   public boolean isSymmetric(TreeNode root) {
           if(root == null){
               return true;
           }
           return isSymmetric(root.left, root.right);
       }
       public boolean isSymmetric(TreeNode root1, TreeNode root2) {
           if(root1 == null && root2 == null){
               return true;
           }
         //说明两边长度不一样。
           if(root1 == null || root2 == null){
               return false;
           }
           if(root1.val != root2.val){
               return false;
           }
         
           return isSymmetric(root1.left, root2.right) && isSymmetric(root1.right, root2.left);
       }
   ```

   

2. 非递归解法

   ```java
   public boolean isSysmmetric_nonrecur(TreeNode root){
           if(root == null){
               return true;
           }
           Queue<TreeNode> queue = new LinkedList<>();
           queue.add(root);
           queue.add(root);
           while (!queue.isEmpty()){
               TreeNode cur1 = queue.poll();
               TreeNode cur2 = queue.poll();
               if(cur1 == null && cur2 == null){
                   continue;
               }
               if (cur1 == null || cur2 == null){
                   return false;
               }
               if (cur1.val != cur2.val){
                   return false;
               }
               queue.add(cur1.left);
               queue.add(cur2.right);
               queue.add(cur1.right);
               queue.add(cur2.left);
           }
           return true;
       }
   ```

   



## 9. 最多可以参加的会议数目

### 问题描述

> 给你一个数组 events，其中 events[i] = [startDayi, endDayi] ，表示会议 i 开始于 startDayi ，结束于 endDayi 。
>
> 你可以在满足 startDayi <= d <= endDayi 中的任意一天 d 参加会议 i 。注意，一天只能参加一个会议。
>
> 请你返回你可以参加的 最大 会议数目。
>
> 
> 输入：events = [[1,2],[2,3],[3,4]]
> 输出：3
> 解释：你可以参加所有的三个会议。
> 安排会议的一种方案如上图。
> 第 1 天参加第一个会议。
> 第 2 天参加第二个会议。
> 第 3 天参加第三个会议。
> 示例 2：
>
> 输入：events= [[1,2],[2,3],[3,4],[1,2]]
> 输出：4
> 示例 3：
>
> 输入：events = [[1,4],[4,4],[2,2],[3,4],[1,1]]
> 输出：4
> 示例 4：
>
> 输入：events = [[1,100000]]
> 输出：1
> 示例 5：
>
> 输入：events = [[1,1],[1,2],[1,3],[1,4],[1,5],[1,6],[1,7]]
> 输出：7
>
>
> 提示：
>
> 1 <= events.length <= 10^5
> events[i].length == 2
> 1 <= events[i][0] <= events[i][1] <= 10^5
>
> 来源：力扣（LeetCode）
> 链接：https://leetcode-cn.com/problems/maximum-number-of-events-that-can-be-attended

### 问题分析

关键字：贪心，set，排序

这题直观的想法是贪心，时间复杂度是O(n*n)，进阶的做法是优先队列，可以优化到O(n * logn)。

首先根据会议结束时间对会议events进行排序，结束时间最早的会议优先参加。由于每天只能参加一个会议，所以可以用set存储参加过的天数。	

### Solution

1. 我的解法：用数组来存储参加过会议的天数。

   ```java
   	static class Number implements Comparable<Number>{
           Integer data;
           int index;
           public Number(Integer data, int index) {
               this.data = data;
               this.index = index;
           }
           @Override
           public int compareTo(Number number) {
               return data.compareTo(number.data);
           }
       }
       public static int maxEvents(int[][] events) {
           Number[] sorted = new Number[events.length];
           for (int i = 0; i < events.length; i++) {
               sorted[i] = new Number(events[i][1], i);
           }
           Arrays.sort(sorted);
           int[] occupiedDays = new int[10001];
           int sum = 0;
           for(Number number : sorted){
               int index = number.index;
               for (int i = events[index][0]; i <= events[index][1]; i++) {
                   if (occupiedDays[i] == 0){
                       occupiedDays[i] = 1;
                       sum++;
                       break;
                   }
               }
           }
           return sum;
       }
   ```

   

2. 更简洁的写法

   ```java
   public int maxEvents(int[][] events) {
           Arrays.sort(events, (o1 , o2) -> o1[1] - o2[1]);
           Set<Integer> set = new HashSet<>();
           for (int[] event : events) {
               int s = event[0];
               int e = event[1];
               for (int i = s; i <= e; i++) {
                   if (!set.contains(i)){
                       set.add(i);
                       break;
                   }
               }
           }
           return set.size();
       }
   ```

   

## 10. 二叉搜索树与双向链表

### 问题描述

> 输入一棵二叉搜索树，将该二叉搜索树转换成一个排序的循环双向链表。要求不能创建任何新的节点，只能调整树中节点指针的指向。
>
>  
>
> 为了让您更好地理解问题，以下面的二叉搜索树为例：
>
>  ![img](https://assets.leetcode.com/uploads/2018/10/12/bstdlloriginalbst.png)
>
> 
>
>  
>
> 我们希望将这个二叉搜索树转化为双向循环链表。链表中的每个节点都有一个前驱和后继指针。对于双向循环链表，第一个节点的前驱是最后一个节点，最后一个节点的后继是第一个节点。
>
> 下图展示了上面的二叉搜索树转化成的链表。“head” 表示指向链表中有最小元素的节点。
>
>  
>
> ![img](https://assets.leetcode.com/uploads/2018/10/12/bstdllreturndll.png)
>
>  
>
> 特别地，我们希望可以就地完成转换操作。当转化完成以后，树中节点的左指针需要指向前驱，树中节点的右指针需要指向后继。还需要返回链表中的第一个节点的指针。
>
> 来源：力扣（LeetCode）
> 链接：https://leetcode-cn.com/problems/er-cha-sou-suo-shu-yu-shuang-xiang-lian-biao-lcof
>

### 问题分析

关键字：二叉树，中序遍历，pre节点

首先这是一个二叉搜索树，进行中序遍历就可以得到从小到大排序好的节点们。找到最小的那个节点，返回的双向列表的head即这个节点，并把end也初始化为最小的这个节点。之后每遍历到一个新的节点，连接该节点与之前的end节点，再把end赋值为新的节点，可以看成一个贪吃蛇，不停的在把尾巴延长。中序遍历完后，也就完成了整个需要返回的链表。	

### Solution

1. 递归版。

   ```java
   	class Solution {
       Node head = null;
       Node end = null;
       public Node treeToDoublyList(Node root) {
           if(root == null) return root;
           process(root);
           end.right = head;
           head.left = end;
           return head;
       }
   
       //返回最后一个节点
       public void process(Node root){
           if (root == null) return ;
           process(root.left);
           if (end == null){
               head = root;
               end = root;
           } else {
               end.right = root;
               root.left = end;
               end = root;
           }
           process(root.right);
       }
   }
   ```

   

2. 非递归版

   ```java
   class Solution {
       Node head = null;
       Node end = null;
       public Node treeToDoublyList(Node root) {
           if (root == null) return root;
           Stack<Node> stack = new Stack<>();
           Node cur = root;
           int flag = 0;
           while (cur != null || !stack.isEmpty()){
               while (cur != null){
                   stack.push(cur);
                   cur = cur.left;
               }
               cur = stack.pop();
               if (flag == 0){
                   head = cur;
                   end = cur;
                   flag = 1;
               } else {
                   end.right = cur;
                   cur.left = end;
                   end = cur;
               }
               cur = cur.right;
           }
           end.right = head;
           head.left = end;
           return head;
       }
   }
   ```

   



## 11. 把数组排成最小的数

### 问题描述

> 输入一个正整数数组，把数组里所有数字拼接起来排成一个数，打印能拼接出的所有数字中最小的一个。
>
>  
>
> 示例 1:
>
> 输入: [10,2]
> 输出: "102"
> 示例 2:
>
> 输入: [3,30,34,5,9]
> 输出: "3033459"
>
>
> 提示:
>
> 0 < nums.length <= 100
> 说明:
>
> 输出结果可能非常大，所以你需要返回一个字符串而不是整数
> 拼接起来的数字可能会有前导 0，最后结果不需要去掉前导 0
>
> 来源：力扣（LeetCode）
> 链接：https://leetcode-cn.com/problems/ba-shu-zu-pai-cheng-zui-xiao-de-shu-lcof
>

### 问题分析

关键字：排序，Comparator，Java 函数式编程，大数问题

实际上是要我们定制一套比较规则，然后对所有数字进行排序。比如说有数字n和数字m，比较拼接后的数字nm和数字mn的大小，如果nm < mn，则我们定义n小于m；反之，如果mn > nm，则m小于n；nm = mn，则n等于m。定制好规则并排序后，将所有数字拼接起来则得到结果。

需要注意的是，拼接两个数字nm时，如果直接用int比较有数值溢出的可能，所以我们可以使用字符串来进行比较。

### Solution

1. 我的解法：新建了一个Number类，实现了Comparable接口。

   ```java
   	static class Number implements Comparable<Number>{
           int data;
           public Number(int num){
               this.data = num;
           }
           @Override
           public int compareTo(Number mnumber) {
               int n = data;
               int m = mnumber.data;
               String nm = String.valueOf(n) + m;
               String mn = String.valueOf(m) + n;
               return nm.compareTo(mn);
           }
       }
   
       public static String minNumber(int[] nums) {
           Number[] Numbers = new Number[nums.length];
           for (int i = 0; i < nums.length; i++) {
               Numbers[i] = new Number(nums[i]);
           }
           Arrays.sort(Numbers);
           StringBuilder sb = new StringBuilder();
           for (int i = 0; i < Numbers.length; i++) {
               sb.append(Numbers[i].data);
           }
           return sb.toString();
       }
   ```

   

2. 更简洁的写法，使用了函数式编程来实现Comparator接口

   ```java
   public static String minNumber_2(int[] nums) {
           List<String> list = new ArrayList<>();
           for(int num : nums){
               list.add(String.valueOf(num));
           }
           list.sort((s1 , s2) -> (s1 + s2).compareTo(s2 + s1));
           StringBuilder sb = new StringBuilder();
           for(String str : list){
               sb.append(str);
           }
           return sb.toString();
       }
   ```

   