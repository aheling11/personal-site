# 数据库三范式


## 第一范式（1NF）

强调的是列的原子性，即列不能再分为其他列

考虑这样一张表【联系人】（电话，地址，姓名）。

其中电话可以分为家庭电话和公司电话，所以这张表没有达到1NF。

要符合1NF，只需要改成【联系人】（家庭电话，公司电话，地址，姓名）就行了

在实际工作中，当我们拿出一个表设计的时候，可以看成已经符合 1NF 了。为什么说"可以看成"呢？举个例子，假设我们的关系中有个属性 address，是由 province city street 组成的。如果我们是物流行业，以后会按省份或城市进行分析，在这样的场景下 address 就是可分的，那这样的设计就不符合 1NF。如果我们业务中地址只是用作一下展示，那么 address 作为一个整体就不必细分了。重点不在于域本身，而在于业务场景中要如何使用域。

## 第二范式（2NF）

首先要满足1NF，然后在此基础上满足两个条件

1. 有主键

2. 没有包含在主键中的列都必须完全依赖于主键，而不能只依赖主键的一部分，即不能有部分依赖

考虑一个订单明细表：【OrderDetail】（OrderID，ProductID，UnitPrice，Discount，Quantity，ProductName）

其中，（OrderID，ProductID）是主键，而UnitPrice，ProductName是依赖于ProductID的，和OrderID没关系，这样就产生了部分依赖，不满足2NF。

可以把【OrderDetail】表拆分为【OrderDetail】（OrderID，ProductID，Discount，Quantity）和【Product】（ProductID，UnitPrice，ProductName）来消除原订单表中UnitPrice，ProductName多次重复的情况。

## 第三范式（3NF）

在1NF基础上，任何非主属性不依赖于其它非主属性[在2NF基础上消除传递依赖]。

第三范式（3NF）是第二范式（2NF）的一个子集，即满足第三范式（3NF）必须满足第二范式（2NF）。

例如，非主键列A依赖于非主键列B，而非主键列B依赖于主键，这就属于传递依赖。

 考虑一个订单表【Order】（OrderID，OrderDate，CustomerID，CustomerName，CustomerAddr，CustomerCity）主键是（OrderID）。 

其中 OrderDate，CustomerID，CustomerName，CustomerAddr，CustomerCity 等非主键列都完全依赖于主键（OrderID），所以符合 2NF。

但其中CustomerName，CustomerAddr，CustomerCity都依赖于非主键列CustomerID，而CustomerID依赖于OrderID。CustomerName，CustomerAddr，CustomerCity是通过传递才依赖于主键，所以不符合 3NF。

通过拆分【Order】为【Order】（OrderID，OrderDate，CustomerID）和【Customer】（CustomerID，CustomerName，CustomerAddr，CustomerCity）从而达到 3NF。 

## 总结

范式只是一个工具。它的提出是为了帮助我们减少数据库的冗余性，在设计阶段为我们提供思考上的便利。前面的介绍中也可以看出，并不是一定要苛求"精确地"符合范式，我们最终的目的，还是要根据业务场景设计出合适的结构。
