part of test_group;

abstract class RootTestGroup extends BranchTestGroup {
  RootTestGroup({List<TestGroup> groups = const []})
      : super(groups: groups);

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
