// controllers/auth_controller.dart
import 'package:grene/services/api_service.dart';

/// Controller responsável por autenticação do usuário.
/// 
/// Atua como intermediário entre as views e o [ApiService].
class AuthController {
  /// Realiza o login chamando o [ApiService].
  /// 
  /// Retorna `true` se o login for bem-sucedido, `false` caso contrário.
  static Future<bool> login(String username, String password) async {
    return await ApiService.login(username, password);
  }
}
