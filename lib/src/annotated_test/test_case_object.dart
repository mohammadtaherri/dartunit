
import 'package:test/test.dart';

import 'test_config.dart';


typedef AsyncCallback = Future<void> Function();

abstract class TestCaseObjectBase{
  void call();
}

class TestCaseObject extends TestCaseObjectBase {
  TestCaseObject({
    required TestConfig config,
    required AsyncCallback onSetUp,
    required AsyncCallback onTest,
    AsyncCallback? onTearDown,
  })  : _config = config,
        _onSetUp = onSetUp,
        _onTest = onTest,
        _onTearDown = onTearDown;

  final TestConfig _config;
  final AsyncCallback _onSetUp;
  final AsyncCallback _onTest;
  final AsyncCallback? _onTearDown;
  
  @override
  void call() {
    dynamic body() async{
      await _onSetUp.call();
      await _onTest.call();
      await _onTearDown?.call();
    }

    test(
      _config.description,
      body,
      skip: _config.skip,
      retry: _config.retry,
      onPlatform: _config.onPlatform,
      testOn: _config.testOn,
    );
  }
}

class TestSuiteObject extends TestCaseObjectBase {
  TestSuiteObject({
    required TestConfig config,
    List<TestCaseObjectBase> testCaseObjects = const [],
    AsyncCallback? onSetUpAll,
    AsyncCallback? onTearDownAll,
  })  : _config = config,
        _testCaseObjects = testCaseObjects,
        _onSetUpAll = onSetUpAll,
        _onTearDownAll = onTearDownAll;

  final TestConfig _config;
  final List<TestCaseObjectBase> _testCaseObjects;
  final AsyncCallback? _onSetUpAll;
  final AsyncCallback? _onTearDownAll;
  
  @override
  void call() {
    dynamic body(){
      setUpAll(() async{
        await _onSetUpAll?.call();
      });

      for (final object in _testCaseObjects) 
        object.call();

      tearDownAll(() async{
        await _onTearDownAll?.call();
      });
    }

    group(
      _config.description,
      body,
      skip: _config.skip,
      retry: _config.retry,
      testOn: _config.testOn,
      onPlatform: _config.onPlatform,
    );
  }
}