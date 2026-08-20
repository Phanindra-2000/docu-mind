/// Centralized API configuration.
class ApiConfig {
  ApiConfig._();

  /// Base URL of the RAG Chatbot API.
  /// Change this to your actual server URL.
  static const String baseUrl = 'https://bbbw0050-8000.inc1.devtunnels.ms';

  /// API endpoints.
  static const String health = '/health';
  static const String ingest = '/ingest';
  static const String documents = '/documents';
  static const String chat = '/chat';
}
