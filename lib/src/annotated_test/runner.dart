
import 'dart:mirrors';
import './extensions.dart';
import 'test_suite_factory.dart';


void runTestsInLibrary(String libraryName) {
  MirrorSystem mirrorSystem = currentMirrorSystem();
  LibraryMirror libMirror = mirrorSystem.findLibrary(Symbol(libraryName));

  TestSuiteFactory factory = TestSuiteFactory(
    description: libraryName,
    rootTestCases: libMirror.rootTestCases,
    allSubTestCases: libMirror.allSubTestCases,
  );

  factory.createSuite().call();
}