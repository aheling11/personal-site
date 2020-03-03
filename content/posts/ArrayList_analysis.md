---
title: "ArrayList源码分析"
date: 2020-02-16T22:14:02+08:00
draft: true
---

# 概述

本文将从几个常用方法入手，来阅读ArrayList的源码，读完一部分后就会进行总结。

按照从构造方法->常用API（增、 删、改、查）的顺序来阅读源码。

# 概要

ArrayList是动态数组，它是线程不安全的，允许元素是null。

ArrayList是继承自`AbstractList`类，实现了`List<E>, RandomAccess, Cloneable, java.io.Serializable`接口，其中`RandomAccess`代表了其拥有**随机快速访问**的能力，`ArrayList`可以以O(1)的时间复杂度去根据下标访问元素。

因为其底层数据结构是数组，可想而知，它是占据一块连续的内存空间，所以也有数组的缺点，空间效率不高。

由于数组的内存连续，可以根据下标以O(的时间**读写(改查)**元素，因此**时间效率很高**。

当集合中的元素超出这个容量，便会进行扩容操作。扩容操作也是ArrayList 的一个性能消耗比较大的地方，所以若我们可以提前预知数据的规模，应该通过`public ArrayList(int initialCapacity) {}`构造方法，指定集合的大小，去构建ArrayList实例，以减少扩容次数，提高效率。

或者在需要扩容的时候，手动调用`public void ensureCapacity(int minCapacity) {}`方法扩容。
不过该方法是ArrayList的API，不是List接口里的，所以使用时需要强转:
`((ArrayList)list).ensureCapacity(30);`

# 构造方法

```java



//默认构造方法中的空数组
private static final Object[] DEFAULTCAPACITY_EMPTY_ELEMENTDATA = {};

// 底层真正存储数据的数组
transient Object[] elementData; 

//默认构造方法
public ArrayList() {
    this.elementData = DEFAULTCAPACITY_EMPTY_ELEMENTDATA;
}

//空数组
private static final Object[] EMPTY_ELEMENTDATA = {};

//带初始容量的构造方法
public ArrayList(int initialCapacity) {
    if (initialCapacity > 0) {
        this.elementData = new Object[initialCapacity];
    } else if (initialCapacity == 0) {
        this.elementData = EMPTY_ELEMENTDATA;
    } else {
        throw new IllegalArgumentException("Illegal Capacity: "+
                                           initialCapacity);
    }
}


//利用别的集合类来构建ArrayList的构造函数
public ArrayList(Collection<? extends E> c) {
  	//利用别的集合类来构建ArrayList的构造函数
    elementData = c.toArray();
   //因为size代表的是集合元素数量，所以通过别的集合来构造ArrayList时，要给size赋值
    if ((size = elementData.length) != 0) {
        // c.toArray might (incorrectly) not return Object[] (see 6260652)
        if (elementData.getClass() != Object[].class) //当c.toArray没有正确返回Object[]时，利用Arrays.copyOf来复制集合c中的元素到elementData中来
            elementData = Arrays.copyOf(elementData, size, Object[].class);
    } else {
        // replace with empty array.
        this.elementData = EMPTY_ELEMENTDATA;
    }
}
```

这里需要注意的方法有**Arrays.copyOf(elementData, size, Object[].class)**

```java

public static <T,U> T[] copyOf(U[] original, int newLength, Class<? extends T[]> newType) {
    @SuppressWarnings("unchecked")
  //根据class的类型来决定是new 还是反射去构造一个泛型数组
    T[] copy = ((Object)newType == (Object)Object[].class)
        ? (T[]) new Object[newLength]
        : (T[]) Array.newInstance(newType.getComponentType(), newLength);
  //利用native函数，批量赋值元素至新数组中。如果
    System.arraycopy(original, 0, copy, 0,
                     Math.min(original.length, newLength));
    return copy;
}
```

还有**System.arraycopy()**也是一个使用很高频的函数，是native函数

```java
public static native void arraycopy(Object src,  int  srcPos,
                                    Object dest, int destPos,
                                    int length);
```


# 增

```java
public boolean add(E e) {
    ensureCapacityInternal(size + 1);  // Increments modCount!!
    elementData[size++] = e;
    return true;
}
```

```java
public void add(int index, E element) {
    rangeCheckForAdd(index);

    ensureCapacityInternal(size + 1);  // Increments modCount!!
    System.arraycopy(elementData, index, elementData, index + 1,
                     size - index);
    elementData[index] = element;
    size++;
}
```

**总结：**
add、addAll。
先判断是否越界，是否需要扩容。
如果扩容， 就复制数组。
然后设置对应下标元素值。

值得注意的是：
1 **如果需要扩容的话，默认扩容一半。如果扩容一半不够，就用目标的size作为扩容后的容量。**
2 **在扩容成功后，会修改modCount**



# 删

**小结：**
1 删除操作**一定会修改modCount**，且**可能涉及到数组的复制**，**相对低效**。
2 批量删除中，涉及高效的保存两个集合公有元素的算法，可以留意一下。



# 改

**不会修改modCount，相对增删是高效的操作。**

```java
/**
 * Replaces the element at the specified position in this list with
 * the specified element.
 *
 * @param index index of the element to replace
 * @param element element to be stored at the specified position
 * @return the element previously at the specified position
 * @throws IndexOutOfBoundsException {@inheritDoc}
 */
public E set(int index, E element) {
    rangeCheck(index); //越界检查

    E oldValue = elementData(index); //取出元素
    elementData[index] = element; //覆盖元素
    return oldValue;
}
```

# 查

**不会修改modCount，相对增删是高效的操作。**

```java
public E get(int index) {
    rangeCheck(index);
    checkForComodification();
    return ArrayList.this.elementData(offset + index);
}
```

# 总结

