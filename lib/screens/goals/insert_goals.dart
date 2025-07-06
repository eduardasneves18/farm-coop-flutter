import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:generics_components_flutter/generics_components_flutter.dart';

import '../../../componentes/coop_farm_base.dart';
import '../../../services/firebase/goals/goals_firebase.dart';
import '../../../services/firebase/users/user_firebase.dart';
import '../../componentes/fields/dropdown/products_dropdown_field.dart';

class InsertGoalScreen extends StatefulWidget {
  const InsertGoalScreen({super.key});

  @override
  State<InsertGoalScreen> createState() => _InsertGoalScreenState();
}

class _InsertGoalScreenState extends State<InsertGoalScreen> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _valueController = TextEditingController();
  final TextEditingController _unitController = TextEditingController();
  final TextEditingController _quantityController = TextEditingController(); // NOVO
  final TextEditingController _deadlineController = TextEditingController();

  final TextEditingController _productIdController = TextEditingController();
  final TextEditingController _productNameController = TextEditingController();
  final TextEditingController _productSalePrice = TextEditingController();

  final UsersFirebaseService _usersService = UsersFirebaseService();
  final GoalsFirebaseService _goalsService = GoalsFirebaseService();

  final List<String> _tipoMetaOptions = ['Produção', 'Venda'];

  String? _tipoSelecionado;
  Map<String, dynamic>? _produtoSelecionado;
  String? _unidadeSelecionada;

  @override
  void dispose() {
    _nameController.dispose();
    _valueController.dispose();
    _unitController.dispose();
    _quantityController.dispose(); // NOVO
    _deadlineController.dispose();
    _productIdController.dispose();
    _productNameController.dispose();
    _productSalePrice.dispose();
    super.dispose();
  }

  Future<void> _selecionarDataLimite() async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2020),
      lastDate: DateTime(2100),
    );
    if (pickedDate != null) {
      _deadlineController.text =
      '${pickedDate.day.toString().padLeft(2, '0')}/${pickedDate.month.toString().padLeft(2, '0')}/${pickedDate.year}';
    }
  }

  Future<void> _salvarMeta() async {
    final String nome = _nameController.text.trim();
    final double valor = double.tryParse(_valueController.text.trim()) ?? 0.0;
    final double quantidade = double.tryParse(_quantityController.text.trim()) ?? 0.0;
    final String unidade = _unitController.text.trim();
    final String dataLimite = _deadlineController.text.trim();
    final String? tipo = _tipoSelecionado;
    final Map<String, dynamic>? produto = _produtoSelecionado;

    if (nome.isEmpty ||
        valor <= 0 ||
        quantidade <= 0 ||
        unidade.isEmpty ||
        tipo == null ||
        dataLimite.isEmpty ||
        produto == null) {
      DialogMessage.showMessage(
        context: context,
        title: 'Erro',
        message: 'Preencha todos os campos obrigatórios corretamente, incluindo o produto.',
      );
      return;
    }

    try {
      final User? user = await _usersService.getUser();
      if (user == null) throw Exception('Usuário não autenticado');

      await _goalsService.createGoalItem(
        usuarioId: user.uid,
        nome: nome,
        valor: valor,
        unidade: unidade,
        quantidade: quantidade,
        tipo: tipo,
        prazo: dataLimite,
        produto: produto['productId'] ?? '',
      );

      DialogMessage.showMessage(
        context: context,
        title: 'Sucesso',
        message: 'Meta registrada com sucesso!',
      );

      _nameController.clear();
      _valueController.clear();
      _unitController.clear();
      _quantityController.clear(); // NOVO
      _deadlineController.clear();
      _productIdController.clear();
      _productNameController.clear();
      _productSalePrice.clear();

      setState(() {
        _tipoSelecionado = null;
        _produtoSelecionado = null;
        _unidadeSelecionada = null;
      });
    } catch (e) {
      DialogMessage.showMessage(
        context: context,
        title: 'Erro',
        message: 'Erro ao salvar meta: $e',
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final Size sizeScreen = MediaQuery.of(context).size;

    return CoopFarmLayout(
      sizeScreen: sizeScreen,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Cadastrar Meta',
            style: TextStyle(
              fontSize: sizeScreen.width * 0.05,
              fontWeight: FontWeight.bold,
              color: const Color(0xFFD5C1A1),
            ),
          ),
          const SizedBox(height: 16),

          DropdownField(
            sizeScreen: sizeScreen,
            hint: 'Tipo da Meta',
            value: _tipoSelecionado,
            opcoesDeSelecao: _tipoMetaOptions,
            onChanged: (String? value) {
              setState(() => _tipoSelecionado = value);
            },
            dropdownColor: Colors.grey[900],
            fillColor: Colors.transparent,
            textColor: const Color(0xFFD5C1A1),
            borderColor: const Color(0xFF4CAF50),
            iconColor: const Color(0xFFD5C1A1),
            labelColor: const Color(0xFF4CAF50),
          ),

          const SizedBox(height: 10),

          ProductDropdownField(
            sizeScreen: sizeScreen,
            onProdutoSelecionado: (produto) {
              setState(() {
                _produtoSelecionado = produto;
                _productIdController.text = produto?['id'] ?? '';
                _productNameController.text = produto?['productId'] ?? '';
                _unitController.text = produto?['unidade_medida'] ?? '';
                _productSalePrice.text = produto?['preco_venda']?.toString() ?? '';
                _unidadeSelecionada = produto?['unidade_medida'];
              });
            },
          ),

          const SizedBox(height: 10),

          TextFields(
            controller: _nameController,
            sizeScreen: sizeScreen,
            hint: 'Nome da Meta',
            icon: Icons.flag,
            textColor: const Color(0xFFD5C1A1),
            borderColor: const Color(0xFF4CAF50),
            fillColor: Colors.transparent,
            iconColor: const Color(0xFFD5C1A1),
          ),

          const SizedBox(height: 10),

          NumberField(
            controller: _valueController,
            sizeScreen: sizeScreen,
            hint: 'Valor da Meta (R\$)',
            iconColor: const Color(0xFFD5C1A1),
            textColor: const Color(0xFFD5C1A1),
            borderColor: const Color(0xFF4CAF50),
            cursorColor: const Color(0xFF4CAF50),
            fillColor: Colors.transparent,
            labelColor: const Color(0xFF4CAF50),
          ),

          const SizedBox(height: 10),
          Row(
            children: [
              Expanded(
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
              const SizedBox(width: 10),
              Expanded(
                child: NumberField(
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
              ),
            ],
          ),

          const SizedBox(height: 10),

          GestureDetector(
            onTap: _selecionarDataLimite,
            child: AbsorbPointer(
              child: DateField(
                controller: _deadlineController,
                sizeScreen: sizeScreen,
                hint: 'Data Limite',
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
              onPressed: _salvarMeta,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF4CAF50),
                padding: const EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              child: const Text(
                'Cadastrar Meta',
                style: TextStyle(color: Colors.white),
              ),
            ),
          ),
        ],
      ),
    );
  }
}