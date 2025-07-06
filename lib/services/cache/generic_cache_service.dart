// generic_shared_cache_service.dart
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

abstract class GenericSharedCacheService {
  final String cacheKey;

  GenericSharedCacheService(this.cacheKey);

  Future<void> save(List<Map<String, dynamic>> items) async {
    final prefs = await SharedPreferences.getInstance();
    List<String> itemsJson = items.map((item) => json.encode(item)).toList();
    await prefs.setStringList(cacheKey, itemsJson);
  }

  Future<List<Map<String, dynamic>>> get() async {
    final prefs = await SharedPreferences.getInstance();
    List<String>? itemsJson = prefs.getStringList(cacheKey);

    if (itemsJson != null) {
      return itemsJson.map((item) => json.decode(item) as Map<String, dynamic>).toList();
    }
    return [];
  }

  Future<void> clear() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(cacheKey);
  }
}
