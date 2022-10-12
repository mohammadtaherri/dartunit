import 'package:clean_test/src/group/test_group.dart';
import 'package:meta/meta.dart';

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