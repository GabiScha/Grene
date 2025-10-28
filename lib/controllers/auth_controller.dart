//============================================================
// ARQUIVO: controllers/auth_controller.dart
//============================================================
import 'package:grene/services/api_service.dart';

//------------------------------------------------------------
// <AuthController>
// -- Propósito: Controlar o fluxo de autenticação do usuário.
// -- Atua como um intermediário entre as <Views> e o <ApiService>.
//------------------------------------------------------------
class AuthController {
  
  //------------------------------------------------------------
  // <login>
  // -- Descrição: Realiza a chamada de login na API.
  // -- Parâmetros:
  //   -> username: Nome do usuário.
  //   -> password: Senha do usuário.
  // -- Retorno: <bool> -> true se o login for bem-sucedido, false caso contrário.
  //------------------------------------------------------------
  static Future<bool> login(String username, String password) async {
    return await ApiService.login(username, password);
  }
}