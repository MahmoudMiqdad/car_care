import 'package:google_sign_in/google_sign_in.dart';

class GoogleIdTokenMissingException implements Exception {
  const GoogleIdTokenMissingException();
}

class GoogleSignInService {
  GoogleSignInService({required String serverClientId})
    : _serverClientId = serverClientId;

  final String _serverClientId;
  bool _initialized = false;

  Future<void> _ensureInitialized() async {
    print('GOOGLE SERVER CLIENT ID: $_serverClientId');
    if (_initialized) return;
    await GoogleSignIn.instance.initialize(serverClientId: _serverClientId);
    _initialized = true;
  }

 
  Future<String?> signInAndGetIdToken() async {
    await _ensureInitialized();

    final GoogleSignInAccount account;
   try {
  account = await GoogleSignIn.instance.authenticate();
} on GoogleSignInException catch (e) {
  print('GOOGLE SIGN IN ERROR CODE: ${e.code}');
  print('GOOGLE SIGN IN ERROR DESCRIPTION: ${e.description}');

  if (e.code == GoogleSignInExceptionCode.canceled) return null;
  rethrow;
}

    final idToken = account.authentication.idToken;
    if (idToken == null || idToken.isEmpty) {
      throw const GoogleIdTokenMissingException();
    }
    return idToken;
  }

  Future<void> signOut() async {
    try {
      await _ensureInitialized();
      await GoogleSignIn.instance.signOut();
    } catch (_) {
      // Best-effort only.
    }
  }
}
