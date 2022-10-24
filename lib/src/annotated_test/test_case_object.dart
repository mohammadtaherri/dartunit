
import 'package:test/test.dart';
import 'test_config.dart';

typedef AsyncCallback = Future<void> Function();
abstract class TestCaseObjectBase{
  void call();
}

class TestCaseObject extends TestCaseObjectBase {
  TestCaseObject({
    required this.onSetUp,
    required this.onTest,
    required this.config,
    this.onTearDown,
  });

  final AsyncCallback onSetUp;
  final AsyncCallback onTest;
  final AsyncCallback? onTearDown;
  final TestConfig config;

  @override
  void call() {
    dynamic body() async{
      await onSetUp.call();
      await onTest.call();
      await onTearDown?.call();
    }

    test(
      config.description,
      body,
      skip: config.skip,
      retry: config.retry,
      onPlatform: config.onPlatform,
      testOn: config.testOn,
    );
  }
}

class TestSuiteObject extends TestCaseObjectBase {
  TestSuiteObject({
    required this.config,
    this.testCaseObjects = const [],
  });

  final List<TestCaseObjectBase> testCaseObjects;
  final TestConfig config;

  @override
  void call() {
    dynamic body(){
      for (final object in testCaseObjects) 
        object.call();
    }

    group(
      config.description,
      body,
      skip: config.skip,
      retry: config.retry,
      testOn: config.testOn,
      onPlatform: config.onPlatform,
    );
  }
}