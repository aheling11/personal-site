# leetcode 718. 最长重复子数组




### 问题描述


给两个整数数组 `A` 和 `B` ，返回两个数组中公共的、长度最长的子数组的长度。

**示例 1:**

```Java
输入:
A: [1,2,3,2,1]
B: [3,2,1,4,7]
输出: 3
解释: 
长度最长的公共子数组是 [3, 2, 1]。
```



### 问题分析

使用动态规划的思想可解

DP思路：

如果只看A和B



### Solution

```java
public int findLength(int[] A, int[] B) {
        int[][] dp = new int[A.length + 1][B.length + 1];
        int result = 0;
        for(int i = 1; i <= A.length; i++){
            for(int j = 1; j <= B.length; j++){
                if(A[i - 1] == B[j - 1]){
                    dp[i][j] = dp[i - 1][j - 1] + 1;
                }
                result = Math.max(result, dp[i][j]);
            }
        }
        return result;

    }
```


