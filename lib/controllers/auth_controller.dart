// Controller para login/logout. A view chama este controller.

import 'package:grene/services/api_service.dart';

class AuthController {
  static Future<bool> login(String username, String password) async {
    return await ApiService.login(username, password);
  }
}

