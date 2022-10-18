part of clean_test;

typedef TestFunction = dynamic Function();
typedef VoidCallback = void Function();

class TestContainer {
  final List<String> _descs = List.empty(growable: true);
  final List<Test> _tests = List.empty(growable: true);

  void operator []=(String desc, Test test) {
    _descs.add(desc);
    _tests.add(test);
  }

  VoidCallback? operator [](String desc) {
    Test? t = _tests[_descs.indexOf(desc)];

    return () {
      TestFunction func = t.body;
      TestConfig? config = t.config;

      test.test(
        desc,
        func,
        testOn: config?.testOn,
        skip: config?.skip,
        onPlatform: config?.onPlatform,
        retry: config?.retry,
      );
    };
  }

  void add(Test test){
    this[_extractFunctionName(test.body)] = test;
  }

  void addAll(List<Test> tests){
    for(var test in tests)
      add(test);
  }

  void forEach(void Function(String desc) action) {
    for(String desc in _descs)
      action(desc);
  }

  String _extractFunctionName(Function function) {
  String functionToString = function.toString();
  return functionToString.substring(
    functionToString.indexOf('\'') + 1,
    functionToString.lastIndexOf('\''),
  );
}
}

class Test {
  final TestFunction body;
  final TestConfig? config;

  const Test(this.body, {this.config});
}

class TestConfig {
  final String? testOn;
  final bool? skip;
  final Map<String, dynamic>? onPlatform;
  final int? retry;

  const TestConfig({
    this.testOn,
    this.skip,
    this.onPlatform,
    this.retry,
  });
}
