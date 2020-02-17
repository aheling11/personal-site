---
title: "ArrayList源码分析"
date: 2020-02-16T22:14:02+08:00
draft: true
---

```java
//
// Source code recreated from a .class file by IntelliJ IDEA
// (powered by Fernflower decompiler)
//

package java.util;

import java.io.IOException;
import java.io.InvalidObjectException;
import java.io.ObjectInputStream;
import java.io.ObjectOutputStream;
import java.io.Serializable;
import java.util.function.Consumer;
import java.util.function.Predicate;
import java.util.function.UnaryOperator;
import jdk.internal.misc.SharedSecrets;

public class ArrayList<E> extends AbstractList<E> implements List<E>, RandomAccess, Cloneable, Serializable {
    private static final long serialVersionUID = 8683452581122892189L;
    private static final int DEFAULT_CAPACITY = 10;
    private static final Object[] EMPTY_ELEMENTDATA = new Object[0];
    private static final Object[] DEFAULTCAPACITY_EMPTY_ELEMENTDATA = new Object[0];
    transient Object[] elementData;
    private int size;
    private static final int MAX_ARRAY_SIZE = 2147483639;

    public ArrayList(int initialCapacity) {
        if (initialCapacity > 0) {
            this.elementData = new Object[initialCapacity];
        } else {
            if (initialCapacity != 0) {
                throw new IllegalArgumentException("Illegal Capacity: " + initialCapacity);
            }

            this.elementData = EMPTY_ELEMENTDATA;
        }

    }

    public ArrayList() {
        this.elementData = DEFAULTCAPACITY_EMPTY_ELEMENTDATA;
    }

    public ArrayList(Collection<? extends E> c) {
        this.elementData = c.toArray();
        if ((this.size = this.elementData.length) != 0) {
            if (this.elementData.getClass() != Object[].class) {
                this.elementData = Arrays.copyOf(this.elementData, this.size, Object[].class);
            }
        } else {
            this.elementData = EMPTY_ELEMENTDATA;
        }

    }

    public void trimToSize() {
        ++this.modCount;
        if (this.size < this.elementData.length) {
            this.elementData = this.size == 0 ? EMPTY_ELEMENTDATA : Arrays.copyOf(this.elementData, this.size);
        }

    }

    public void ensureCapacity(int minCapacity) {
        if (minCapacity > this.elementData.length && (this.elementData != DEFAULTCAPACITY_EMPTY_ELEMENTDATA || minCapacity > 10)) {
            ++this.modCount;
            this.grow(minCapacity);
        }

    }

    private Object[] grow(int minCapacity) {
        return this.elementData = Arrays.copyOf(this.elementData, this.newCapacity(minCapacity));
    }

    private Object[] grow() {
        return this.grow(this.size + 1);
    }

    private int newCapacity(int minCapacity) {
        int oldCapacity = this.elementData.length;
        int newCapacity = oldCapacity + (oldCapacity >> 1);
        if (newCapacity - minCapacity <= 0) {
            if (this.elementData == DEFAULTCAPACITY_EMPTY_ELEMENTDATA) {
                return Math.max(10, minCapacity);
            } else if (minCapacity < 0) {
                throw new OutOfMemoryError();
            } else {
                return minCapacity;
            }
        } else {
            return newCapacity - 2147483639 <= 0 ? newCapacity : hugeCapacity(minCapacity);
        }
    }

    private static int hugeCapacity(int minCapacity) {
        if (minCapacity < 0) {
            throw new OutOfMemoryError();
        } else {
            return minCapacity > 2147483639 ? 2147483647 : 2147483639;
        }
    }

    public int size() {
        return this.size;
    }

    public boolean isEmpty() {
        return this.size == 0;
    }

    public boolean contains(Object o) {
        return this.indexOf(o) >= 0;
    }

    public int indexOf(Object o) {
        return this.indexOfRange(o, 0, this.size);
    }

    int indexOfRange(Object o, int start, int end) {
        Object[] es = this.elementData;
        int i;
        if (o == null) {
            for(i = start; i < end; ++i) {
                if (es[i] == null) {
                    return i;
                }
            }
        } else {
            for(i = start; i < end; ++i) {
                if (o.equals(es[i])) {
                    return i;
                }
            }
        }

        return -1;
    }

    public int lastIndexOf(Object o) {
        return this.lastIndexOfRange(o, 0, this.size);
    }

    int lastIndexOfRange(Object o, int start, int end) {
        Object[] es = this.elementData;
        int i;
        if (o == null) {
            for(i = end - 1; i >= start; --i) {
                if (es[i] == null) {
                    return i;
                }
            }
        } else {
            for(i = end - 1; i >= start; --i) {
                if (o.equals(es[i])) {
                    return i;
                }
            }
        }

        return -1;
    }

    public Object clone() {
        try {
            ArrayList<?> v = (ArrayList)super.clone();
            v.elementData = Arrays.copyOf(this.elementData, this.size);
            v.modCount = 0;
            return v;
        } catch (CloneNotSupportedException var2) {
            throw new InternalError(var2);
        }
    }

    public Object[] toArray() {
        return Arrays.copyOf(this.elementData, this.size);
    }

    public <T> T[] toArray(T[] a) {
        if (a.length < this.size) {
            return Arrays.copyOf(this.elementData, this.size, a.getClass());
        } else {
            System.arraycopy(this.elementData, 0, a, 0, this.size);
            if (a.length > this.size) {
                a[this.size] = null;
            }

            return a;
        }
    }

    E elementData(int index) {
        return this.elementData[index];
    }

    static <E> E elementAt(Object[] es, int index) {
        return es[index];
    }

    public E get(int index) {
        Objects.checkIndex(index, this.size);
        return this.elementData(index);
    }

    public E set(int index, E element) {
        Objects.checkIndex(index, this.size);
        E oldValue = this.elementData(index);
        this.elementData[index] = element;
        return oldValue;
    }

    private void add(E e, Object[] elementData, int s) {
        if (s == elementData.length) {
            elementData = this.grow();
        }

        elementData[s] = e;
        this.size = s + 1;
    }

    public boolean add(E e) {
        ++this.modCount;
        this.add(e, this.elementData, this.size);
        return true;
    }

    public void add(int index, E element) {
        this.rangeCheckForAdd(index);
        ++this.modCount;
        int s;
        Object[] elementData;
        if ((s = this.size) == (elementData = this.elementData).length) {
            elementData = this.grow();
        }

        System.arraycopy(elementData, index, elementData, index + 1, s - index);
        elementData[index] = element;
        this.size = s + 1;
    }

    public E remove(int index) {
        Objects.checkIndex(index, this.size);
        Object[] es = this.elementData;
        E oldValue = es[index];
        this.fastRemove(es, index);
        return oldValue;
    }

    public boolean equals(Object o) {
        if (o == this) {
            return true;
        } else if (!(o instanceof List)) {
            return false;
        } else {
            int expectedModCount = this.modCount;
            boolean equal = o.getClass() == ArrayList.class ? this.equalsArrayList((ArrayList)o) : this.equalsRange((List)o, 0, this.size);
            this.checkForComodification(expectedModCount);
            return equal;
        }
    }

    boolean equalsRange(List<?> other, int from, int to) {
        Object[] es = this.elementData;
        if (to > es.length) {
            throw new ConcurrentModificationException();
        } else {
            Iterator oit;
            for(oit = other.iterator(); from < to; ++from) {
                if (!oit.hasNext() || !Objects.equals(es[from], oit.next())) {
                    return false;
                }
            }

            return !oit.hasNext();
        }
    }

    private boolean equalsArrayList(ArrayList<?> other) {
        int otherModCount = other.modCount;
        int s = this.size;
        boolean equal;
        if (equal = s == other.size) {
            Object[] otherEs = other.elementData;
            Object[] es = this.elementData;
            if (s > es.length || s > otherEs.length) {
                throw new ConcurrentModificationException();
            }

            for(int i = 0; i < s; ++i) {
                if (!Objects.equals(es[i], otherEs[i])) {
                    equal = false;
                    break;
                }
            }
        }

        other.checkForComodification(otherModCount);
        return equal;
    }

    private void checkForComodification(int expectedModCount) {
        if (this.modCount != expectedModCount) {
            throw new ConcurrentModificationException();
        }
    }

    public int hashCode() {
        int expectedModCount = this.modCount;
        int hash = this.hashCodeRange(0, this.size);
        this.checkForComodification(expectedModCount);
        return hash;
    }

    int hashCodeRange(int from, int to) {
        Object[] es = this.elementData;
        if (to > es.length) {
            throw new ConcurrentModificationException();
        } else {
            int hashCode = 1;

            for(int i = from; i < to; ++i) {
                Object e = es[i];
                hashCode = 31 * hashCode + (e == null ? 0 : e.hashCode());
            }

            return hashCode;
        }
    }

    public boolean remove(Object o) {
        Object[] es = this.elementData;
        int size = this.size;
        int i = 0;
        if (o == null) {
            while(true) {
                if (i >= size) {
                    return false;
                }

                if (es[i] == null) {
                    break;
                }

                ++i;
            }
        } else {
            while(true) {
                if (i >= size) {
                    return false;
                }

                if (o.equals(es[i])) {
                    break;
                }

                ++i;
            }
        }

        this.fastRemove(es, i);
        return true;
    }

    private void fastRemove(Object[] es, int i) {
        ++this.modCount;
        int newSize;
        if ((newSize = this.size - 1) > i) {
            System.arraycopy(es, i + 1, es, i, newSize - i);
        }

        es[this.size = newSize] = null;
    }

    public void clear() {
        ++this.modCount;
        Object[] es = this.elementData;
        int to = this.size;

        for(int i = this.size = 0; i < to; ++i) {
            es[i] = null;
        }

    }

    public boolean addAll(Collection<? extends E> c) {
        Object[] a = c.toArray();
        ++this.modCount;
        int numNew = a.length;
        if (numNew == 0) {
            return false;
        } else {
            Object[] elementData;
            int s;
            if (numNew > (elementData = this.elementData).length - (s = this.size)) {
                elementData = this.grow(s + numNew);
            }

            System.arraycopy(a, 0, elementData, s, numNew);
            this.size = s + numNew;
            return true;
        }
    }

    public boolean addAll(int index, Collection<? extends E> c) {
        this.rangeCheckForAdd(index);
        Object[] a = c.toArray();
        ++this.modCount;
        int numNew = a.length;
        if (numNew == 0) {
            return false;
        } else {
            Object[] elementData;
            int s;
            if (numNew > (elementData = this.elementData).length - (s = this.size)) {
                elementData = this.grow(s + numNew);
            }

            int numMoved = s - index;
            if (numMoved > 0) {
                System.arraycopy(elementData, index, elementData, index + numNew, numMoved);
            }

            System.arraycopy(a, 0, elementData, index, numNew);
            this.size = s + numNew;
            return true;
        }
    }

    protected void removeRange(int fromIndex, int toIndex) {
        if (fromIndex > toIndex) {
            throw new IndexOutOfBoundsException(outOfBoundsMsg(fromIndex, toIndex));
        } else {
            ++this.modCount;
            this.shiftTailOverGap(this.elementData, fromIndex, toIndex);
        }
    }

    private void shiftTailOverGap(Object[] es, int lo, int hi) {
        System.arraycopy(es, hi, es, lo, this.size - hi);
        int to = this.size;

        for(int i = this.size -= hi - lo; i < to; ++i) {
            es[i] = null;
        }

    }

    private void rangeCheckForAdd(int index) {
        if (index > this.size || index < 0) {
            throw new IndexOutOfBoundsException(this.outOfBoundsMsg(index));
        }
    }

    private String outOfBoundsMsg(int index) {
        return "Index: " + index + ", Size: " + this.size;
    }

    private static String outOfBoundsMsg(int fromIndex, int toIndex) {
        return "From Index: " + fromIndex + " > To Index: " + toIndex;
    }

    public boolean removeAll(Collection<?> c) {
        return this.batchRemove(c, false, 0, this.size);
    }

    public boolean retainAll(Collection<?> c) {
        return this.batchRemove(c, true, 0, this.size);
    }

    boolean batchRemove(Collection<?> c, boolean complement, int from, int end) {
        Objects.requireNonNull(c);
        Object[] es = this.elementData;

        for(int r = from; r != end; ++r) {
            if (c.contains(es[r]) != complement) {
                int w = r++;

                try {
                    for(; r < end; ++r) {
                        Object e;
                        if (c.contains(e = es[r]) == complement) {
                            es[w++] = e;
                        }
                    }
                } catch (Throwable var12) {
                    System.arraycopy(es, r, es, w, end - r);
                    w += end - r;
                    throw var12;
                } finally {
                    this.modCount += end - w;
                    this.shiftTailOverGap(es, w, end);
                }

                return true;
            }
        }

        return false;
    }

    private void writeObject(ObjectOutputStream s) throws IOException {
        int expectedModCount = this.modCount;
        s.defaultWriteObject();
        s.writeInt(this.size);

        for(int i = 0; i < this.size; ++i) {
            s.writeObject(this.elementData[i]);
        }

        if (this.modCount != expectedModCount) {
            throw new ConcurrentModificationException();
        }
    }

    private void readObject(ObjectInputStream s) throws IOException, ClassNotFoundException {
        s.defaultReadObject();
        s.readInt();
        if (this.size > 0) {
            SharedSecrets.getJavaObjectInputStreamAccess().checkArray(s, Object[].class, this.size);
            Object[] elements = new Object[this.size];

            for(int i = 0; i < this.size; ++i) {
                elements[i] = s.readObject();
            }

            this.elementData = elements;
        } else {
            if (this.size != 0) {
                throw new InvalidObjectException("Invalid size: " + this.size);
            }

            this.elementData = EMPTY_ELEMENTDATA;
        }

    }

    public ListIterator<E> listIterator(int index) {
        this.rangeCheckForAdd(index);
        return new ArrayList.ListItr(index);
    }

    public ListIterator<E> listIterator() {
        return new ArrayList.ListItr(0);
    }

    public Iterator<E> iterator() {
        return new ArrayList.Itr();
    }

    public List<E> subList(int fromIndex, int toIndex) {
        subListRangeCheck(fromIndex, toIndex, this.size);
        return new ArrayList.SubList(this, fromIndex, toIndex);
    }

    public void forEach(Consumer<? super E> action) {
        Objects.requireNonNull(action);
        int expectedModCount = this.modCount;
        Object[] es = this.elementData;
        int size = this.size;

        for(int i = 0; this.modCount == expectedModCount && i < size; ++i) {
            action.accept(elementAt(es, i));
        }

        if (this.modCount != expectedModCount) {
            throw new ConcurrentModificationException();
        }
    }

    public Spliterator<E> spliterator() {
        return new ArrayList.ArrayListSpliterator(0, -1, 0);
    }

    private static long[] nBits(int n) {
        return new long[(n - 1 >> 6) + 1];
    }

    private static void setBit(long[] bits, int i) {
        bits[i >> 6] |= 1L << i;
    }

    private static boolean isClear(long[] bits, int i) {
        return (bits[i >> 6] & 1L << i) == 0L;
    }

    public boolean removeIf(Predicate<? super E> filter) {
        return this.removeIf(filter, 0, this.size);
    }

    boolean removeIf(Predicate<? super E> filter, int i, int end) {
        Objects.requireNonNull(filter);
        int expectedModCount = this.modCount;

        Object[] es;
        for(es = this.elementData; i < end && !filter.test(elementAt(es, i)); ++i) {
        }

        if (i < end) {
            int beg = i;
            long[] deathRow = nBits(end - i);
            deathRow[0] = 1L;
            ++i;

            for(; i < end; ++i) {
                if (filter.test(elementAt(es, i))) {
                    setBit(deathRow, i - beg);
                }
            }

            if (this.modCount != expectedModCount) {
                throw new ConcurrentModificationException();
            } else {
                ++this.modCount;
                int w = beg;

                for(i = beg; i < end; ++i) {
                    if (isClear(deathRow, i - beg)) {
                        es[w++] = es[i];
                    }
                }

                this.shiftTailOverGap(es, w, end);
                return true;
            }
        } else if (this.modCount != expectedModCount) {
            throw new ConcurrentModificationException();
        } else {
            return false;
        }
    }

    public void replaceAll(UnaryOperator<E> operator) {
        this.replaceAllRange(operator, 0, this.size);
        ++this.modCount;
    }

    private void replaceAllRange(UnaryOperator<E> operator, int i, int end) {
        Objects.requireNonNull(operator);
        int expectedModCount = this.modCount;

        for(Object[] es = this.elementData; this.modCount == expectedModCount && i < end; ++i) {
            es[i] = operator.apply(elementAt(es, i));
        }

        if (this.modCount != expectedModCount) {
            throw new ConcurrentModificationException();
        }
    }

    public void sort(Comparator<? super E> c) {
        int expectedModCount = this.modCount;
        Arrays.sort(this.elementData, 0, this.size, c);
        if (this.modCount != expectedModCount) {
            throw new ConcurrentModificationException();
        } else {
            ++this.modCount;
        }
    }

    void checkInvariants() {
    }

    final class ArrayListSpliterator implements Spliterator<E> {
        private int index;
        private int fence;
        private int expectedModCount;

        ArrayListSpliterator(int origin, int fence, int expectedModCount) {
            this.index = origin;
            this.fence = fence;
            this.expectedModCount = expectedModCount;
        }

        private int getFence() {
            int hi;
            if ((hi = this.fence) < 0) {
                this.expectedModCount = ArrayList.this.modCount;
                hi = this.fence = ArrayList.this.size;
            }

            return hi;
        }

        public ArrayList<E>.ArrayListSpliterator trySplit() {
            int hi = this.getFence();
            int lo = this.index;
            int mid = lo + hi >>> 1;
            return lo >= mid ? null : ArrayList.this.new ArrayListSpliterator(lo, this.index = mid, this.expectedModCount);
        }

        public boolean tryAdvance(Consumer<? super E> action) {
            if (action == null) {
                throw new NullPointerException();
            } else {
                int hi = this.getFence();
                int i = this.index;
                if (i < hi) {
                    this.index = i + 1;
                    E e = ArrayList.this.elementData[i];
                    action.accept(e);
                    if (ArrayList.this.modCount != this.expectedModCount) {
                        throw new ConcurrentModificationException();
                    } else {
                        return true;
                    }
                } else {
                    return false;
                }
            }
        }

        public void forEachRemaining(Consumer<? super E> action) {
            if (action == null) {
                throw new NullPointerException();
            } else {
                Object[] a;
                if ((a = ArrayList.this.elementData) != null) {
                    int hi;
                    int mc;
                    if ((hi = this.fence) < 0) {
                        mc = ArrayList.this.modCount;
                        hi = ArrayList.this.size;
                    } else {
                        mc = this.expectedModCount;
                    }

                    int i;
                    if ((i = this.index) >= 0 && (this.index = hi) <= a.length) {
                        while(i < hi) {
                            E e = a[i];
                            action.accept(e);
                            ++i;
                        }

                        if (ArrayList.this.modCount == mc) {
                            return;
                        }
                    }
                }

                throw new ConcurrentModificationException();
            }
        }

        public long estimateSize() {
            return (long)(this.getFence() - this.index);
        }

        public int characteristics() {
            return 16464;
        }
    }

    private static class SubList<E> extends AbstractList<E> implements RandomAccess {
        private final ArrayList<E> root;
        private final ArrayList.SubList<E> parent;
        private final int offset;
        private int size;

        public SubList(ArrayList<E> root, int fromIndex, int toIndex) {
            this.root = root;
            this.parent = null;
            this.offset = fromIndex;
            this.size = toIndex - fromIndex;
            this.modCount = root.modCount;
        }

        private SubList(ArrayList.SubList<E> parent, int fromIndex, int toIndex) {
            this.root = parent.root;
            this.parent = parent;
            this.offset = parent.offset + fromIndex;
            this.size = toIndex - fromIndex;
            this.modCount = this.root.modCount;
        }

        public E set(int index, E element) {
            Objects.checkIndex(index, this.size);
            this.checkForComodification();
            E oldValue = this.root.elementData(this.offset + index);
            this.root.elementData[this.offset + index] = element;
            return oldValue;
        }

        public E get(int index) {
            Objects.checkIndex(index, this.size);
            this.checkForComodification();
            return this.root.elementData(this.offset + index);
        }

        public int size() {
            this.checkForComodification();
            return this.size;
        }

        public void add(int index, E element) {
            this.rangeCheckForAdd(index);
            this.checkForComodification();
            this.root.add(this.offset + index, element);
            this.updateSizeAndModCount(1);
        }

        public E remove(int index) {
            Objects.checkIndex(index, this.size);
            this.checkForComodification();
            E result = this.root.remove(this.offset + index);
            this.updateSizeAndModCount(-1);
            return result;
        }

        protected void removeRange(int fromIndex, int toIndex) {
            this.checkForComodification();
            this.root.removeRange(this.offset + fromIndex, this.offset + toIndex);
            this.updateSizeAndModCount(fromIndex - toIndex);
        }

        public boolean addAll(Collection<? extends E> c) {
            return this.addAll(this.size, c);
        }

        public boolean addAll(int index, Collection<? extends E> c) {
            this.rangeCheckForAdd(index);
            int cSize = c.size();
            if (cSize == 0) {
                return false;
            } else {
                this.checkForComodification();
                this.root.addAll(this.offset + index, c);
                this.updateSizeAndModCount(cSize);
                return true;
            }
        }

        public void replaceAll(UnaryOperator<E> operator) {
            this.root.replaceAllRange(operator, this.offset, this.offset + this.size);
        }

        public boolean removeAll(Collection<?> c) {
            return this.batchRemove(c, false);
        }

        public boolean retainAll(Collection<?> c) {
            return this.batchRemove(c, true);
        }

        private boolean batchRemove(Collection<?> c, boolean complement) {
            this.checkForComodification();
            int oldSize = this.root.size;
            boolean modified = this.root.batchRemove(c, complement, this.offset, this.offset + this.size);
            if (modified) {
                this.updateSizeAndModCount(this.root.size - oldSize);
            }

            return modified;
        }

        public boolean removeIf(Predicate<? super E> filter) {
            this.checkForComodification();
            int oldSize = this.root.size;
            boolean modified = this.root.removeIf(filter, this.offset, this.offset + this.size);
            if (modified) {
                this.updateSizeAndModCount(this.root.size - oldSize);
            }

            return modified;
        }

        public Object[] toArray() {
            this.checkForComodification();
            return Arrays.copyOfRange(this.root.elementData, this.offset, this.offset + this.size);
        }

        public <T> T[] toArray(T[] a) {
            this.checkForComodification();
            if (a.length < this.size) {
                return Arrays.copyOfRange(this.root.elementData, this.offset, this.offset + this.size, a.getClass());
            } else {
                System.arraycopy(this.root.elementData, this.offset, a, 0, this.size);
                if (a.length > this.size) {
                    a[this.size] = null;
                }

                return a;
            }
        }

        public boolean equals(Object o) {
            if (o == this) {
                return true;
            } else if (!(o instanceof List)) {
                return false;
            } else {
                boolean equal = this.root.equalsRange((List)o, this.offset, this.offset + this.size);
                this.checkForComodification();
                return equal;
            }
        }

        public int hashCode() {
            int hash = this.root.hashCodeRange(this.offset, this.offset + this.size);
            this.checkForComodification();
            return hash;
        }

        public int indexOf(Object o) {
            int index = this.root.indexOfRange(o, this.offset, this.offset + this.size);
            this.checkForComodification();
            return index >= 0 ? index - this.offset : -1;
        }

        public int lastIndexOf(Object o) {
            int index = this.root.lastIndexOfRange(o, this.offset, this.offset + this.size);
            this.checkForComodification();
            return index >= 0 ? index - this.offset : -1;
        }

        public boolean contains(Object o) {
            return this.indexOf(o) >= 0;
        }

        public Iterator<E> iterator() {
            return this.listIterator();
        }

        public ListIterator<E> listIterator(final int index) {
            this.checkForComodification();
            this.rangeCheckForAdd(index);
            return new ListIterator<E>() {
                int cursor = index;
                int lastRet = -1;
                int expectedModCount;

                {
                    this.expectedModCount = SubList.this.root.modCount;
                }

                public boolean hasNext() {
                    return this.cursor != SubList.this.size;
                }

                public E next() {
                    this.checkForComodification();
                    int i = this.cursor;
                    if (i >= SubList.this.size) {
                        throw new NoSuchElementException();
                    } else {
                        Object[] elementData = SubList.this.root.elementData;
                        if (SubList.this.offset + i >= elementData.length) {
                            throw new ConcurrentModificationException();
                        } else {
                            this.cursor = i + 1;
                            return elementData[SubList.this.offset + (this.lastRet = i)];
                        }
                    }
                }

                public boolean hasPrevious() {
                    return this.cursor != 0;
                }

                public E previous() {
                    this.checkForComodification();
                    int i = this.cursor - 1;
                    if (i < 0) {
                        throw new NoSuchElementException();
                    } else {
                        Object[] elementData = SubList.this.root.elementData;
                        if (SubList.this.offset + i >= elementData.length) {
                            throw new ConcurrentModificationException();
                        } else {
                            this.cursor = i;
                            return elementData[SubList.this.offset + (this.lastRet = i)];
                        }
                    }
                }

                public void forEachRemaining(Consumer<? super E> action) {
                    Objects.requireNonNull(action);
                    int size = SubList.this.size;
                    int i = this.cursor;
                    if (i < size) {
                        Object[] es = SubList.this.root.elementData;
                        if (SubList.this.offset + i >= es.length) {
                            throw new ConcurrentModificationException();
                        }

                        while(i < size && SubList.this.modCount == this.expectedModCount) {
                            action.accept(ArrayList.elementAt(es, SubList.this.offset + i));
                            ++i;
                        }

                        this.cursor = i;
                        this.lastRet = i - 1;
                        this.checkForComodification();
                    }

                }

                public int nextIndex() {
                    return this.cursor;
                }

                public int previousIndex() {
                    return this.cursor - 1;
                }

                public void remove() {
                    if (this.lastRet < 0) {
                        throw new IllegalStateException();
                    } else {
                        this.checkForComodification();

                        try {
                            SubList.this.remove(this.lastRet);
                            this.cursor = this.lastRet;
                            this.lastRet = -1;
                            this.expectedModCount = SubList.this.root.modCount;
                        } catch (IndexOutOfBoundsException var2) {
                            throw new ConcurrentModificationException();
                        }
                    }
                }

                public void set(E e) {
                    if (this.lastRet < 0) {
                        throw new IllegalStateException();
                    } else {
                        this.checkForComodification();

                        try {
                            SubList.this.root.set(SubList.this.offset + this.lastRet, e);
                        } catch (IndexOutOfBoundsException var3) {
                            throw new ConcurrentModificationException();
                        }
                    }
                }

                public void add(E e) {
                    this.checkForComodification();

                    try {
                        int i = this.cursor;
                        SubList.this.add(i, e);
                        this.cursor = i + 1;
                        this.lastRet = -1;
                        this.expectedModCount = SubList.this.root.modCount;
                    } catch (IndexOutOfBoundsException var3) {
                        throw new ConcurrentModificationException();
                    }
                }

                final void checkForComodification() {
                    if (SubList.this.root.modCount != this.expectedModCount) {
                        throw new ConcurrentModificationException();
                    }
                }
            };
        }

        public List<E> subList(int fromIndex, int toIndex) {
            subListRangeCheck(fromIndex, toIndex, this.size);
            return new ArrayList.SubList(this, fromIndex, toIndex);
        }

        private void rangeCheckForAdd(int index) {
            if (index < 0 || index > this.size) {
                throw new IndexOutOfBoundsException(this.outOfBoundsMsg(index));
            }
        }

        private String outOfBoundsMsg(int index) {
            return "Index: " + index + ", Size: " + this.size;
        }

        private void checkForComodification() {
            if (this.root.modCount != this.modCount) {
                throw new ConcurrentModificationException();
            }
        }

        private void updateSizeAndModCount(int sizeChange) {
            ArrayList.SubList slist = this;

            do {
                slist.size += sizeChange;
                slist.modCount = this.root.modCount;
                slist = slist.parent;
            } while(slist != null);

        }

        public Spliterator<E> spliterator() {
            this.checkForComodification();
            return new Spliterator<E>() {
                private int index;
                private int fence;
                private int expectedModCount;

                {
                    this.index = SubList.this.offset;
                    this.fence = -1;
                }

                private int getFence() {
                    int hi;
                    if ((hi = this.fence) < 0) {
                        this.expectedModCount = SubList.this.modCount;
                        hi = this.fence = SubList.this.offset + SubList.this.size;
                    }

                    return hi;
                }

                public ArrayList<E>.ArrayListSpliterator trySplit() {
                    int hi = this.getFence();
                    int lo = this.index;
                    int mid = lo + hi >>> 1;
                    ArrayList.ArrayListSpliterator var10000;
                    if (lo >= mid) {
                        var10000 = null;
                    } else {
                        ArrayList var10002 = SubList.this.root;
                        Objects.requireNonNull(var10002);
                        var10000 = var10002.new ArrayListSpliterator(lo, this.index = mid, this.expectedModCount);
                    }

                    return var10000;
                }

                public boolean tryAdvance(Consumer<? super E> action) {
                    Objects.requireNonNull(action);
                    int hi = this.getFence();
                    int i = this.index;
                    if (i < hi) {
                        this.index = i + 1;
                        E e = SubList.this.root.elementData[i];
                        action.accept(e);
                        if (SubList.this.root.modCount != this.expectedModCount) {
                            throw new ConcurrentModificationException();
                        } else {
                            return true;
                        }
                    } else {
                        return false;
                    }
                }

                public void forEachRemaining(Consumer<? super E> action) {
                    Objects.requireNonNull(action);
                    ArrayList<E> lst = SubList.this.root;
                    Object[] a;
                    if ((a = lst.elementData) != null) {
                        int hi;
                        int mc;
                        if ((hi = this.fence) < 0) {
                            mc = SubList.this.modCount;
                            hi = SubList.this.offset + SubList.this.size;
                        } else {
                            mc = this.expectedModCount;
                        }

                        int i;
                        if ((i = this.index) >= 0 && (this.index = hi) <= a.length) {
                            while(i < hi) {
                                E e = a[i];
                                action.accept(e);
                                ++i;
                            }

                            if (lst.modCount == mc) {
                                return;
                            }
                        }
                    }

                    throw new ConcurrentModificationException();
                }

                public long estimateSize() {
                    return (long)(this.getFence() - this.index);
                }

                public int characteristics() {
                    return 16464;
                }
            };
        }
    }

    private class ListItr extends ArrayList<E>.Itr implements ListIterator<E> {
        ListItr(int index) {
            super();
            this.cursor = index;
        }

        public boolean hasPrevious() {
            return this.cursor != 0;
        }

        public int nextIndex() {
            return this.cursor;
        }

        public int previousIndex() {
            return this.cursor - 1;
        }

        public E previous() {
            this.checkForComodification();
            int i = this.cursor - 1;
            if (i < 0) {
                throw new NoSuchElementException();
            } else {
                Object[] elementData = ArrayList.this.elementData;
                if (i >= elementData.length) {
                    throw new ConcurrentModificationException();
                } else {
                    this.cursor = i;
                    return elementData[this.lastRet = i];
                }
            }
        }

        public void set(E e) {
            if (this.lastRet < 0) {
                throw new IllegalStateException();
            } else {
                this.checkForComodification();

                try {
                    ArrayList.this.set(this.lastRet, e);
                } catch (IndexOutOfBoundsException var3) {
                    throw new ConcurrentModificationException();
                }
            }
        }

        public void add(E e) {
            this.checkForComodification();

            try {
                int i = this.cursor;
                ArrayList.this.add(i, e);
                this.cursor = i + 1;
                this.lastRet = -1;
                this.expectedModCount = ArrayList.this.modCount;
            } catch (IndexOutOfBoundsException var3) {
                throw new ConcurrentModificationException();
            }
        }
    }

    private class Itr implements Iterator<E> {
        int cursor;
        int lastRet = -1;
        int expectedModCount;

        Itr() {
            this.expectedModCount = ArrayList.this.modCount;
        }

        public boolean hasNext() {
            return this.cursor != ArrayList.this.size;
        }

        public E next() {
            this.checkForComodification();
            int i = this.cursor;
            if (i >= ArrayList.this.size) {
                throw new NoSuchElementException();
            } else {
                Object[] elementData = ArrayList.this.elementData;
                if (i >= elementData.length) {
                    throw new ConcurrentModificationException();
                } else {
                    this.cursor = i + 1;
                    return elementData[this.lastRet = i];
                }
            }
        }

        public void remove() {
            if (this.lastRet < 0) {
                throw new IllegalStateException();
            } else {
                this.checkForComodification();

                try {
                    ArrayList.this.remove(this.lastRet);
                    this.cursor = this.lastRet;
                    this.lastRet = -1;
                    this.expectedModCount = ArrayList.this.modCount;
                } catch (IndexOutOfBoundsException var2) {
                    throw new ConcurrentModificationException();
                }
            }
        }

        public void forEachRemaining(Consumer<? super E> action) {
            Objects.requireNonNull(action);
            int size = ArrayList.this.size;
            int i = this.cursor;
            if (i < size) {
                Object[] es = ArrayList.this.elementData;
                if (i >= es.length) {
                    throw new ConcurrentModificationException();
                }

                while(i < size && ArrayList.this.modCount == this.expectedModCount) {
                    action.accept(ArrayList.elementAt(es, i));
                    ++i;
                }

                this.cursor = i;
                this.lastRet = i - 1;
                this.checkForComodification();
            }

        }

        final void checkForComodification() {
            if (ArrayList.this.modCount != this.expectedModCount) {
                throw new ConcurrentModificationException();
            }
        }
    }
}
```