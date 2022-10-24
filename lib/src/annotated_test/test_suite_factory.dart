import 'dart:mirrors';
import 'test_case.dart';
import 'test_case_object.dart';
import 'test_config.dart';

abstract class TestSuiteFactoryBase{
  TestSuiteObject createSuite();
}

class TestSuiteFactory implements TestSuiteFactoryBase{
  TestSuiteFactory({
    required this.description,
    required this.rootTestCases,
    required this.allSubTestCases,
  });

  final String description;
  final List<ClassMirror> rootTestCases;
  final List<ClassMirror> allSubTestCases;

  @override
  TestSuiteObject createSuite(){
    final List<CompositTestCase> testCaseClasses = List.empty(growable: true);
    final List<TestSuiteObject> suites = List.empty(growable: true);
    final testCaseClassFactory = CompositeTestCaseFactory(allSubTestCases);

    for (final root in rootTestCases) 
      testCaseClasses.add(testCaseClassFactory.createFor(root));

    for(final testCaseClass in testCaseClasses)
      suites.add(testCaseClass.createSuite());

    return TestSuiteObject(
      config: TestConfig(description: description),
      testCaseObjects: suites,
    );
  }
}