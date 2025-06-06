import 'package:flutter/material.dart';
import 'package:generics_components_flutter/generics_components_flutter.dart';

import '../../componentes/coop_farm_base.dart';
import '../../services/firebase/products/products_firebase.dart';
import '../../utils/user_auth_checker.dart';

class RegisterProductScreen extends StatefulWidget {
  const RegisterProductScreen({super.key});

  @override
  State<RegisterProductScreen> createState() => _RegisterProductScreenState();
}

class _RegisterProductScreenState extends State<RegisterProductScreen> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _costPriceController = TextEditingController();
  final TextEditingController _sellPriceController = TextEditingController();
  final TextEditingController _unitController = TextEditingController();
  final TextEditingController _profitPercentController = TextEditingController();
  final ProductsFirebaseService _productService = ProductsFirebaseService();
  String? _unidadeSelecionada;
  double? _profitMargin;
  double? _profitValue;
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

  @override
  void dispose() {
    _nameController.dispose();
    _costPriceController.dispose();
    _sellPriceController.dispose();
    _unitController.dispose();
    _profitPercentController.dispose();
    super.dispose();
  }

  void _calculateProfitMargin() {
    final double? costPrice = double.tryParse(_costPriceController.text);
    final double? sellingPrice = double.tryParse(_sellPriceController.text);

    if (costPrice == null || sellingPrice == null || costPrice <= 0) {
      setState(() {
        _profitMargin = null;
        _profitValue = null;
        _profitPercentController.clear();
      });
      return;
    }

    final double profit = sellingPrice - costPrice;
    final double margin = (profit / costPrice) * 100;

    setState(() {
      _profitMargin = margin;
      _profitValue = profit;
      _profitPercentController.text = '${margin.toStringAsFixed(2)} %';
    });
  }

  Future<void> _registerProduct() async {
    final String nome = _nameController.text.trim();
    final double? custo = double.tryParse(_costPriceController.text.trim());
    final double? venda = double.tryParse(_sellPriceController.text.trim());
    final String? unidade = _unidadeSelecionada;
    final double? quantidade = double.tryParse(_unitController.text.trim());

    if (nome.isEmpty || custo == null || venda == null || unidade == null || quantidade == null || custo <= 0 || venda <= 0 || quantidade <= 0) {
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
        percentualLucro: _profitMargin?? 0.0,
        lucro: _profitValue?? 0.0,
        unidadeMedida: unidade,
        quantidadeDisponivel: quantidade,
      );

      _nameController.clear();
      _costPriceController.clear();
      _sellPriceController.clear();
      _unitController.clear();
      _profitPercentController.clear();
      setState(() {
        _unidadeSelecionada = null;
        _profitMargin = null;
        _profitValue = null;
      });

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
    final sizeScreen = MediaQuery.of(context).size;

    return !_userChecked
        ? const Scaffold(body: Center(child: CircularProgressIndicator()))
        : CoopFarmLayout(
      sizeScreen: sizeScreen,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Cadastro de Produto',
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
            icon: Icons.shopping_cart,
            hint: 'Nome do produto',
            hintColor: const Color(0xFFD5C1A1),
            textColor: const Color(0xFFD5C1A1),
            borderColor: const Color(0xFF4CAF50),
            cursorColor: const Color(0xFF4CAF50),
            fillColor: Colors.transparent,
            labelColor: const Color(0xFF4CAF50),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                flex: 2,
                child: DropdownField(
                  sizeScreen: sizeScreen,
                  hint: 'Unidade',
                  hintColor: const Color(0xFFD5C1A1),
                  textColor: const Color(0xFFD5C1A1),
                  borderColor: const Color(0xFF4CAF50),
                  fillColor: Colors.transparent,
                  iconColor: const Color(0xFFD5C1A1),
                  labelColor: const Color(0xFF4CAF50),
                  opcoesDeSelecao: ['kg', 'l', 'g', 'dz'],
                  dropdownColor: Colors.grey[900],
                  value: _unidadeSelecionada,
                  onChanged: (String? value) {
                    setState(() => _unidadeSelecionada = value);
                  },
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                flex: 2,
                child: NumberField(
                  controller: _unitController,
                  sizeScreen: sizeScreen,
                  hint: 'Quantidade${_unidadeSelecionada != null ? ' ($_unidadeSelecionada)' : ''}',
                  hintColor: const Color(0xFFD5C1A1),
                  iconColor: const Color(0xFFD5C1A1),
                  textColor: const Color(0xFFD5C1A1),
                  borderColor: const Color(0xFF4CAF50),
                  cursorColor: const Color(0xFF4CAF50),
                  fillColor: Colors.transparent,
                  labelColor: const Color(0xFF4CAF50),
                  textType: TextInputType.number,
                ),
              ),
            ],
          ),
          NumberField(
            controller: _costPriceController,
            sizeScreen: sizeScreen,
            icon: Icons.attach_money,
            hint: 'Preço de custo',
            hintColor: const Color(0xFFD5C1A1),
            iconColor: const Color(0xFFD5C1A1),
            textColor: const Color(0xFFD5C1A1),
            borderColor: const Color(0xFF4CAF50),
            cursorColor: const Color(0xFF4CAF50),
            fillColor: Colors.transparent,
            labelColor: const Color(0xFF4CAF50),
            textType: TextInputType.number,
            onChanged: (_) => _calculateProfitMargin(),
          ),
          const SizedBox(height: 16),
          NumberField(
            controller: _sellPriceController,
            sizeScreen: sizeScreen,
            icon: Icons.monetization_on,
            hint: 'Preço de venda',
            hintColor: const Color(0xFFD5C1A1),
            iconColor: const Color(0xFFD5C1A1),
            textColor: const Color(0xFFD5C1A1),
            borderColor: const Color(0xFF4CAF50),
            cursorColor: const Color(0xFF4CAF50),
            fillColor: Colors.transparent,
            labelColor: const Color(0xFF4CAF50),
            textType: TextInputType.number,
            onChanged: (_) => _calculateProfitMargin(),
          ),
          const SizedBox(height: 16),
          TextFields(
            controller: _profitPercentController,
            sizeScreen: sizeScreen,
            icon: Icons.percent,
            hint: 'Margem de lucro',
            hintColor: const Color(0xFFD5C1A1),
            textColor: const Color(0xFFD5C1A1),
            borderColor: const Color(0xFF4CAF50),
            cursorColor: const Color(0xFF4CAF50),
            fillColor: Colors.transparent,
            labelColor: const Color(0xFF4CAF50),
          ),
          const SizedBox(height: 16),
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
