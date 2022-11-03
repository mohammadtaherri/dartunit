library annotated_test;

import 'package:test/test.dart';

export 'package:test/test.dart';
export './src/annotated_test/annotations.dart';
export './src/annotated_test/runner.dart';


void verify(bool actual){
  expect(actual, isTrue);
}