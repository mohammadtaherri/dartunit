
import 'package:test/test.dart' as test;
import 'package:clean_test/src/group/test_group.dart';
import 'package:meta/meta.dart';

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
