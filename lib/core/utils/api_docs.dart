// ignore_for_file: avoid_print

/// Prints all RAG Chatbot API calls with full structure to the console.
///
/// Call [printApiDocs] from main.dart or anywhere to see the complete API map.
void printApiDocs() {
  final divider = '═' * 80;

  print('');
  print(divider);
  print('  📚  DocuMind API — Full Reference');
  print('  Base URL: https://bbbw0050-8000.inc1.devtunnels.ms');
  print(divider);
  print('');

  // ── 1. GET / ──────────────────────────────────────────────────
  _printEndpoint(
    method: 'GET',
    path: '/',
    title: 'Root',
    description: 'Returns basic API info / welcome message.',
    requestHeaders: {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
    },
    requestBody: null,
    responseExample: '''
{
  "message": "RAG Chatbot API",
  "version": "1.0.0"
}''',
    statusCodes: [200],
  );

  // ── 2. GET /health ────────────────────────────────────────────
  _printEndpoint(
    method: 'GET',
    path: '/health',
    title: 'Health Check',
    description: 'Checks if the API server and its dependencies are healthy.',
    requestHeaders: {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
    },
    requestBody: null,
    responseExample: '''
{
  "status": "healthy",
  "version": "1.0.0"
}''',
    statusCodes: [200],
  );

  // ── 3. POST /ingest ───────────────────────────────────────────
  _printEndpoint(
    method: 'POST',
    path: '/ingest',
    title: 'Ingest PDF',
    description: 'Uploads a PDF file for processing and ingestion into the vector store.',
    requestHeaders: {
      'Content-Type': 'multipart/form-data',
    },
    requestBody: '''
{
  "file": <binary PDF file>   // multipart/form-data field named "file"
}''',
    responseExample: '''
{
  "success": true,
  "message": "PDF ingested successfully",
  "filename": "document.pdf"
}''',
    statusCodes: [200, 400, 500],
  );

  // ── 4. GET /documents ─────────────────────────────────────────
  _printEndpoint(
    method: 'GET',
    path: '/documents',
    title: 'List Documents',
    description: 'Returns a list of all ingested document filenames.',
    requestHeaders: {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
    },
    requestBody: null,
    responseExample: '''
[
  "document1.pdf",
  "document2.pdf",
  "report.pdf"
]''',
    statusCodes: [200, 500],
  );

  // ── 5. DELETE /documents/{filename} ────────────────────────────
  _printEndpoint(
    method: 'DELETE',
    path: '/documents/{filename}',
    title: 'Delete Document',
    description: 'Deletes an ingested document by its filename.',
    requestHeaders: {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
    },
    requestBody: null,
    pathParams: {'filename': 'Name of the file to delete (e.g. "report.pdf")'},
    responseExample: '''
{
  "message": "Document 'report.pdf' deleted successfully"
}''',
    statusCodes: [200, 404, 500],
  );

  // ── 6. POST /chat ─────────────────────────────────────────────
  _printEndpoint(
    method: 'POST',
    path: '/chat',
    title: 'Chat',
    description: 'Sends a query to the RAG chatbot and returns an AI-generated answer with sources.',
    requestHeaders: {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
    },
    requestBody: '''
{
  "query": "What is the main topic of the document?",   // required
  "filename": "report.pdf"                               // optional — scope to specific doc
}''',
    responseExample: '''
{
  "answer": "The main topic of the document is ...",
  "sources": [
    "report.pdf",
    "page 3"
  ]
}''',
    statusCodes: [200, 400, 500],
  );

  print(divider);
  print('  End of API Reference');
  print(divider);
  print('');
}

/// Helper to print a single endpoint block.
void _printEndpoint({
  required String method,
  required String path,
  required String title,
  required String description,
  required Map<String, String> requestHeaders,
  required String? requestBody,
  required String responseExample,
  required List<int> statusCodes,
  Map<String, String>? pathParams,
}) {
  final thin = '─' * 80;

  // Method badge
  final methodColor = switch (method) {
    'GET'    => '🟢',
    'POST'   => '🟡',
    'PUT'    => '🔵',
    'DELETE' => '🔴',
    _        => '⚪',
  };

  print(thin);
  print('  $methodColor  $method  $path');
  print('      $title');
  print(thin);
  print('');
  print('  📝 Description:');
  print('      $description');
  print('');

  // Path params
  if (pathParams != null && pathParams.isNotEmpty) {
    print('  🔗 Path Parameters:');
    for (final entry in pathParams.entries) {
      print('      • ${entry.key}  →  ${entry.value}');
    }
    print('');
  }

  // Headers
  print('  📋 Request Headers:');
  for (final entry in requestHeaders.entries) {
    print('      ${entry.key}: ${entry.value}');
  }
  print('');

  // Body
  if (requestBody != null) {
    print('  📦 Request Body:');
    for (final line in requestBody.split('\n')) {
      print('      $line');
    }
  } else {
    print('  📦 Request Body: (none)');
  }
  print('');

  // Response
  print('  ✅ Response (200):');
  for (final line in responseExample.split('\n')) {
    print('      $line');
  }
  print('');

  // Status codes
  print('  📊 Status Codes:  ${statusCodes.join(', ')}');
  print('');
}

/// Print a compact summary table of all endpoints.
void printApiSummary() {
  print('');
  print('═' * 80);
  print('  📋  API Summary');
  print('═' * 80);
  print('');
  print('  ${'Method'.padRight(8)} ${'Endpoint'.padRight(25)} ${'Description'.padRight(30)}');
  print('  ${'─' * 8} ${'─' * 25} ${'─' * 30}');
  print('  ${'GET'.padRight(8)} ${'/'.padRight(25)} ${'Root'.padRight(30)}');
  print('  ${'GET'.padRight(8)} ${'/health'.padRight(25)} ${'Health Check'.padRight(30)}');
  print('  ${'POST'.padRight(8)} ${'/ingest'.padRight(25)} ${'Ingest PDF'.padRight(30)}');
  print('  ${'GET'.padRight(8)} ${'/documents'.padRight(25)} ${'List Documents'.padRight(30)}');
  print('  ${'DELETE'.padRight(8)} ${'/documents/{filename}'.padRight(25)} ${'Delete Document'.padRight(30)}');
  print('  ${'POST'.padRight(8)} ${'/chat'.padRight(25)} ${'Chat'.padRight(30)}');
  print('');
  print('═' * 80);
  print('');
}
