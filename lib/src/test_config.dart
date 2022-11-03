
class TestConfig{
  const TestConfig({
    required this.description,
    this.skip,
    this.testOn,
    this.onPlatform,
    this.retry,
  });

  final String description;
  final dynamic skip;
  final String? testOn;
  final Map<String, dynamic>? onPlatform;
  final int? retry;

  @override
  String toString() => '''TestConfig (
      description: $description, 
      skip: $skip, 
      testOn: $testOn, 
      onPlatform: $onPlatform, 
      retry: $retry
    )''';
}