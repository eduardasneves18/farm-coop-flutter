import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:generics_components_flutter/generics_components_flutter.dart';
import 'package:provider/provider.dart';

import '../models/cliente.dart';
import '../screens/goals/insert_goals.dart';
import '../screens/goals/list_goals.dart';
import '../screens/home/home.dart';
import '../screens/production/insert_production_item.dart';
import '../screens/production/list_productions.dart';
import '../screens/products/insert_products.dart';
import '../screens/products/list_products.dart';
import '../screens/sales/insert_sales.dart';
import '../screens/sales/list_sales.dart';
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
        icon: Icons.dashboard_outlined,
        title: 'Home',
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => HomeScreen()),
          );
        },
      ),
      MenuItem(
        icon: Icons.add_box_outlined,
        title: 'Cadastro de produtos',
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const RegisterProductScreen()),
          );
        },
      ),
      MenuItem(
        icon: Icons.inventory_2_outlined,
        title: 'Lista de produtos',
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const ListProductsScreen()),
          );
        },
      ),
      MenuItem(
        icon: Icons.show_chart_outlined,
        title: 'Dashboard de vendas',
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const ListSalesByProfitScreen()),
          );
        },
      ),
      MenuItem(
        icon: Icons.point_of_sale_outlined,
        title: 'Cadastro de venda',
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const RegisterSaleScreen()),
          );
        },
      ),
      MenuItem(
        icon: Icons.agriculture_outlined,
        title: 'Gestão de produção',
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const RegisterProductionScreen()),
          );
        },
      ),
      MenuItem(
        icon: Icons.analytics_outlined,
        title: 'Dashboard de produção',
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const ListProductionsScreen()),
          );
        },
      ),
      MenuItem(
        icon: Icons.flag_outlined,
        title: 'Cadastro de metas',
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const InsertGoalScreen()),
          );
        },
      ),
      MenuItem(
        icon: Icons.list_alt_outlined,
        title: 'Listagem de metas',
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const ListGoalsScreen()),
          );
        },
      ),
      MenuItem(
        icon: Icons.logout,
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
