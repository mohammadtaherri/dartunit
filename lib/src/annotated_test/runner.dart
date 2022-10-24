
import './factory/facroty.dart';

void runTests({required String libraryName}) {
  TestSuiteFactoryForLibrary(libraryName: libraryName).createSuite().call();
}
