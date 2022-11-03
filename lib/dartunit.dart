library dartunit;

import 'package:test/test.dart';

export 'package:test/test.dart';
export 'src/annotations.dart';
export 'src/runner.dart';


void verify(bool actual){
  expect(actual, isTrue);
}