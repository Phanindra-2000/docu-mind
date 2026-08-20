import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:docu_mind/core/network/api_client.dart';

/// Dio instance — singleton across the app.
final dioProvider = Provider<Dio>((ref) {
  return ApiClient.instance;
});
