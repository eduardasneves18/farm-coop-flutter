import 'package:coop_farm/componentes/coop_farm_base.dart';
import 'package:coop_farm/componentes/fields/dropdown/products_dropdown_field.dart';
import 'package:coop_farm/services/firebase/firebase.dart';
import 'package:coop_farm/services/firebase/users/user_firebase.dart';
import 'package:flutter/material.dart';
import 'package:generics_components_flutter/generics_components_flutter.dart';
import '../../componentes/fields/dropdown/unit_dropdow_field.dart';
import '../../utils/user_auth_checker.dart';

class RegisterProductionScreen extends StatefulWidget {
  const RegisterProductionScreen({super.key});

  @override
  State<RegisterProductionScreen> createState() => _RegisterProductionScreenState();
}

class _RegisterProductionScreenState extends State<RegisterProductionScreen> {
  final FirebaseServiceGeneric _firebaseService = FirebaseServiceGeneric();
  final UsersFirebaseService _usersService = UsersFirebaseService();

  final TextEditingController _productController = TextEditingController();
  final TextEditingController _quantityController = TextEditingController();
  final TextEditingController _unitController = TextEditingController();
  final TextEditingController _estimatedDateController = TextEditingController();

  Map<String, dynamic>? _produtoSelecionado;
  String? _unidadeSelecionada;
  String? _statusSelecionado;
  bool _userChecked = false;

  final List<String> _statusOptions = ['Aguardando', 'Em Produção', 'Colhido'];

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
    _productController.dispose();
    _quantityController.dispose();
    _unitController.dispose();
    _estimatedDateController.dispose();
    super.dispose();
  }

  Future<void> _salvarProducao() async {
    final produto = _productController.text.trim();
    final quantidade = double.tryParse(_quantityController.text.trim()) ?? 0.0;
    final unidade = _unitController.text.trim();
    final dataEstimada = _estimatedDateController.text.trim();
    final status = _statusSelecionado;

    if (produto.isEmpty || quantidade <= 0 || unidade.isEmpty || status == null || (status != 'Colhido' && dataEstimada.isEmpty)) {
      DialogMessage.showMessage(
        context: context,
        title: 'Erro',
        message: 'Preencha todos os campos obrigatórios corretamente.',
      );
      return;
    }

    try {
      final user = await _usersService.getUser();
      if (user == null) throw Exception('Usuário não autenticado');

      await _firebaseService.create('productions', {
        'usuario_id': user.uid,
        'produto': produto,
        'quantidade': quantidade,
        'unidade': unidade,
        'data_estimada': status == 'Colhido' ? null : dataEstimada,
        'status': status,
        'created_at': DateTime.now().toIso8601String(),
      });

      DialogMessage.showMessage(
        context: context,
        title: 'Sucesso',
        message: 'Produção registrada com sucesso!',
      );

      _productController.clear();
      _quantityController.clear();
      _unitController.clear();
      _estimatedDateController.clear();
      setState(() {
        _statusSelecionado = null;
        _produtoSelecionado = null;
      });
    } catch (e) {
      DialogMessage.showMessage(
        context: context,
        title: 'Erro',
        message: 'Erro ao salvar produção: $e',
      );
    }
  }

  void _selecionarDataEstimada() async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2020),
      lastDate: DateTime(2100),
    );
    if (pickedDate != null) {
      _estimatedDateController.text =
      '${pickedDate.day.toString().padLeft(2, '0')}/${pickedDate.month.toString().padLeft(2, '0')}/${pickedDate.year}';
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
            'Registrar Produção',
            style: TextStyle(
              fontSize: sizeScreen.width * 0.05,
              fontWeight: FontWeight.bold,
              color: const Color(0xFFD5C1A1),
            ),
          ),
          const SizedBox(height: 16),
          ProductDropdownField(
            sizeScreen: sizeScreen,
            onProdutoSelecionado: (produto) {
              setState(() {
                _produtoSelecionado = produto;
                _productController.text = produto?['productId'] ?? '';
                _unitController.text = produto?['unidade_medida'] ?? '';
                _unidadeSelecionada = produto?['unidade_medida'];
              });
            },
          ),
          const SizedBox(height: 10),
          NumberField(
            controller: _quantityController,
            sizeScreen: sizeScreen,
            hint: 'Quantidade${_unidadeSelecionada != null ? ' ($_unidadeSelecionada)' : ''}',
            iconColor: const Color(0xFFD5C1A1),
            textColor: const Color(0xFFD5C1A1),
            borderColor: const Color(0xFF4CAF50),
            cursorColor: const Color(0xFF4CAF50),
            fillColor: Colors.transparent,
            labelColor: const Color(0xFF4CAF50),
          ),
          const SizedBox(height: 10),
          UnitDropdownField(
            selectedUnit: _unidadeSelecionada,
            onChanged: (String? value) {
              setState(() => _unidadeSelecionada = value);
            },
            sizeScreen: sizeScreen,
          ),
          const SizedBox(height: 10),
          DropdownField(
            sizeScreen: sizeScreen,
            hint: 'Status da Produção',
            textColor: const Color(0xFFD5C1A1),
            borderColor: const Color(0xFF4CAF50),
            labelColor: const Color(0xFF4CAF50),
            fillColor: Colors.transparent,
            iconColor: const Color(0xFFD5C1A1),
            opcoesDeSelecao: _statusOptions,
            dropdownColor: Colors.grey[900],
            value: _statusSelecionado,
            onChanged: (String? value) {
              setState(() {
                _statusSelecionado = value;
                if (value == 'Colhido') {
                  _estimatedDateController.clear();
                }
              });
            },
          ),
          const SizedBox(height: 10),
          GestureDetector(
            onTap: _statusSelecionado == 'Colhido' ? null : _selecionarDataEstimada,
            child: AbsorbPointer(
              absorbing: _statusSelecionado == 'Colhido',
              child: DateField(
                controller: _estimatedDateController,
                sizeScreen: sizeScreen,
                hint: 'Data Estimada para Colheita',
                textColor: const Color(0xFFD5C1A1),
                borderColor: const Color(0xFF4CAF50),
                iconColor: const Color(0xFFD5C1A1),
                fillColor: Colors.transparent,
              ),
            ),
          ),
          const SizedBox(height: 30),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: _salvarProducao,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF4CAF50),
                padding: const EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              child: const Text(
                'Cadastrar Produção',
                style: TextStyle(color: Colors.white),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
