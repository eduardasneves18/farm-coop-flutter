import 'package:flutter/material.dart';
import 'package:generics_components_flutter/generics_components_flutter.dart';
import '../../componentes/coop_farm_base.dart';
import '../../services/firebase/products/products_firebase.dart';
import '../../utils/app_menu_itens.dart';
import '../../utils/user_auth_checker.dart';

class RegisterProductScreen extends StatefulWidget {
  const RegisterProductScreen({Key? key}) : super(key: key);

  @override
  _RegisterProductState createState() => _RegisterProductState();
}

class _RegisterProductState extends State<RegisterProductScreen> {
  final ProductsFirebaseService _productService = ProductsFirebaseService();

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _costPriceController = TextEditingController();
  final TextEditingController _sellPriceController = TextEditingController();
  double? _profitMargin;
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
      },
    );
  }

  void _calculateProfit() {
    final cost = double.tryParse(_costPriceController.text.trim()) ?? 0;
    final sell = double.tryParse(_sellPriceController.text.trim()) ?? 0;

    setState(() {
      _profitMargin = (cost > 0 && sell > cost)
          ? ((sell - cost) / cost) * 100
          : null;
    });
  }

  Future<void> _registerProduct() async {
    final String nome = _nameController.text.trim();
    final double? custo = double.tryParse(_costPriceController.text.trim());
    final double? venda = double.tryParse(_sellPriceController.text.trim());

    if (nome.isEmpty || custo == null || venda == null || custo <= 0 || venda <= 0) {
      DialogMessage.showMessage(
        context: context,
        title: 'Erro',
        message: 'Preencha todos os campos corretamente.',
      );
      return;
    }

    try {
      await _productService.createProduct(
        nome: nome,
        precoCusto: custo,
        precoVenda: venda,
      );

      _nameController.clear();
      _costPriceController.clear();
      _sellPriceController.clear();
      setState(() => _profitMargin = null);

      DialogMessage.showMessage(
        context: context,
        title: 'Sucesso',
        message: 'Produto cadastrado com sucesso!',
      );
    } catch (e) {
      DialogMessage.showMessage(
        context: context,
        title: 'Erro',
        message: 'Falha ao cadastrar produto. Tente novamente.',
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final Size sizeScreen = MediaQuery.of(context).size;

    return !_userChecked
        ? const Scaffold(body: Center(child: CircularProgressIndicator()))
        :
    CoopFarmLayout(
      sizeScreen: sizeScreen,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Cadastrar Novo Produto',
            style: TextStyle(
              fontSize: sizeScreen.width * 0.05,
              fontWeight: FontWeight.bold,
              color: const Color(0xFFD5C1A1),
            ),
          ),
          const SizedBox(height: 20),
          TextFields(
            controller: _nameController,
            sizeScreen: sizeScreen,
            icon: Icons.local_florist,
            hint: 'Nome do Produto',
            hintColor: const Color(0xFFD5C1A1),
            iconColor: const Color(0xFFD5C1A1),
            borderColor: const Color(0xFF4CAF50),
            textColor: const Color(0xFFD5C1A1),
            cursorColor: const Color(0xFF4CAF50),
            fillColor: Colors.transparent,
            labelColor: const Color(0xFF4CAF50),
          ),
          const SizedBox(height: 20),
          TextFields(
            controller: _costPriceController,
            sizeScreen: sizeScreen,
            icon: Icons.attach_money,
            hint: 'Preço de Custo',
            hintColor: const Color(0xFFD5C1A1),
            iconColor: const Color(0xFFD5C1A1),
            borderColor: const Color(0xFF4CAF50),
            textColor: const Color(0xFFD5C1A1),
            cursorColor: const Color(0xFF4CAF50),
            fillColor: Colors.transparent,
            labelColor: const Color(0xFF4CAF50),
            textType: TextInputType.number,
            onChanged: (_) => _calculateProfit(),
          ),
          const SizedBox(height: 20),
          TextFields(
            controller: _sellPriceController,
            sizeScreen: sizeScreen,
            icon: Icons.trending_up,
            hint: 'Preço de Venda',
            hintColor: const Color(0xFFD5C1A1),
            iconColor: const Color(0xFFD5C1A1),
            textColor: const Color(0xFFD5C1A1),
            borderColor: const Color(0xFF4CAF50),
            cursorColor: const Color(0xFF4CAF50),
            fillColor: Colors.transparent,
            labelColor: const Color(0xFF4CAF50),
            textType: TextInputType.number,
            onChanged: (_) => _calculateProfit(),
          ),
          const SizedBox(height: 30),
          Text(
            _profitMargin != null
                ? 'Lucro estimado: ${_profitMargin!.toStringAsFixed(2)}%'
                : 'Preencha corretamente os preços para ver o lucro.',
            style: TextStyle(
              fontSize: sizeScreen.width * 0.04,
              color: _profitMargin != null
                  ? const Color(0xFFD5C1A1)
                  : Colors.grey[400],
            ),
          ),
          const SizedBox(height: 40),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: _registerProduct,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF4CAF50),
                padding: const EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              child: const Text(
                'Cadastrar Produto',
                style: TextStyle(color: Colors.white),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
