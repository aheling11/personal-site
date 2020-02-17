# 常见算法题


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

2. 如果这个数组是排好序的，那么中位数肯定是我们要找的那个数字。所以这道题实际上是要我们找中位数。我们可以使用partition方法来找出中位数。
3. 这个问题实际上是一个多数投票问题，可以利用 Boyer-Moore Majority Vote Algorithm 来解决这个问题，使得时间复杂度为 O(N)。使用一个times来统计一个数字出现的次数，如果该数字下一个数字不等于这个数字则times--，否则times++，如果times == 0，将统计的数字换成当前数字。因为有一个数字出现的次数超过数组长度的一半，所以最后剩下的times记录的肯定是这个数字。
4. 使用一个大小为k的最小堆来存储最大的k个数字，接下来每次从输入的n个数中读入一个数。如果最小堆中的数字少于k个，则直接把这次读入的数放入最小堆之中，如果最小堆中已有k个数字了，也就是最小堆已满，此时我们将这个要输入的数和最小堆根节点的数进行比较，如果这个数比根节点的值还要小则不需要加进来，如果这个数比根节点的值大则将其插入堆中，替换掉一个节点的值。时间复杂度为O(nlogn)

对比：

第二种方法会修改原来的数组，而且不是很适合处理海量数据。因为一旦数组大小n很大，内存可能放不下整个数组。这个时候就可以使用第三种方法，这种方法尽管速度比第二种慢，但是更适合处理海量数据，即n很大，k较小的情况，每次读取一个数字时，判断是不是需要将其放入最小堆中就行，所以内存能放下大小为k的最小堆即可。

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


