import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';

import '../../cache/products/product_cache_service.dart';
import '../firebase.dart';
import '../users/user_firebase.dart';

class ProductsFirebaseService {
  final FirebaseServiceGeneric _firebaseService = FirebaseServiceGeneric();
  final ProductCacheService _cacheService = ProductCacheService();
  final UsersFirebaseService _usersService = UsersFirebaseService();

  String _lastProductId = "";
  int startAt = 0;
  int endAt = 7;
  bool executeSublist = false;

  Future<void> createProduct({
    required String nome,
    required double precoCusto,
    required double precoVenda,
    required double lucro,
    required double percentualLucro,
    required String unidadeMedida,
    required double quantidadeDisponivel,
  }) async {
    try {
      final User? user = await _usersService.getUser();
      if (user == null) throw Exception('Nenhum usuário autenticado');

      final String userId = user.uid;

      await _firebaseService.create('products', {
        'usuario_id': userId,
        'nome': nome,
        'preco_custo': precoCusto,
        'preco_venda': precoVenda,
        'lucro': lucro,
        'percentual_lucro': percentualLucro,
        'unidade_medida': unidadeMedida,
        'quantidade_disponivel': quantidadeDisponivel,
      });

      await _cacheService.clearCache();

      final List<Map<String, dynamic>> products = await getProductsPagination(
        userId,
        lastProductId: _lastProductId,
      );

      await _cacheService.saveProducts(products);
    } catch (e) {
      throw Exception('Erro ao criar produto: $e');
    }
  }

  Future<List<Map<String, dynamic>>> getProducts(String usuarioId) async {
    final DatabaseEvent snapshot = await _firebaseService.fetch('products');
    List<Map<String, dynamic>> products = [];

    if (snapshot.snapshot.value != null) {
      final Map<dynamic, dynamic> dados = snapshot.snapshot.value as Map;

      dados.forEach((key, value) {
        if (value['usuario_id'] == usuarioId) {
          products.add({
            'productId': key,
            'nome': value['nome'],
            'preco_custo': value['preco_custo'],
            'preco_venda': value['preco_venda'],
            'lucro': value['lucro'],
            'percentual_lucro': value['percentual_lucro'],
            'unidade_medida': value['unidade_medida'],
            'quantidade_disponivel': value['quantidade_disponivel'],
          });
        }
      });

      products.sort((a, b) => a['nome'].toString().compareTo(b['nome'].toString()));
    }

    return products;
  }

  Future<void> updateProduct(
      String productId,
      Map<String, dynamic> data,
      List<Map<String, dynamic>> products,
      ) async {
    await _firebaseService.update('products', productId, data);

    final int index = products.indexWhere((p) => p['productId'] == productId);
    if (index != -1) {
      products[index] = {...data, 'productId': productId};
      await _cacheService.saveProducts(products);
    }
  }

  Future<void> deleteProduct(
      String productId,
      List<Map<String, dynamic>> products,
      ) async {
    await _firebaseService.delete('products', productId);
    products.removeWhere((p) => p['productId'] == productId);
    await _cacheService.saveProducts(products);
  }

  Future<List<Map<String, dynamic>>> getProductsFiltered({
    String? nome,
    double? precoCusto,
    double? precoVenda,
    double? percentualLucro,
  }) async {
    final User? user = await _usersService.getUser();
    if (user == null) throw Exception('Usuário não autenticado');

    List<Map<String, dynamic>> products = await getProducts(user.uid);

    if (nome != null) {
      products = products
          .where((p) => p['nome'].toString().toLowerCase().contains(nome.toLowerCase()))
          .toList();
    }
    if (precoCusto != null) {
      products = products.where((p) => p['preco_custo'] == precoCusto).toList();
    }
    if (precoVenda != null) {
      products = products.where((p) => p['preco_venda'] == precoVenda).toList();
    }
    if (percentualLucro != null) {
      products = products.where((p) => p['percentual_lucro'] == percentualLucro).toList();
    }

    return products;
  }

  Future<List<Map<String, dynamic>>> getProductsPagination(
      String usuarioId, {
        String? lastProductId,
      }) async {
    try {
      if (!executeSublist && startAt > 0) return [];

      List<Map<String, dynamic>> products = await getProducts(usuarioId);

      if (lastProductId != null && lastProductId != _lastProductId) {
        _lastProductId = lastProductId;
        startAt += 7;
        endAt += 7;
      }

      if (executeSublist && startAt < products.length) {
        products = products.sublist(startAt, endAt.clamp(0, products.length));
      }

      return products;
    } catch (e) {
      print('Erro na paginação de produtos: $e');
      return [];
    }
  }
}
