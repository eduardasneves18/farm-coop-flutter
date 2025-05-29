import 'package:coop_farm/screens/signout/login.dart';
import 'package:flutter/material.dart';
import 'package:generics_components_flutter/generics_components_flutter.dart';
import '../services/firebase/users/user_firebase.dart';

class UserAuthChecker {
  static Future<void> check({
    required BuildContext context,
    required VoidCallback onAuthenticated,
  }) async {
    final userService = UsersFirebaseService();
    final user = await userService.getUser();

    if (user == null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        DialogMessage.showMessage(
          context: context,
          title: 'Erro',
          message: 'Usuário não autenticado. Por favor, faça login novamente.',
          onConfirmed: () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => LoginScreen()),
            );
          },
        );
      });
    } else {
      onAuthenticated();
    }
  }
}
