import 'package:coop_farm/screens/products/insert_products.dart';
import 'package:coop_farm/screens/sales/insert_sales.dart';
import 'package:flutter/material.dart';
import 'package:generics_components_flutter/generics_components_flutter.dart';

import '../screens/home/home.dart';

class AppMenuItems {
  static List<MenuItem> mainMenuItems(BuildContext context) {
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
    ];
  }
}
