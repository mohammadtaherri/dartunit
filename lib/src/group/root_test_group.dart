part of clean_test;

abstract class RootTestGroup extends BranchTestGroup {
  RootTestGroup({List<TestGroup> groups = const []})
      : super(
          groups: groups,
          groupDescription: '',
        );

  @override
  @protected
  void run() {
    test.setUpAll(() => setUpAll());
    test.setUp(() => setUp());

    runTests();
    runGroup();

    test.tearDown(() => tearDown());
    test.tearDownAll(() => tearDownAll());
  }

  @protected
  void setUpAll() {}

  @protected
  void tearDownAll() {}
}
