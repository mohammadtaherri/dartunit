
import 'dart:mirrors';
import 'package:clean_test/src/annotated_test/test_config.dart';

import './extensions.dart';
import './test_case_object.dart';

abstract class TestSuiteFactoryBase{
  TestSuiteObject createSuite();
}

class TestSuiteFactory{
  TestSuiteFactory({
    required this.description,
    required this.rootTestCases,
    required this.allSubTestCases,
  });

  final String description;
  final List<ClassMirror> rootTestCases;
  final List<ClassMirror> allSubTestCases;

  TestSuiteObject createSuite(){
    final List<TestCaseClass> testCaseClasses = List.empty(growable: true);
    final List<TestSuiteObject> suites = List.empty(growable: true);
    final testCaseClassFactory = TestCaseClassFactory(allSubTestCases);

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

class TestCaseClassFactory{

  TestCaseClassFactory(
    this.allSubTestCases,
  );

  final List<ClassMirror> allSubTestCases;

  TestCaseClass createFor(ClassMirror selfMirror) {
    TestCaseClass testCaseClass = TestCaseClass(selfMirror);

    for (final sub in allSubTestCases.of(selfMirror))
      testCaseClass.addSubClass(createFor(sub));

    return testCaseClass;
  }
}

class TestCaseClass implements TestSuiteFactoryBase{
  TestCaseClass(this.selfMirror)
      : subClasses = List.empty(growable: true),
        setUpMirror = selfMirror.setUp,
        tearDownMirror = selfMirror.tearDown;

  final ClassMirror selfMirror;
  late final MethodMirror? setUpMirror;
  late final MethodMirror? tearDownMirror;
  final List<TestCaseClass> subClasses;
  TestCaseClass? superClass;
  

  void addSubClass(TestCaseClass subClass){
    subClass.superClass = this;
    subClasses.add(subClass);
  }

  @override
  TestSuiteObject createSuite() {
    final List<TestCaseObjectBase> objects = List.empty(growable: true);

    for(final testMirror in selfMirror.tests)
      objects.add(_createTestCaseObject(testMirror));

    for(final subClass in subClasses)
      objects.add(subClass.createSuite());


    return TestSuiteObject(
      testCaseObjects: objects,
      config: selfMirror.extractTestConfigIfPossible()!,
    );
  }

  TestCaseObjectBase _createTestCaseObject(MethodMirror testMirror){
    late final InstanceMirror selfInstance;
    
    Future<void> onSetUp()async{
      selfInstance = selfMirror.newInstance(Symbol.empty, []);

      await _invokeSetUp(selfInstance);
    }

    Future<void> onTest()async{
      await selfInstance.delegate(Invocation.method(testMirror.simpleName, []));
    }

    Future<void> onTearDown()async{
      await _invokeTearDown(selfInstance);
    }
 
    return TestCaseObject(
      onSetUp: onSetUp,  
      onTest: onTest,
      onTearDown: onTearDown,
      config: testMirror.extractTestConfigIfPossible()!,
    );
      
  }

  Future<void> _invokeSetUp(InstanceMirror instanceMirror) async{

    await superClass?._invokeSetUp(instanceMirror);

    if(setUpMirror != null)
      await instanceMirror.delegate(Invocation.method(setUpMirror!.simpleName, []));
  }

  Future<void> _invokeTearDown(InstanceMirror instanceMirror) async{

    if(tearDownMirror != null)
      await instanceMirror.delegate(Invocation.method(tearDownMirror!.simpleName, []));
  
    await superClass?._invokeTearDown(instanceMirror);
  }
  
}

