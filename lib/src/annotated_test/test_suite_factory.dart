
import 'dart:mirrors';

import 'test_case_mirror.dart';
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
        CompositeTestCaseTestSuiteFactory(
          rootTestCase: root,
          subTestCases: libMirror.subTestCases,
        ).createSuite(),
      );

    return TestSuiteObject(
      config: TestConfig(description: ''),
      testCaseObjects: suites,
    );
  }
}


class CompositeTestCaseTestSuiteFactory implements TestSuiteFactory{

  CompositeTestCaseTestSuiteFactory({
    required this.rootTestCase,
    this.subTestCases = const [],
  });

  final ClassMirror rootTestCase;
  final List<ClassMirror> subTestCases;

  @override
  TestSuiteObject createSuite() {
    return _createCompositeTestCase(rootTestCase).createSuite();
  }

  TestCaseMirror _createCompositeTestCase(ClassMirror selfMirror) {
    TestCaseMirror composite = TestCaseMirror(selfMirror);

    for (final sub in subTestCases.of(selfMirror))
      composite.addChild(_createCompositeTestCase(sub));

    return composite;
  }
}