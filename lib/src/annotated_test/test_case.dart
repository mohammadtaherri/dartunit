
import 'dart:mirrors';

import './extensions.dart';
import './test_case_object.dart';
import 'test_suite_factory.dart';

class CompositTestCase implements TestSuiteFactory{
  CompositTestCase(this.selfMirror)
      : children = List.empty(growable: true),
        setUpMirror = selfMirror.setUp,
        tearDownMirror = selfMirror.tearDown;

  final ClassMirror selfMirror;
  late final MethodMirror? setUpMirror;
  late final MethodMirror? tearDownMirror;
  final List<CompositTestCase> children;
  CompositTestCase? parent;
  

  void addChild(CompositTestCase child){
    child.parent = this;
    children.add(child);
  }

  @override
  TestSuiteObject createSuite() {
    final List<TestCaseObjectBase> objects = List.empty(growable: true);

    for(final testMirror in selfMirror.tests)
      objects.add(_createTestCaseObject(testMirror));

    for(final child in children)
      objects.add(child.createSuite());


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

    await parent?._invokeSetUp(instanceMirror);

    if(setUpMirror != null)
      await instanceMirror.delegate(Invocation.method(setUpMirror!.simpleName, []));
  }

  Future<void> _invokeTearDown(InstanceMirror instanceMirror) async{

    if(tearDownMirror != null)
      await instanceMirror.delegate(Invocation.method(tearDownMirror!.simpleName, []));
  
    await parent?._invokeTearDown(instanceMirror);
  } 
}

