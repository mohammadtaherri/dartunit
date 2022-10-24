
import 'test_suite_factory.dart';

void runTests({required String libraryName}) {
  TestSuiteFactoryForLibrary(libraryName: libraryName).createSuite().call();
}
