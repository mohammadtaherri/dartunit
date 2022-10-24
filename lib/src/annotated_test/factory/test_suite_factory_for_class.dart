part of factory;

class TestSuiteFactoryForClass implements TestSuiteFactory{

  factory TestSuiteFactoryForClass.create(
    ClassMirror selfTestCase,
    List<ClassMirror> allSubTestCases,
  ) {
    TestSuiteFactoryForClass factory = TestSuiteFactoryForClass._(selfTestCase);

    for (final sub in allSubTestCases.of(selfTestCase))
      factory.addChild(TestSuiteFactoryForClass.create(sub, allSubTestCases));

    return factory;
  }

  TestSuiteFactoryForClass._(ClassMirror selfMirror)
      : _selfMirror = selfMirror,
        _children = List.empty(growable: true),
        _setUpMirror = selfMirror.setUp,
        _tearDownMirror = selfMirror.tearDown,
        _setUpAllMirror = selfMirror.setUpAll,
        _tearDownAllMirror = selfMirror.tearDownAll;

  final ClassMirror _selfMirror;
  final MethodMirror? _setUpMirror;
  final MethodMirror? _tearDownMirror;
  final MethodMirror? _setUpAllMirror;
  final MethodMirror? _tearDownAllMirror;
  final List<TestSuiteFactoryForClass> _children;
  TestSuiteFactoryForClass? _parent;
  

  void addChild(TestSuiteFactoryForClass child){
    child._parent = this;
    _children.add(child);
  }

  @override
  TestSuiteObject createSuite() {
    Future<void> onSetUpAll() async {
      if (_setUpAllMirror != null)
        await _selfMirror
            .delegate(Invocation.method(_setUpAllMirror!.simpleName, []));
    }

    Future<void> onTearDownAll() async {
      if (_tearDownAllMirror != null)
        await _selfMirror
            .delegate(Invocation.method(_tearDownAllMirror!.simpleName, []));
    }

    final List<TestCommand> objects = List.empty(growable: true);

    for (final testMirror in _selfMirror.tests)
      objects.add(_createTestCaseObject(testMirror));

    for (final child in _children) objects.add(child.createSuite());

    return TestSuiteObject(
      testCaseObjects: objects,
      onSetUpAll: onSetUpAll,
      onTearDownAll: onTearDownAll,
      config: _selfMirror.extractTestConfigIfPossible()!,
    );
  }

  TestCaseObject _createTestCaseObject(MethodMirror testMirror){
    late final InstanceMirror selfInstance;
    
    Future<void> onSetUp() async{
      selfInstance = _selfMirror.newInstance(Symbol.empty, []);

      await _invokeSetUp(selfInstance);
    }

    Future<void> onTest() async{
      await selfInstance.delegate(Invocation.method(testMirror.simpleName, []));
    }

    Future<void> onTearDown() async{
      await _invokeTearDown(selfInstance);
    }
 
    return TestCaseObject(
      onSetUp: onSetUp,  
      onTest: onTest,
      onTearDown: onTearDown,
      config: testMirror.extractTestConfigIfPossible()!,
    );
  }

  Future<void> _invokeSetUp(InstanceMirror instanceMirror) async {
    await _parent?._invokeSetUp(instanceMirror);

    if (_setUpMirror != null)
      await instanceMirror
          .delegate(Invocation.method(_setUpMirror!.simpleName, []));
  }

  Future<void> _invokeTearDown(InstanceMirror instanceMirror) async {
    if (_tearDownMirror != null)
      await instanceMirror
          .delegate(Invocation.method(_tearDownMirror!.simpleName, []));

    await _parent?._invokeTearDown(instanceMirror);
  } 
}