
import 'test_suite_factory.dart';

void runTests({required String libraryName}) {
  TestSuiteFactory factory = LibraryTestSuiteFactory(libraryName: libraryName);
  factory.createSuite().call();
}