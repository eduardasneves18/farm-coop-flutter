import 'package:coop_farm/screens/products/insert_products.dart';
import 'package:coop_farm/screens/sales/insert_sales.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:generics_components_flutter/generics_components_flutter.dart';
import 'package:provider/provider.dart';

import '../models/cliente.dart';
import '../screens/home/home.dart';
import '../screens/signout/login.dart';
import '../services/firebase/sessions/sessionManager.dart';
import '../services/firebase/users/login/login_firebase.dart';
import '../services/firebase/users/user_firebase.dart';
import '../store/cliente_store.dart';

class AppMenuItems {
  static List<MenuItem> mainMenuItems(BuildContext context) {
  final ClienteStore _clienteStore = Provider.of<ClienteStore>(context);
    return [
      MenuItem(
        icon: Icons.home,
        title: 'Home',
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => HomeScreen()),
          );
        },
      ),
      MenuItem(
        icon: Icons.settings,
        title: 'Produtos',
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => RegisterProductScreen()),
          );
        },
      ),
      MenuItem(
        icon: Icons.settings,
        title: 'Cadastro de venda',
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => RegisterSaleScreen()),
          );
        },
      ),
      MenuItem(
        icon: Icons.output,
        title: 'Sair',
        onTap: () async {
          final usersService = UsersFirebaseService();
          final loginService = LoginFirebaseAuthService();

          User? user = await usersService.getUser();

          if (user?.uid != null) {
          Cliente cliente = Cliente(
          id: user!.uid,
          email: user.email,
          nome: user.displayName,
          );

          final sessionManager = SessionManager(
          loginService,
          cliente,
          _clienteStore,
          );

          await sessionManager.logout();
          }

          Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => LoginScreen()),
          (Route<dynamic> route) => false,
          );
        },
      ),
    ];
  }
}
