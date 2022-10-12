part of clean_test;

abstract class TestGroup {
  TestGroup({
    required this.groupDescription,
    this.groupConfig,
  }) {
    _testContainer = TestContainer();
    registerTests(_testContainer);
  }

  TestGroup? parent;
  final String groupDescription;
  final TestConfig? groupConfig;
  late final TestContainer _testContainer;

  void call() => run();

  @protected
  void run() {
    test.group(
      groupDescription,
      () {
        test.setUp(() => setUp());

        runTests();
        runGroup();

        test.tearDown(() => tearDown());
      },
      testOn: groupConfig?.testOn,
      skip: groupConfig?.skip,
      onPlatform: groupConfig?.onPlatform,
      retry: groupConfig?.retry,
    );
  }

  @protected
  void setUp() {}

  @protected
  @nonVirtual
  void runTests() {
    _testContainer.forEach((desc) {
      _testContainer[desc]?.call();
    });
  }

  @protected
  void runGroup() {}

  @protected
  void tearDown() {}

  @protected
  void registerTests(TestContainer container) {}

  @protected
  @mustCallSuper
  T? findVariableByType<T>() {
    return parent?.findVariableByType<T>();
  }

  @protected
  @mustCallSuper
  T? findVariableByKey<T>(String key) {
    return parent?.findVariableByKey<T>(key);
  }
}
