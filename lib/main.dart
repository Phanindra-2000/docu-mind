import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:docu_mind/core/app/app.dart';
import 'package:docu_mind/core/utils/api_docs.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  // Print all API calls with full structure to console
  printApiDocs();
  printApiSummary();

  runApp(const ProviderScope(child: App()));
}
