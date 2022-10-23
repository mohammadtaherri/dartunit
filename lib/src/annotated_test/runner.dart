
import 'dart:mirrors';
import './extensions.dart';
import './test_case.dart';


void runTestsInLibrary(String libraryName) {
  MirrorSystem mirrorSystem = currentMirrorSystem();
  LibraryMirror libMirror = mirrorSystem.findLibrary(Symbol(libraryName));

  final List<ClassMirror> rootTestCases = libMirror.rootTestCases;
  final List<TestCaseClass> testCaseClasses = List.empty(growable: true);
  final testCaseClassFactory = TestCaseClassFactory(libMirror.allSubTestCases);
  
  for (final root in rootTestCases) 
    testCaseClasses.add(testCaseClassFactory.createFor(root));
  
  for(final testCaseClass in testCaseClasses)
    testCaseClass.createSuiteTestCaseObject().call();
}