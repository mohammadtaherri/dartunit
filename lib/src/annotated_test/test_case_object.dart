
import 'package:test/test.dart';
import './test_config.dart';

typedef Callback = Future<void> Function();
typedef SetUpCallback = Callback;
typedef TearDownCallback = Callback;
typedef TestCallback = Callback;

abstract class TestCaseObject{
  void call();
}

class SingleTestCaseObject extends TestCaseObject {
  SingleTestCaseObject({
    required this.onSetUp,
    required this.onTest,
    required this.config,
    this.onTearDown,
  });

  final SetUpCallback onSetUp;
  final TestCallback onTest;
  final TearDownCallback? onTearDown;
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

class SuiteTestCaseObject extends TestCaseObject {
  SuiteTestCaseObject({
    required this.config,
    this.testCaseObjects = const [],
  });

  final List<TestCaseObject> testCaseObjects;
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