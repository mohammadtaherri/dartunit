library factory;

import 'dart:mirrors';

import '../command/command.dart';
import '../extensions.dart';
import '../test_config.dart';

part './test_suite_factory_for_library.dart';
part './test_suite_factory_for_class.dart';

abstract class TestSuiteFactory {
  TestSuiteObject createSuite();
}
