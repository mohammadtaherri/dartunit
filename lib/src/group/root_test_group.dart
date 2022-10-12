part of clean_test;

abstract class RootTestGroup extends TestGroup {
  RootTestGroup({this.group}) : super(groupDescription: '');

  final TestGroup? group;

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
    group?.parent = this;
    group?.call();
  }

  @protected
  void tearDownAll() {}
}
