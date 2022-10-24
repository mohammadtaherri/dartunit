
import 'test_suite_factory.dart';

void runTests({required String libraryName}) {
  TestSuiteFactory factory = TestSuiteFactoryForLibrary(libraryName: libraryName);
  factory.createSuite().call();
}