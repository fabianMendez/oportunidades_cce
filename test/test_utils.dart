import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

class TestUtils {
  static const JsonDecoder _jsonDecoder = JsonDecoder();

  static Map<String, dynamic> readJsonFixture(String path) {
    final String utf8String = utf8.decode(readFixture(path));
    return _jsonDecoder.convert(utf8String);
  }

  static Uint8List readFixture(String path) {
    final File file = File('test/fixtures/$path');
    if (!file.existsSync()) {
      throw Exception('Fixture not found at: ${file.absolute.path}');
    }
    return file.readAsBytesSync();
  }
}
