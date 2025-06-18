import 'package:flutter/material.dart';
import 'package:generics_components_flutter/generics_components_flutter.dart';
import '../utils/app_menu_itens.dart';


class CoopFarmAppBar extends StatelessWidget implements PreferredSizeWidget {
  const CoopFarmAppBar({Key? key})
      : preferredSize = const Size.fromHeight(70.0),
        super(key: key);

  @override
  final Size preferredSize;

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: const Color(0xFF030303),
      leading: Builder(
        builder: (context) => IconButton(
          icon: const Icon(Icons.menu, color: Color(0xFFE8E3D4)),
          onPressed: () => Scaffold.of(context).openDrawer(),
        ),
      ),
      title: const Text(
        'Coop Farm',
        style: TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 24,
          color: Color(0xFF4CAF50),
        ),
      ),
      centerTitle: true,
      actions: [
        IconButton(
          icon: const Icon(Icons.account_circle, color: Color(0xFFE8E3D4)),
          onPressed: () {
            Navigator.pushReplacementNamed(context, '/login');
          },
        ),
      ],
      elevation: 4,
    );
  }
}

class CoopFarmLayout extends StatelessWidget {
  final Widget child;
  final Size sizeScreen;

  const CoopFarmLayout({
    Key? key,
    required this.child,
    required this.sizeScreen,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CoopFarmAppBar(),
      drawer: GenericDrawerMenu(
        headerTitle: 'Coop Farm Menu',
        menuItems: AppMenuItems.mainMenuItems(context),
        headerTextColor: const Color(0xFF4CAF50),
        menuItemTextColor: const Color(0xFFD5C1A1),
        iconColor: const Color(0xFFD5C1A1),
        backgroundColor: Colors.grey[900]!,
      ),

      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xFF121212),
              Color(0xFF3E513F),
            ],
          ),
        ),
        width: sizeScreen.width,
        height: sizeScreen.height,
        padding: EdgeInsets.symmetric(
          horizontal: 20,
          vertical: sizeScreen.height * 0.04,
        ),
        child: Container(
          decoration: BoxDecoration(
            color: const Color(0xFFE8E3D4).withOpacity(0.1),
            borderRadius: BorderRadius.circular(12),
          ),
          padding: const EdgeInsets.all(16.0),
          child: child,
        ),
      ),
    );
  }
}
