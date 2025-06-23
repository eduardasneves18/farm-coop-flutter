import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';

import '../firebase.dart';
import '../users/user_firebase.dart';

class ProductionFirebaseService {
  final FirebaseServiceGeneric _firebaseService = FirebaseServiceGeneric();
  final UsersFirebaseService _usersService = UsersFirebaseService();

  Future<void> createProductionItem({
    required String produto,
    required double quantidade,
    required String unidadeMedida,
    required String status,
    required String dataEstimadaColheita,
  }) async {
    try {
      final User? user = await _usersService.getUser();
      if (user == null) throw Exception('Nenhum usuário autenticado');

      await _firebaseService.create('production', {
        'usuario_id': user.uid,
        'produto': produto,
        'quantidade': quantidade,
        'unidade_medida': unidadeMedida,
        'status': status,
        'data_estimativa_colheita': dataEstimadaColheita,
        'timestamp': DateTime.now().toIso8601String(),
      });
    } catch (e) {
      throw Exception('Erro ao criar item de produção: $e');
    }
  }

  Future<List<Map<String, dynamic>>> getProductionItems(String usuarioId) async {
    final DatabaseEvent snapshot = await _firebaseService.fetch('production');
    List<Map<String, dynamic>> items = [];

    if (snapshot.snapshot.value != null) {
      final Map<dynamic, dynamic> dados = snapshot.snapshot.value as Map;

      dados.forEach((key, value) {
        if (value['usuario_id'] == usuarioId) {
          items.add({
            'id': key,
            'produto': value['produto'],
            'quantidade': value['quantidade'],
            'unidade_medida': value['unidade_medida'],
            'status': value['status'],
            'data_estimativa_colheita': value['data_estimativa_colheita'],
            'timestamp': value['timestamp'],
          });
        }
      });

      // Ordena por data mais recente
      items.sort((a, b) =>
          b['timestamp'].toString().compareTo(a['timestamp'].toString()));
    }

    return items;
  }

  Future<void> updateProductionItem(String id, Map<String, dynamic> data) async {
    await _firebaseService.update('production', id, data);
  }

  Future<void> deleteProductionItem(String id) async {
    await _firebaseService.delete('production', id);
  }

  Future<List<Map<String, dynamic>>> filterByStatus(String status) async {
    final User? user = await _usersService.getUser();
    if (user == null) throw Exception('Usuário não autenticado');

    List<Map<String, dynamic>> all = await getProductionItems(user.uid);
    return all.where((item) => item['status'] == status).toList();
  }

}
