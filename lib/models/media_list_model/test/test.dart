import 'package:flutter/material.dart';

abstract class Base {
  void testA();
  void testB();
  void testC();
}

mixin MixinA implements Base {
  @override
  void testB() {
    return;
  }

  @override
  void testC() {
    return;
  }
}

mixin MixinB implements Base {
  @override
  void testA() {
    return;
  }

  @override
  void testC() {
    return;
  }
}

mixin MixinC implements Base {
  @override
  void testA() {
    return;
  }

  @override
  void testB() {
    return;
  }
}

class Model with MixinB, MixinA {

}

class TestWid<T extends Base> extends StatelessWidget {
  final T model;
  const TestWid({super.key, required this.model});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () => model.testA(),
      child: Text("qwer"),
    );
  }
}

class A extends StatelessWidget {
  const A({super.key});

  @override
  Widget build(BuildContext context) {
    final model = Model();

    return TestWid(
      model: model,
    );
  }
}

