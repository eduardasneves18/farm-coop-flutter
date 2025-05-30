import 'package:flutter/material.dart';
import 'package:generics_components_flutter/generics_components_flutter.dart';
import '../../componentes/coop_farm_base.dart';
import '../../services/firebase/sales/sales_firebase.dart';
import '../../utils/app_menu_itens.dart';
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
  final TextEditingController _quantityController = TextEditingController();
  final TextEditingController _unitController = TextEditingController();
  final TextEditingController _valueController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _clientNameController = TextEditingController();
  final TextEditingController _paymentMethodController = TextEditingController();

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

  Future<void> _registerSale() async {
    final String productId = _productIdController.text.trim();
    final String productName = _productNameController.text.trim();
    final String description = _descriptionController.text.trim();
    final String unit = _unitController.text.trim();
    final String clientName = _clientNameController.text.trim();
    final String paymentMethod = _paymentMethodController.text.trim();

    final double? quantity = double.tryParse(_quantityController.text.trim());
    final double? value = double.tryParse(_valueController.text.trim());

    if (productId.isEmpty || productName.isEmpty || description.isEmpty || unit.isEmpty || clientName.isEmpty || quantity == null || value == null || quantity <= 0 || value <= 0) {
      DialogMessage.showMessage(
        context: context,
        title: 'Erro',
        message: 'Preencha todos os campos obrigatórios corretamente.',
      );
      return;
    }

    try {
      await _salesService.createSale(
        productId: productId,
        productName: productName,
        description: description,
        quantity: quantity,
        value: value,
        unit: unit,
        clientName: clientName,
        paymentMethod: paymentMethod,
      );

      _productIdController.clear();
      _productNameController.clear();
      _quantityController.clear();
      _unitController.clear();
      _valueController.clear();
      _descriptionController.clear();
      _clientNameController.clear();
      _paymentMethodController.clear();

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
          const SizedBox(height: 20),
          TextFields(
            controller: _productIdController,
            sizeScreen: sizeScreen,
            icon: Icons.confirmation_number,
            hint: 'ID do Produto',
            textColor: const Color(0xFFD5C1A1),
            borderColor: const Color(0xFF4CAF50),
          ),
          const SizedBox(height: 10),
          TextFields(
            controller: _productNameController,
            sizeScreen: sizeScreen,
            icon: Icons.label,
            hint: 'Nome do Produto',
            textColor: const Color(0xFFD5C1A1),
            borderColor: const Color(0xFF4CAF50),
          ),
          const SizedBox(height: 10),
          TextFields(
            controller: _quantityController,
            sizeScreen: sizeScreen,
            icon: Icons.scale,
            hint: 'Quantidade',
            textType: TextInputType.number,
            textColor: const Color(0xFFD5C1A1),
            borderColor: const Color(0xFF4CAF50),
          ),
          const SizedBox(height: 10),
          TextFields(
            controller: _unitController,
            sizeScreen: sizeScreen,
            icon: Icons.straighten,
            hint: 'Unidade de Medida (ex: kg, litros)',
            textColor: const Color(0xFFD5C1A1),
            borderColor: const Color(0xFF4CAF50),
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
          ),
          const SizedBox(height: 10),
          TextFields(
            controller: _descriptionController,
            sizeScreen: sizeScreen,
            icon: Icons.description,
            hint: 'Descrição da Venda',
            textColor: const Color(0xFFD5C1A1),
            borderColor: const Color(0xFF4CAF50),
          ),
          const SizedBox(height: 10),
          TextFields(
            controller: _clientNameController,
            sizeScreen: sizeScreen,
            icon: Icons.person,
            hint: 'Nome do Cliente',
            textColor: const Color(0xFFD5C1A1),
            borderColor: const Color(0xFF4CAF50),
          ),
          const SizedBox(height: 10),
          TextFields(
            controller: _paymentMethodController,
            sizeScreen: sizeScreen,
            icon: Icons.payment,
            hint: 'Forma de Pagamento (PIX, dinheiro, etc)',
            textColor: const Color(0xFFD5C1A1),
            borderColor: const Color(0xFF4CAF50),
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
                'Registrar Venda',
                style: TextStyle(color: Colors.white),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
