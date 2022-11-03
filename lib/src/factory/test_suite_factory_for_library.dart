part of factory;

class TestSuiteFactoryForLibrary implements TestSuiteFactory {
  TestSuiteFactoryForLibrary({required LibraryMirror libraryMirror})
      : _libraryMirror = libraryMirror;

  final LibraryMirror _libraryMirror;

  @override
  TestSuiteObject createSuite() {
    final List<TestSuiteObject> suites = List.empty(growable: true);

    for (final root in _libraryMirror.rootTestCases)
      suites.add(
        TestSuiteFactoryForClass.create(
          root,
          _libraryMirror.subTestCases,
        ).createSuite(),
      );

    return TestSuiteObject(
      config: TestConfig(description: ''),
      testCaseObjects: suites,
    );
  }
}
