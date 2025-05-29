import 'package:flutter/material.dart';
import '../screens/signout/login.dart';

class CoopFarmAppBar extends StatelessWidget implements PreferredSizeWidget {
  @override
  final Size preferredSize;

  const CoopFarmAppBar({Key? key})
      : preferredSize = const Size.fromHeight(70.0),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: const Color(0xFF3E513F),
      leading: IconButton(
        icon: const Icon(Icons.menu, color: Color(0xFFE8E3D4)),
        onPressed: () => Scaffold.of(context).openDrawer(),
      ),
      title: const Text(
        'Coop Farm',
        style: TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 24,
          color: Color(0xFFD5C1A1),
        ),
      ),
      centerTitle: true,
      actions: [
        IconButton(
          icon: const Icon(Icons.account_circle, color: Color(0xFFE8E3D4)),
          onPressed: () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => LoginScreen()),
            );
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

  const CoopFarmLayout({Key? key, required this.sizeScreen, required this.child}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CoopFarmAppBar(),
      // drawer: const Menu(), // Substitua por seu menu personalizado
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
        child: SingleChildScrollView(
          child: Container(
            decoration: BoxDecoration(
              color: const Color(0xFFE8E3D4).withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            padding: const EdgeInsets.all(16.0),
            child: child,
          ),
        ),
      ),
    );
  }
}
