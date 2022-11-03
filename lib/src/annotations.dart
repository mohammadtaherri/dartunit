class Root {
  const Root();
}

class TestCase {
  const TestCase({
    this.description,
    this.skip,
    this.testOn,
    this.onPlatform,
    this.retry,
  });

  final String? description;
  final dynamic skip;
  final String? testOn;
  final Map<String, dynamic>? onPlatform;
  final int? retry;
}

class Test {
  const Test({
    this.description,
    this.skip,
    this.testOn,
    this.onPlatform,
    this.retry,
  });

  final String? description;
  final dynamic skip;
  final String? testOn;
  final Map<String, dynamic>? onPlatform;
  final int? retry;
}

class SetUp {
  const SetUp();
}

class TearDown {
  const TearDown();
}

class SetUpAll {
  const SetUpAll();
}

class TearDownAll {
  const TearDownAll();
}
