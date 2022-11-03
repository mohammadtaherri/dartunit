
## dartunit

A dart library to write unit tests based on XUnit Patterns.

test\stack_test.dart

```dart 
// ignore_for_file: non_constant_identifier_names
library stack_test;

import 'package:dartunit/dartunit.dart';
import 'package:stack/stack.dart';

void main() {
  runTestsByLibraryName('stack_test');
}

mixin ComposedExpect{

  Stack get stack;

  void expectStackIsEmpty(){
    expect(stack.isEmpty, isTrue);
    expect(stack.size, isZero);
  }

  void expectStackSizeIsOne(){
    expect(stack.size, equals(1));
    expect(stack.isEmpty, isFalse);
  }

  void expectStackSizeIsTwo(){
    expect(stack.size, equals(2));
    expect(stack.isEmpty, isFalse);
  }
}



@TestCase()
@Root()
class StackTest with ComposedExpect{
  @override
  late final Stack stack;
}

@TestCase()
class GivenNewlyCreatedStackWith3Capacity extends StackTest{

  @SetUp()
  void createStackWith3Capacity() {
    stack = Stack<int>(capacity: 3);
  }

  @Test()
  void shouldBeEmpty(){
    expectStackIsEmpty();
  }

  @Test()
  void push_ShouldIncrementSizeByOne(){
    stack.push(10);
    expectStackSizeIsOne();

    stack.push(10);
    expectStackSizeIsTwo();
  }

  @Test()
  void push_WhenPastCapacity_ShouldThrowStackOverFlow(){
    void act(){
      stack.push(10);
      stack.push(10);
      stack.push(10);
      stack.push(10);
    }

    expect(act, throwsA(isA<StackOverflowException>()));
  }

  @Test()
  void pop_ShouldThrowStackUnderFLow(){
    void act(){
      stack.pop();
    }

    expect(act, throwsA(isA<StackUnderflowException>()));
  }

  @Test()
  void pop_GivenPushingTwoItems_ShouldDecrementSizeByOne(){
    stack.push(10);
    stack.push(10);

    stack.pop();
    expectStackSizeIsOne();

    stack.pop();
    expectStackIsEmpty();
  }

  @Test()
  void peek_ShouldThrowStackEmpty(){
    void act(){
      stack.peek();
    }

    expect(act, throwsA(isA<StackEmptyException>()));
  }

  @Test()
  void push_pop_WhenXIsPushed_XShouldBePopped(){
    final x = 10;
    stack.push(x);
    expect(stack.pop(), equals(x));
  }

  @Test()
  void push_pop_WhenXAndYArePushed_YAndXShouldBePopped(){
    final x = 10;
    final y = 20;
    stack.push(x);
    stack.push(y);
    expect(stack.pop(), equals(y));
    expect(stack.pop(), equals(x));
  }

  @Test()
  void peek_GivenPushingXAndY_ShouldReturnY(){
    final x = 10;
    final y = 20;
    stack.push(x);
    stack.push(y);
    expect(stack.peek(), equals(y));
  }
}

@TestCase()
class NegativeCapacityStack extends StackTest{

  @Test()
  void whenStackWithNegativeCapacityIsCreated_IllegalCapacityShouldBeThrown(){
    void act(){
      Stack<int>(capacity: -1);
    }

    expect(act, throwsA(isA<IllegalCapacityException>()));
  }
}

@TestCase()
class GivenZeroCapacityStack extends StackTest{

  @SetUp()
  void createStackWithZeroCapacity() {
    stack = Stack<int>(capacity: 0);
  }

  @Test()
  void shouldBeEmpty(){
    expectStackIsEmpty();
  }

  @Test()
  void push_ShouldThrowStackOverFlow(){
    void act(){
      stack.push(10);
    }

    expect(act, throwsA(isA<StackOverflowException>()));
  }

  @Test()
  void pop_ShouldThrowStackUnderFLow(){
    void act(){
      stack.pop();
    }

    expect(act, throwsA(isA<StackUnderflowException>()));
  }

  @Test()
  void peek_ShouldThrowStackEmpty(){
    void act(){
      stack.peek();
    }

    expect(act, throwsA(isA<StackEmptyException>()));
  }
}

```

lib\stack.dart

```dart
class Stack<T>{

  factory Stack({int capacity = 5}){
    if(capacity < 0)
      throw IllegalCapacityException();

    if(capacity == 0)
      return _ZeroCapacityStack<T>();

    return Stack<T>._(capacity: capacity);
  }

  Stack._({int capacity = 5}) : _items = List.filled(capacity, null);

  final List<T?> _items;

  bool get isEmpty => _size == 0;
  int get size => _size;
  int _size = 0;

  void push(T item) {
    if(_isFull)
      throw StackOverflowException();

    _items[_size++] = item;
  }

  bool get _isFull => _size == _items.length;

  T pop() {
    if(isEmpty)
      throw StackUnderflowException();

    return _items[--_size]!;
  }

  T peek() {
    if(isEmpty)
      throw StackEmptyException();

    return _items[size-1]!;
  }
}

class _ZeroCapacityStack<T> extends Stack<T>{
  _ZeroCapacityStack() : super._(capacity: 0);

  @override
  bool get isEmpty => true;

  @override
  int get size => 0;

  @override
  void push(T item) {
    throw StackOverflowException();
  }

  @override
  T pop() {
    throw StackUnderflowException();
  }

  @override
  T peek() {
    throw StackEmptyException();
  }
}

class StackOverflowException implements Exception{}
class StackUnderflowException implements Exception{}
class StackEmptyException implements Exception{}
class IllegalCapacityException implements Exception{}
```

Then run tests with following command:

```dart test test/your_file.dart  --reporter=expanded```


![photo_2022-11-04_01-43-19](https://user-images.githubusercontent.com/44123678/199844572-c187ccdf-4b5a-4f11-95f8-29ecbd0c5a11.jpg)



