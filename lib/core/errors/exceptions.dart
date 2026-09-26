
class LocalDataSourceException implements Exception {
  const LocalDataSourceException({required this.message});

  final String message;

  @override
  String toString() => 'LocalDataSourceException: $message';
}
