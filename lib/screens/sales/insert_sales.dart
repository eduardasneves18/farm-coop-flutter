import 'package:coop_farm/componentes/coop_farm_base.dart';
import 'package:coop_farm/componentes/fields/dropdown/products_dropdown_field.dart';
import 'package:coop_farm/services/firebase/sales/sales_firebase.dart';
import 'package:flutter/material.dart';
import 'package:generics_components_flutter/generics_components_flutter.dart';
import '../../services/firebase/goals/goals_firebase.dart';
import '../../services/firebase/products/products_firebase.dart';
import '../../utils/user_auth_checker.dart';

class RegisterSaleScreen extends StatefulWidget {
  const RegisterSaleScreen({Key? key}) : super(key: key);

  @override
  _RegisterSaleScreenState createState() => _RegisterSaleScreenState();
}

class _RegisterSaleScreenState extends State<RegisterSaleScreen> {
  final SalesFirebaseService _salesService = SalesFirebaseService();

  final TextEditingController _productIdController = TextEditingController();
  final TextEditingController _productNameController = TextEditingController();
  final TextEditingController _productSalePrice = TextEditingController();
  final TextEditingController _quantityController = TextEditingController();
  final TextEditingController _valueController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _clientNameController = TextEditingController();
  final TextEditingController _unitController = TextEditingController();
  final GoalsFirebaseService _goalsService = GoalsFirebaseService();


  Map<String, dynamic>? _produtoSelecionado;
  String? _unidadeSelecionada;
  String? _formaDePagamentoSelecionada;
  bool _userChecked = false;

  @override
  void initState() {
    super.initState();
    _checkUser();
    _quantityController.addListener(_atualizarValorVenda);
  }

  void _checkUser() {
    UserAuthChecker.check(
      context: context,
      onAuthenticated: () {
        setState(() => _userChecked = true);
      },
    );
  }

  void _atualizarValorVenda() {
    final double parsedQuantity = double.tryParse(_quantityController.text.trim()) ?? 0.0;
    final double salePrice = double.tryParse(_productSalePrice.text.trim()) ?? 0.0;

    if (parsedQuantity > 0 && salePrice > 0) {
      final double calculatedValue = parsedQuantity * salePrice;
      _valueController.text = calculatedValue.toStringAsFixed(2);
    } else {
      _valueController.text = '';
    }
  }

  Future<void> _registerSale() async {
    final String productId = _productIdController.text.trim();
    final String productName = _productNameController.text.trim();
    final String description = _descriptionController.text.trim();
    final String clientName = _clientNameController.text.trim();
    final String? unit = _unidadeSelecionada;
    final String? paymentMethod = _formaDePagamentoSelecionada;

    final double? quantity = double.tryParse(_quantityController.text.trim());
    final double? value = double.tryParse(_valueController.text.trim());

    if (productId.isEmpty ||
        productName.isEmpty ||
        unit == null ||
        clientName.isEmpty ||
        quantity == null ||
        value == null ||
        quantity <= 0 ||
        value <= 0 ||
        paymentMethod == null) {
      DialogMessage.showMessage(
        context: context,
        title: 'Erro',
        message: 'Preencha todos os campos obrigatórios.',
      );
      return;
    }

    try {
      await _salesService.createSale(
        productId: productId,
        productName: productName,
        quantity: quantity,
        value: value,
        unit: unit,
        clientName: clientName,
        paymentMethod: paymentMethod,
      );

      await _goalsService.verifyGoals(
        productId: productId,
        novoValor: value,
        dataOperacao: DateTime.now(),
        context: context,
      );

      final double estoqueAtual = double.tryParse(_produtoSelecionado?['quantidade_disponivel'].toString() ?? '0') ?? 0;
      final double novoEstoque = estoqueAtual - quantity;
      await ProductsFirebaseService().updateProductQuantity(productId, novoEstoque);

      _productIdController.clear();
      _productNameController.clear();
      _quantityController.clear();
      _valueController.clear();
      _descriptionController.clear();
      _clientNameController.clear();
      _unitController.clear();
      _productSalePrice.clear();

      setState(() {
        _unidadeSelecionada = null;
        _produtoSelecionado = null;
        _formaDePagamentoSelecionada = null;
      });

      DialogMessage.showMessage(
        context: context,
        title: 'Sucesso',
        message: 'Venda registrada com sucesso!',
      );
    } catch (e) {
      DialogMessage.showMessage(
        context: context,
        title: 'Erro',
        message: 'Falha ao registrar venda. Tente novamente.',
      );
    }
  }

  @override
  void dispose() {
    _quantityController.removeListener(_atualizarValorVenda);
    _productIdController.dispose();
    _productNameController.dispose();
    _quantityController.dispose();
    _valueController.dispose();
    _descriptionController.dispose();
    _clientNameController.dispose();
    _unitController.dispose();
    _productSalePrice.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final Size sizeScreen = MediaQuery.of(context).size;

    return !_userChecked
        ? const Scaffold(body: Center(child: CircularProgressIndicator()))
        : CoopFarmLayout(
      sizeScreen: sizeScreen,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Registrar Nova Venda',
            style: TextStyle(
              fontSize: sizeScreen.width * 0.05,
              fontWeight: FontWeight.bold,
              color: const Color(0xFFD5C1A1),
            ),
          ),
          const SizedBox(height: 10),
          ProductDropdownField(
            sizeScreen: sizeScreen,
            onProdutoSelecionado: (produto) {
              setState(() {
                _produtoSelecionado = produto;
                _productIdController.text = produto?['productId'] ?? '';
                _productNameController.text = produto?['nome'] ?? '';
                _unitController.text = produto?['unidade_medida'] ?? '';
                _productSalePrice.text = produto?['preco_venda']?.toString() ?? '';
                _unidadeSelecionada = produto?['unidade_medida'];
              });
            },
          ),
          NumberField(
            controller: _quantityController,
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
          const SizedBox(height: 10),
          TextFields(
            controller: _valueController,
            sizeScreen: sizeScreen,
            icon: Icons.attach_money,
            hint: 'Valor da Venda',
            textType: TextInputType.number,
            textColor: const Color(0xFFD5C1A1),
            borderColor: const Color(0xFF4CAF50),
            fillColor: Colors.transparent,
            iconColor: const Color(0xFFD5C1A1),
          ),
          const SizedBox(height: 10),
          TextFields(
            controller: _clientNameController,
            sizeScreen: sizeScreen,
            icon: Icons.person,
            hint: 'Nome do Cliente',
            textColor: const Color(0xFFD5C1A1),
            borderColor: const Color(0xFF4CAF50),
            fillColor: Colors.transparent,
            iconColor: const Color(0xFFD5C1A1),
          ),
          const SizedBox(height: 10),
          DropdownField(
            sizeScreen: sizeScreen,
            hint: 'Forma de Pagamento',
            hintColor: const Color(0xFFD5C1A1),
            textColor: const Color(0xFFD5C1A1),
            borderColor: const Color(0xFF4CAF50),
            fillColor: Colors.transparent,
            iconColor: const Color(0xFFD5C1A1),
            labelColor: const Color(0xFF4CAF50),
            opcoesDeSelecao: ['Pix', 'Dinheiro', 'Crédito', 'Débito'],
            dropdownColor: Colors.grey[900],
            value: _formaDePagamentoSelecionada,
            onChanged: (String? value) {
              setState(() => _formaDePagamentoSelecionada = value);
            },
          ),
          const SizedBox(height: 30),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: _registerSale,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF4CAF50),
                padding: const EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              child: const Text(
                'Cadastrar Venda',
                style: TextStyle(color: Colors.white),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
