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
            'Coop Farm',
            style: TextStyle(
              fontSize: sizeScreen.width * 0.06,
              fontWeight: FontWeight.bold,
              color: Color(0xFFD5C1A1),
            ),
          ),
          const SizedBox(height: 20),
          const Text(
            'Bem vindo(a) à nossa cooperativa!',
            style: TextStyle(
              fontSize: 16,
              color: Color(0xFFE8E3D4),
            ),
          ),
          const SizedBox(height: 20),
          const Text(
            'Unindo forças para cultivar um futuro melhor.',
            style: TextStyle(
              fontSize: 16,
              color: Color(0xFFE8E3D4),
            ),
          ),
          const SizedBox(height: 20),
          const Text(
            'Somos uma cooperativa formada por fazendas que acreditam na força do trabalho coletivo, na valorização do produtor rural e na sustentabilidade do campo.',
            style: TextStyle(
              fontSize: 16,
              color: Color(0xFFE8E3D4),
            ),
          ),
        ],
      ),
    );
  }
}
