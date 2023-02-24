import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:esp_app/models/user_model.dart';

class SecureStorage {
  // Create storage
  final storage = const FlutterSecureStorage();

  String keyUserName;
  String keyUserToken;

  SecureStorage({
    required this.keyUserName,
    required this.keyUserToken,
  });

  Future setUserName(String username) async {
    await storage.write(key: keyUserName, value: username);
  }

  Future<String?> getUserName() async {
    return await storage.read(key: keyUserName);
  }

  Future setUserToken(String token) async {
    await storage.write(key: keyUserToken, value: token);
  }

  Future<String?> getUserToken() async {
    return await storage.read(key: keyUserToken);
  }
}
