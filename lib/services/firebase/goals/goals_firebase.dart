import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import '../firebase.dart';
import '../users/user_firebase.dart';
import '../../cache/goals/goals_cache_service.dart';

class GoalsFirebaseService {
  final FirebaseServiceGeneric _firebaseService = FirebaseServiceGeneric();
  final UsersFirebaseService _usersService = UsersFirebaseService();
  final GoalsCacheService _cacheService = GoalsCacheService();

  Future<void> createGoalItem({
    required String tipo,
    required String produto,
    required double valor,
    required String unidade,
    required double quantidade,
    required String prazo,
    required String usuarioId,
    required String nome,
  }) async {
    try {
      final User? user = await _usersService.getUser();
      if (user == null) throw Exception('Nenhum usuário autenticado');

      await _firebaseService.create('goals', {
        'usuario_id': user.uid,
        'tipo': tipo,
        'produto': produto,
        'valor': valor,
        'valor_atual': 0,
        'unidade': unidade,
        'quantidade': quantidade,
        'prazo': prazo,
        'timestamp': DateTime.now().toIso8601String(),
      });

      await _cacheService.clear();
    } catch (e) {
      throw Exception('Erro ao criar meta: $e');
    }
  }

  Future<List<Map<String, dynamic>>> getGoalItems([String? productId]) async {

    List<Map<String, dynamic>> metas = await _cacheService.get();

    if (metas.isEmpty) {
      final DatabaseEvent snapshot = await _firebaseService.fetch('goals');
      metas = [];

      if (snapshot.snapshot.value != null) {
        final Map<dynamic, dynamic> dados = snapshot.snapshot.value as Map;

        dados.forEach((key, value) {
          if (productId == null || value['produto'] == productId) {
            metas.add({
              'id': key,
              'tipo': value['tipo'],
              'produto': value['produto'],
              'valor': value['valor'],
              'valor_atual': value['valor_atual'],
              'unidade': value['unidade'],
              'prazo': value['prazo'],
              'timestamp': value['timestamp'],
            });
          }
        });

        metas.sort((a, b) => b['timestamp'].toString().compareTo(a['timestamp'].toString()));
        await _cacheService.save(metas);
      }
    }

    return metas;
  }

  Future<void> updateGoalItem(String id, Map<String, dynamic> data) async {
    await _firebaseService.update('goals', id, data);
    await _cacheService.clear();
  }

  Future<void> deleteGoalItem(String id) async {
    await _firebaseService.delete('goals', id);
    await _cacheService.clear();
  }

  Future<void> incrementGoalProgress({
    required String produto,
    required double quantidade,
    required String tipo,
  }) async {
    final User? user = await _usersService.getUser();
    if (user == null) throw Exception('Usuário não autenticado');

    final metas = await getGoalItems(user.uid);
    for (final meta in metas) {
      if (meta['produto'] == produto && meta['tipo'] == tipo) {
        final novoValor = (meta['valor_atual'] ?? 0) + quantidade;
        await updateGoalItem(meta['id'], {'valor_atual': novoValor});
      }
    }
  }
}
