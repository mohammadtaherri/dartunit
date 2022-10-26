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
    if(_config.description.isEmpty){
      for (final object in _testCaseObjects) 
        object.call();

      return;
    }
      
    dynamic body(){
      if(_onSetUpAll != null)
        setUpAll(() async{
          await _onSetUpAll?.call();
        });

      for (final object in _testCaseObjects) 
        object.call();

      if(_onTearDownAll != null)
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