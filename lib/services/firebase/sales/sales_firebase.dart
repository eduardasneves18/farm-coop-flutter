import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:intl/intl.dart';

import '../../cache/products/product_cache_service.dart';
import '../firebase.dart';
import '../users/user_firebase.dart';

class SalesFirebaseService {
  final FirebaseServiceGeneric _firebaseService = FirebaseServiceGeneric();
  final ProductCacheService _cacheService = ProductCacheService();
  final UsersFirebaseService _usersService = UsersFirebaseService();

  String _lastSaleId = "";
  int startAt = 0;
  int endAt = 7;
  bool executeSublist = false;

  Future<void> createSale({
    required String productId,
    required String productName,
    required String description,
    required double quantity,
    required double value,
    required String unit,
    required String clientName,
    String? paymentMethod,
  }) async {
    try {
      final User? user = await _usersService.getUser();
      if (user == null) throw Exception('Nenhum usuário autenticado');

      final String userId = user.uid;
      final String date = DateFormat("yyyy-MM-dd HH:mm").format(DateTime.now());

      await _firebaseService.create('sales', {
        'usuario_id': userId,
        'product_id': productId,
        'product_name': productName,
        'description': description,
        'quantity': quantity,
        'value': value,
        'unit': unit,
        'client_name': clientName,
        'payment_method': paymentMethod ?? 'Não informado',
        'date': date,
      });

      await _cacheService.clearCache();

      final List<Map<String, dynamic>> sales = await getSalesPagination(
        userId,
        lastSaleId: _lastSaleId,
      );

      await _cacheService.saveProducts(sales);
    } catch (e) {
      throw Exception('Erro ao registrar venda: $e');
    }
  }

  Future<List<Map<String, dynamic>>> getSales(String usuarioId) async {
    final DatabaseEvent snapshot = await _firebaseService.fetch('sales');
    List<Map<String, dynamic>> sales = [];

    if (snapshot.snapshot.value != null) {
      final Map<dynamic, dynamic> dados = snapshot.snapshot.value as Map;

      dados.forEach((key, value) {
        if (value['usuario_id'] == usuarioId) {
          sales.add({
            'saleId': key,
            'product_id': value['product_id'],
            'product_name': value['product_name'],
            'description': value['description'],
            'quantity': value['quantity'],
            'value': value['value'],
            'unit': value['unit'],
            'client_name': value['client_name'],
            'payment_method': value['payment_method'],
            'date': value['date'],
          });
        }
      });

      sales.sort((a, b) => b['date'].compareTo(a['date']));
    }

    return sales;
  }

  Future<void> updateSale(
      String saleId,
      Map<String, dynamic> data,
      List<Map<String, dynamic>> sales,
      ) async {
    await _firebaseService.update('sales', saleId, data);

    final int index = sales.indexWhere((s) => s['saleId'] == saleId);
    if (index != -1) {
      sales[index] = {...data, 'saleId': saleId};
      await _cacheService.saveProducts(sales);
    }
  }

  Future<void> deleteSale(
      String saleId,
      List<Map<String, dynamic>> sales,
      ) async {
    await _firebaseService.delete('sales', saleId);
    sales.removeWhere((s) => s['saleId'] == saleId);
    await _cacheService.saveProducts(sales);
  }

  Future<List<Map<String, dynamic>>> getSalesPagination(
      String usuarioId, {
        String? lastSaleId,
      }) async {
    try {
      if (!executeSublist && startAt > 0) return [];

      List<Map<String, dynamic>> sales = await getSales(usuarioId);

      if (lastSaleId != null && lastSaleId != _lastSaleId) {
        _lastSaleId = lastSaleId;
        startAt += 7;
        endAt += 7;
      }

      if (executeSublist && startAt < sales.length) {
        sales = sales.sublist(startAt, endAt.clamp(0, sales.length));
      }

      return sales;
    } catch (e) {
      print('Erro na paginação de vendas: $e');
      return [];
    }
  }
}
