part of factory;

class TestSuiteFactoryForLibrary implements TestSuiteFactory {
  TestSuiteFactoryForLibrary({required String libraryName})
      : _libraryName = libraryName;

  final String _libraryName;

  @override
  TestSuiteObject createSuite() {
    MirrorSystem mirrorSystem = currentMirrorSystem();
    LibraryMirror libMirror = mirrorSystem.findLibrary(Symbol(_libraryName));
    final List<TestSuiteObject> suites = List.empty(growable: true);

    for (final root in libMirror.rootTestCases)
      suites.add(
        TestSuiteFactoryForClass.create(
          root,
          libMirror.subTestCases,
        ).createSuite(),
      );

    return TestSuiteObject(
      config: TestConfig(description: ''),
      testCaseObjects: suites,
    );
  }
}
