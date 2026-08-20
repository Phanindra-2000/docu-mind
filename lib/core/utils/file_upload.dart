import 'dart:typed_data';

/// Cross-platform file abstraction for uploads.
///
/// On web, [bytes] is populated (no file system access).
/// On native (mobile/desktop), [path] is populated.
class FileUpload {
  final String name;
  final String? path;
  final Uint8List? bytes;

  const FileUpload({
    required this.name,
    this.path,
    this.bytes,
  });

  /// Whether this file was loaded from bytes (web).
  bool get isBytes => bytes != null;

  /// Whether this file was loaded from a file path (native).
  bool get isPath => path != null;
}
