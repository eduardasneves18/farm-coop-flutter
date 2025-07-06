import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../componentes/coop_farm_base.dart';
import '../../services/firebase/products/products_firebase.dart';
import '../../services/firebase/users/user_firebase.dart';
import '../../utils/user_auth_checker.dart';

class ListProductsScreen extends StatefulWidget {
  const ListProductsScreen({super.key});

  @override
  State<ListProductsScreen> createState() => _ListProductsScreenState();
}

class _ListProductsScreenState extends State<ListProductsScreen> {
  final ProductsFirebaseService _productService = ProductsFirebaseService();
  List<Map<String, dynamic>> _products = [];
  bool _isLoading = true;
  bool _userChecked = false;

  @override
  void initState() {
    super.initState();
    _checkUser();
  }

  void _checkUser() {
    UserAuthChecker.check(
      context: context,
      onAuthenticated: () {
        setState(() => _userChecked = true);
        _loadProducts();
      },
    );
  }

  Future<void> _loadProducts() async {
    final UsersFirebaseService usersService = UsersFirebaseService();
    final user = await usersService.getUser();
    final uid = user?.uid;

    if (uid == null) return;

    final products = await _productService.getProducts();
    setState(() {
      _products = products;
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final sizeScreen = MediaQuery.of(context).size;

    return CoopFarmLayout(
      sizeScreen: sizeScreen,
      child: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Produtos',
            style: TextStyle(
              fontSize: sizeScreen.width * 0.05,
              fontWeight: FontWeight.bold,
              color: const Color(0xFFD5C1A1),
            ),
          ),
          const SizedBox(height: 16),
          _products.isEmpty
              ? const Center(
            child: Text(
              'Nenhum produto encontrado.',
              style: TextStyle(color: Colors.white),
            ),
          )
              : Expanded(
            child: ListView.builder(
              itemCount: _products.length,
              itemBuilder: (context, index) {
                final product = _products[index];
                return Card(
                  color: Colors.white12,
                  margin: const EdgeInsets.all(10),
                  child: ListTile(
                    textColor: Colors.white,
                    title: Text(
                      product['nome'] ?? '',
                      style: TextStyle(fontSize: sizeScreen.width * 0.05),
                    ),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Quantidade total: ${product['quantidade_disponivel']} ${product['unidade_medida']}',
                        ),
                        Text(
                          'Preço por unidade: R\$ ${product['preco_venda']?.toStringAsFixed(2) ?? '0.00'}',
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
