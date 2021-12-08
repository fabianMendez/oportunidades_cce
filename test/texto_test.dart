import 'package:flutter_test/flutter_test.dart';
import 'package:oportunidades_cce/src/home/texto_repository.dart';

import 'test_utils.dart';

void main() {
  group('Texto', () {
    test('should render terms and conditions', () {
      final json = TestUtils.readJsonFixture('testText.json');
      final texto = Texto.fromJson(json);
      expect(
        texto,
        const Texto(
          codigo: 'testText',
          estado: 1,
          data: '<span>data 123</span>',
          id: 2,
        ),
      );
    });
  });
}
