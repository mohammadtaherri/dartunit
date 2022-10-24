
import 'dart:mirrors';

import 'test_case_mirror.dart';
import 'test_case_object.dart';
import 'extensions.dart';
import 'test_config.dart';

abstract class TestSuiteFactory{
  TestSuiteObject createSuite();
}

class LibraryTestSuiteFactory implements TestSuiteFactory {
  LibraryTestSuiteFactory({required String libraryName})
      : _libraryName = libraryName;

  final String _libraryName;

  @override
  TestSuiteObject createSuite() {
    MirrorSystem mirrorSystem = currentMirrorSystem();
    LibraryMirror libMirror = mirrorSystem.findLibrary(Symbol(_libraryName));
    final testCaseMirrorFactory = TestCaseMirrorFactory();
    final List<TestSuiteObject> suites = List.empty(growable: true);

    for (final root in libMirror.rootTestCases)
      suites.add(
        testCaseMirrorFactory
            .create(
              root,
              libMirror.subTestCases,
            )
            .createSuite(),
      );

    return TestSuiteObject(
      config: TestConfig(description: ''),
      testCaseObjects: suites,
    );
  }
}


