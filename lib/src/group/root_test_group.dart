part of clean_test;

abstract class RootTestGroup extends TestGroup {
  RootTestGroup({this.groups = const []}) : super(groupDescription: '');

  final List<TestGroup> groups;

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

  @override
  @protected
  void runGroup() {
    for (TestGroup g in groups) {
      g.parent = this;
      g.call();
    }
  }

  @protected
  void tearDownAll() {}
}
