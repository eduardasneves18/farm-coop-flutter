import 'package:flutter/material.dart';
import 'package:generics_components_flutter/generics_components_flutter.dart';
import '../../../services/firebase/products/products_firebase.dart';
import '../../../services/firebase/users/user_firebase.dart';


class ProductDropdownField extends StatefulWidget {
  final Size sizeScreen;
  final void Function(Map<String, dynamic>? produto) onProdutoSelecionado;

  const ProductDropdownField({
    super.key,
    required this.sizeScreen,
    required this.onProdutoSelecionado,
  });

  @override
  State<ProductDropdownField> createState() => _ProductDropdownFieldState();
}

class _ProductDropdownFieldState extends State<ProductDropdownField> {
  final ProductsFirebaseService _productsService = ProductsFirebaseService();
  final UsersFirebaseService _usersService = UsersFirebaseService();

  List<Map<String, dynamic>> _produtos = [];
  Map<String, dynamic>? _produtoSelecionado;

  @override
  void initState() {
    super.initState();
    _loadProdutos();
  }

  Future<void> _loadProdutos() async {
    final user = await _usersService.getUser();
    if (user == null) return;
    final produtos = await _productsService.getProducts();
    setState(() => _produtos = produtos);
  }

  @override
  Widget build(BuildContext context) {
    return DropdownField(
      sizeScreen: widget.sizeScreen,
      hint: 'Produto',
      textColor: const Color(0xFFD5C1A1),
      borderColor: const Color(0xFF4CAF50),
      labelColor: const Color(0xFF4CAF50),
      fillColor: Colors.transparent,
      iconColor: const Color(0xFFD5C1A1),
      dropdownColor: Colors.grey[900],
      opcoesDeSelecao: _produtos.map((p) => p['nome'].toString()).toList(),
      value: _produtoSelecionado?['nome'],
      onChanged: (String? nomeSelecionado) {
        final produto = _produtos.firstWhere(
              (p) => p['nome'] == nomeSelecionado,
          orElse: () => {},
        );
        setState(() => _produtoSelecionado = produto);
        widget.onProdutoSelecionado(produto.isEmpty ? null : produto);
      },
    );
  }
}
