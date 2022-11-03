part of command;

class TestCaseObject extends TestCommand {
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
    dynamic body() async {
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
