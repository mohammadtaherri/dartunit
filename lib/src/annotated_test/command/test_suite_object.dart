part of command;

class TestSuiteObject extends TestCommand {
  TestSuiteObject({
    required TestConfig config,
    List<TestCommand> testCaseObjects = const [],
    AsyncCallback? onSetUpAll,
    AsyncCallback? onTearDownAll,
  })  : _config = config,
        _testCaseObjects = testCaseObjects,
        _onSetUpAll = onSetUpAll,
        _onTearDownAll = onTearDownAll;

  final TestConfig _config;
  final List<TestCommand> _testCaseObjects;
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