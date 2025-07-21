import 'package:coop_farm/services/firebase/products/products_firebase.dart';
import 'package:flutter/material.dart';
import '../../componentes/coop_farm_base.dart';
import '../../services/firebase/goals/goals_firebase.dart';
import '../../services/firebase/production/production_firebase.dart';
import '../../services/firebase/sales/sales_firebase.dart';
import '../../services/firebase/users/user_firebase.dart';
import '../../utils/user_auth_checker.dart';

class ListGoalsScreen extends StatefulWidget {
  const ListGoalsScreen({super.key});

  @override
  State<ListGoalsScreen> createState() => _ListGoalsScreenState();
}

class _ListGoalsScreenState extends State<ListGoalsScreen> {
  final GoalsFirebaseService _goalsFirebaseService = GoalsFirebaseService();
  final UsersFirebaseService _usersFirebaseService = UsersFirebaseService();
  final ProductsFirebaseService _productsFirebaseService = ProductsFirebaseService();
  final SalesFirebaseService _salesFirebaseService = SalesFirebaseService();
  final ProductionFirebaseService _productionFirebaseService = ProductionFirebaseService();

  List<Map<String, dynamic>> _metas = [];
  bool _userChecked = false;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _checkUser();
  }

  void _checkUser() {
    UserAuthChecker.check(
      context: context,
      onAuthenticated: () async {
        await _loadMetas();
        setState(() => _userChecked = true);
      },
    );
  }

  Future<void> _loadMetas() async {
    final metas = await _goalsFirebaseService.getGoalItems();

    for (var meta in metas) {
      final nomeProduto = await _productsFirebaseService.getProductsProps(meta['produto'], 'nome');
      meta['nome_produto'] = nomeProduto ?? '';

      // dynamic valorAtual;

      // if (meta['tipo'] == 'Venda') {
      //   valorAtual = await _salesFirebaseService.getSalesProps(meta['produto'], 'valor');
      // } else {
      //   valorAtual = await _productionFirebaseService.getProductionProps(meta['produto'], 'quantidade');
      // }

      meta['valor_atual'] = double.tryParse( meta['valor_atual']?.toString() ?? '0') ?? 0.0;
      meta['valor'] = double.tryParse(meta['valor']?.toString() ?? '0') ?? 0.0;
      meta['quantidade'] = double.tryParse(meta['quantidade']?.toString() ?? '0') ?? 0.0;
    }

    setState(() {
      _metas = metas;
      _isLoading = false;
    });
  }

  Color _getStatusColor(Map<String, dynamic> meta) {
    final double valorAtual = meta['valor_atual'] ?? 0.0;
    final double metaAlvo = meta['tipo'] == 'Venda'
        ? (meta['valor'] ?? 0.0)
        : (meta['quantidade'] ?? 0.0);

    if (valorAtual >= metaAlvo) {
      return Colors.green;
    } else if (valorAtual > 0) {
      return Colors.orange;
    } else {
      return Colors.red;
    }
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
            'Metas Cadastradas',
            style: TextStyle(
              fontSize: sizeScreen.width * 0.05,
              fontWeight: FontWeight.bold,
              color: const Color(0xFFD5C1A1),
            ),
          ),
          const SizedBox(height: 16),
          Expanded(
            child: ListView.builder(
              itemCount: _metas.length,
              itemBuilder: (context, index) {
                final meta = _metas[index];
                final tipo = meta['tipo'] ?? '';
                final produto = meta['nome_produto'] ?? '';
                final unidade = meta['unidade'] ?? '';
                final prazo = meta['prazo'] ?? '';
                final atual = meta['valor_atual']?.toStringAsFixed(2) ?? '0.00';

                final metaAlvo = meta['tipo'] == 'Venda'
                    ? "R\$${(meta['valor'] ?? 0.0).toStringAsFixed(2)}"
                    : "${(meta['quantidade'] ?? 0.0).toStringAsFixed(2)} ${meta['unidade'] ?? ''}";

                return Card(
                  margin: const EdgeInsets.symmetric(vertical: 8),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                    side: BorderSide(color: _getStatusColor(meta), width: 2),
                  ),
                  color: Colors.grey[850],
                  child: ListTile(
                    title: Text(
                      '$tipo: $produto',
                      style: const TextStyle(color: Colors.white),
                    ),
                    subtitle: Text(
                      'Meta: $metaAlvo | Atual: $atual\nPrazo: $prazo',
                      style: const TextStyle(color: Colors.white70),
                    ),
                    trailing: Icon(
                      Icons.flag,
                      color: _getStatusColor(meta),
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
