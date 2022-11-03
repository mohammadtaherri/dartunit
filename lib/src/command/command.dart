library command;

import 'package:test/test.dart';

import '../test_config.dart';

part './test_case_object.dart';
part './test_suite_object.dart';

typedef AsyncCallback = Future<void> Function();

abstract class TestCommand {
  void call();
}
