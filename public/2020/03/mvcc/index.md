# Mvcc




## 开始

最近在读《高性能MySQL》这本书，总结一下MVCC的内容。

个人观点，如有错误欢迎交流~

## MVCC是什么？

MVCC全称是Multi-Version Concurrency Control，多版本并发控制。基于提升并发性能的考虑，很多数据库包括MySQL，Oracle也都实现了MVCC。



## 使用MVCC的好处？

MVCC的最大好处：读不加任何锁，读写不冲突，对于读操作多于写操作的应用，极大的增加了系统的并发性能。



## MVCC是怎样工作的？

不同存储引擎的MVCC实现是不同的，典型的有乐观（optimistic）并发控制和悲观（pessimistic）并发控制。

下面通过innoDB的简化版行为来说明MVCC是如何工作的。

InnoDB的MVCC是通过在每行记录后面保存两个隐藏的列来实现。这两个列，一个保存了行的创建时间，一个保存了行的过期时间（删除时间）。并且存储的并不是真实的时间值，而是系统版本号（system version number）。每开始一个新的事务，系统版本号都会自动递增。事务开始时刻的系统版本号会作为事务的版本号，用来和查询到的每行记录的版本号进行比较。

下面看一下在REPEATEABLE READ级别下，MVCC是如何具体操作的**：**

**SELECT**

InnoDB会根据以下两个条件检查没行记录：
 1. InnoDB只会查找版本早于当前事务版本的数据行（也就是，行的系统版本小于或等于事务的系统版本号），
    这样可以确保事务读取到的行，要么是事务开始前已经存在的，要么是事务自身插入或者修改过的。

 2.  行的删除版本要么未定义，要么大于当前事务的版本号。这样可以确保事务读取到的行，在事务之前未被
    删除。

    只有符合上述两个条件的记录，才能被作为返回查询结果

**INSERT**

InnoDB为新插入的一行保存当前系统版本号作为行版本号

**DELETE**

InnoDB为删除的每一行保存当前系统版本号作为删除标识

**UPDATE**

UPDATE为插入一行新纪录，保存当前系统版本号作为行版本号，同时保存当前系统版本号到原来的行作为删除标识。



只看文字可能不太好理解，下面用实例来说明一下，下面是一张学生信息表user_info

| student_ID | name  | age  | created_time | delete_time |
| ---------- | ----- | ---- | ------------ | ----------- |
| 1          | Alice | 18   | 12           | 14          |
| 2          | Bob   | 20   | 11           |             |
| 3          | David | 19   | 16           |             |
| 4          | Jeff  | 22   | 14           | 16          |



假如我们现在开启一个新事务，当前事务版本为15。

其实我们只要看update是怎么操作的就很好理解了

```sql
UPDATE user_info SET name = 'Tom' WHERE name = 'Bob'
```

那么整个表会插入一条新记录，并保存当前版本号15，同时UPDATE的那行记录会保存当前版本号15作为删除标识。

| student_ID | name  | age  | created_time | delete_time |
| ---------- | ----- | ---- | ------------ | ----------- |
| 1          | Alice | 18   | 12           | 14          |
| 2          | Bob   | 20   | 11           | 15          |
| 3          | David | 19   | 16           |             |
| 4          | Jeff  | 22   | 14           | 16          |
| 2          | Tom   | 20   | 15           |             |

我的理解DELETE操作也是不会真正删除数据的，删除的那行记录还是会暂时保存快照在数据库中，如下

```sql
DELETE FROM user_info WHERE student_ID = 2;
```

| student_ID | name  | age  | created_time | delete_time |
| ---------- | ----- | ---- | ------------ | ----------- |
| 1          | Alice | 18   | 12           | 14          |
| 2          | Bob   | 20   | 11           | 15          |
| 3          | David | 19   | 16           |             |
| 4          | Jeff  | 22   | 14           | 16          |



下面举个INSERT的例子，执行如下语句

```sql
INSERT INTO user_info(name, age) VALUES('John','23');
```

那么就会新添加一条记录如下

| student_ID | name  | age  | created_time | delete_time |
| ---------- | ----- | ---- | ------------ | ----------- |
| 1          | Alice | 18   | 12           | 14          |
| 2          | Bob   | 20   | 11           |             |
| 3          | David | 19   | 16           |             |
| 4          | Jeff  | 22   | 14           | 16          |
| 5          | John  | 23   | 15           |             |

SELECT也举个例子吧，执行如下语句

```sql
SELECT * FROM user_info;
```

那么只会返回

| student_ID | name  | age  | created_time | delete_time |
| ---------- | ----- | ---- | ------------ | ----------- |
| 1          | Alice | 18   | 12           | 14          |
| 2          | Bob   | 20   | 11           |             |
| 4          | Jeff  | 22   | 14           | 16          |



保存着两个额外的系统版本号，使大多数读操作都可以不用加锁。这样设计使得读操作简单，性能强，并且保证只会读取到符合标准的行。不足之处是没行记录都需要额外的存储空间，需要做更多的检查工作，以及一些额外的维护工作。



## 需要注意的是
MVCC只在REPEATABLE READ和READ COMMITTED两个隔离级别下工作。其他两个隔离级别都和MVCC不兼容，因为READ UNCOMMITTED总是读取最新的数据行，而不是符合当前事务版本的数据行，而SERIALIZABLE会对所有读取到的行都加锁。
