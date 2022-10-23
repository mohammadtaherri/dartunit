part of test_group;

abstract class BranchTestGroup extends TestGroup {
  BranchTestGroup({
    super.groupDescription,
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
