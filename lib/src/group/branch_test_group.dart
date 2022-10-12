part of clean_test;

abstract class BranchTestGroup extends TestGroup {
  BranchTestGroup({
    required super.groupDescription,
    required this.groups,
    super.groupConfig,
  });

  final List<TestGroup> groups;

  @override
  @protected
  void runGroup() {
    for (TestGroup g in groups) {
      g.parent = this;
      g.call();
    }
  }
}