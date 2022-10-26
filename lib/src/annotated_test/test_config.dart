
class TestConfig{
  const TestConfig({
    required this.description,
    this.skip = false,
    this.testOn,
    this.onPlatform,
    this.retry,
  });

  final String description;
  final bool skip;
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