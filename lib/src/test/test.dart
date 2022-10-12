part of clean_test;

typedef TestFunction = dynamic Function();
typedef VoidCallback = void Function();

class TestContainer {
  final Map<String, Test> _descToTest = <String, Test>{};

  void operator []=(String desc, Test test) {
    _descToTest.putIfAbsent(desc, () => test);
  }

  VoidCallback? operator [](String desc) {
    Test? t = _descToTest[desc];

    if (t == null) 
      return null;

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

  void forEach(void Function(String desc) action) {
    _descToTest.forEach((key, value) => action(key));
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
