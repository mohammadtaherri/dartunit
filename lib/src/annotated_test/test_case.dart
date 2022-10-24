
import 'dart:mirrors';
import './extensions.dart';
import './test_case_object.dart';

class TestCaseClass {
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

  TestCaseObjectBase createSuiteTestCaseObject(){

    final List<TestCaseObjectBase> objects = List.empty(growable: true);

    for(final testMirror in selfMirror.tests)
      objects.add(_createSingleTestCaseObject(testMirror));

    for(final subClass in subClasses)
      objects.add(subClass.createSuiteTestCaseObject());


    return TestSuiteObject(
      testCaseObjects: objects,
      config: selfMirror.extractTestConfigIfPossible()!,
    );
  }

  TestCaseObjectBase _createSingleTestCaseObject(MethodMirror testMirror){
    late final InstanceMirror selfInstance;
    
    Future<void> onSetUp()async{
      selfInstance = selfMirror.newInstance(Symbol.empty, []);

      await _invokeSetUp(selfInstance);
    }

    Future<void> onTest()async{
      await selfInstance.delegate(Invocation.method(testMirror.simpleName, []));
      // selfInstance.invoke(testMirror.simpleName, []);
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