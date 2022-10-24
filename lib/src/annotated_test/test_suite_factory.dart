
import 'dart:mirrors';

import 'test_case.dart';
import 'test_case_object.dart';
import 'extensions.dart';
import 'test_config.dart';

abstract class TestSuiteFactory{
  TestSuiteObject createSuite();
}

class LibraryTestSuiteFactory implements TestSuiteFactory{
  LibraryTestSuiteFactory({required this.libraryName});

  final String libraryName;
  
  @override
  TestSuiteObject createSuite() {
    MirrorSystem mirrorSystem = currentMirrorSystem();
    LibraryMirror libMirror = mirrorSystem.findLibrary(Symbol(libraryName));
    final List<TestSuiteObject> suites = List.empty(growable: true);

    for (final root in libMirror.rootTestCases)
      suites.add(
        ClassTestSuiteFactory(
          rootTestCase: root,
          allSubTestCases: libMirror.allSubTestCases,
        ).createSuite(),
      );

    return TestSuiteObject(
      config: TestConfig(description: libraryName),
      testCaseObjects: suites,
    );
  }
}


class ClassTestSuiteFactory implements TestSuiteFactory{

  ClassTestSuiteFactory({
    required this.rootTestCase,
    this.allSubTestCases = const [],
  });

  final ClassMirror rootTestCase;
  final List<ClassMirror> allSubTestCases;

  @override
  TestSuiteObject createSuite() {
    return _createCompositeTestCase(rootTestCase).createSuite();
  }

  CompositTestCase _createCompositeTestCase(ClassMirror selfMirror) {
    CompositTestCase composite = CompositTestCase(selfMirror);

    for (final sub in allSubTestCases.of(selfMirror))
      composite.addChild(_createCompositeTestCase(sub));

    return composite;
  }
}