import 'package:flutter_dotenv/flutter_dotenv.dart';

class Env {
  static String get baseUrl {
    final value = dotenv.env['BASE_URL'];
    if (value == null || value.isEmpty) {
      throw Exception('BASE_URL is not defined in .env file.');
    }
    return value;
  }

  static String get reverbKey {
    return dotenv.env['REVERB_KEY'] ?? 'qvu5rzruhum2kkuf6vyg';
  }

  static String get reverbHost {
    return dotenv.env['REVERB_HOST'] ?? '10.95.236.103';
  }

  static int get reverbPort {
    return int.tryParse(dotenv.env['REVERB_PORT'] ?? '8080') ?? 8080;
  }

  static String get reverbScheme {
    return dotenv.env['REVERB_SCHEME'] ?? 'http';
  }

  static String get googleWebClientId {
    return dotenv.env['GOOGLE_WEB_CLIENT_ID'] ?? '';
  }

  /// [baseUrl] with a trailing `/api` stripped. Laravel's `Broadcast::routes()`
  /// registers the broadcasting-auth route outside routes/api.php's `/api`
  /// prefix, so that one call needs the bare host instead of ApiService's
  /// normal `/api`-prefixed base.
  static String get apiRootUrl {
    return baseUrl.endsWith('/api')
        ? baseUrl.substring(0, baseUrl.length - '/api'.length)
        : baseUrl;
  }
}