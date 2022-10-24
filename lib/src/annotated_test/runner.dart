
import 'test_suite_factory.dart';

void runTestsInLibrary(String libraryName) {
  TestSuiteFactory factory = LibraryTestSuiteFactory(libraryName: libraryName);
  factory.createSuite().call();
}