import 'package:coop_farm/screens/products/insert_products.dart';
import 'package:flutter/material.dart';
import '../../componentes/coop_farm_base.dart';

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final sizeScreen = MediaQuery.of(context).size;

    return CoopFarmLayout(
      sizeScreen: sizeScreen,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Nova Transação',
            style: TextStyle(
              fontSize: sizeScreen.width * 0.06,
              fontWeight: FontWeight.bold,
              color: Color(0xFFD5C1A1),
            ),
          ),
          const SizedBox(height: 20),
          const Text(
            'Aqui você pode iniciar uma nova transação cooperativa.',
            style: TextStyle(
              fontSize: 16,
              color: Color(0xFFE8E3D4),
            ),
          ),
          const SizedBox(height: 20),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Color(0xFF4CAF50),
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => RegisterProductScreen()),
              );
            },
            child: const Text(
              'Iniciar',
              style: TextStyle(color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }
}
