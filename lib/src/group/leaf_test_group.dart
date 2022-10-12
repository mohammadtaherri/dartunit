

import 'package:clean_test/src/group/test_group.dart';

abstract class LeafTestGroup extends TestGroup {
  LeafTestGroup({
    required super.groupDescription,
    super.groupConfig,
  });
}