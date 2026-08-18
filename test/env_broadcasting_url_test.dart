import 'package:car_care/core/config/env.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('Env.apiRootUrl', () {
    test('strips a trailing /api so broadcasting/auth does not inherit it', () {
      dotenv.loadFromString(envString: 'BASE_URL=https://api-carcarex.futxtech.com/api');

      expect(Env.apiRootUrl, 'https://api-carcarex.futxtech.com');
      expect(Env.baseUrl, 'https://api-carcarex.futxtech.com/api');
    });

    test('leaves a BASE_URL without an /api suffix untouched', () {
      dotenv.loadFromString(envString: 'BASE_URL=https://api-carcarex.futxtech.com');

      expect(Env.apiRootUrl, 'https://api-carcarex.futxtech.com');
    });
  });
}
