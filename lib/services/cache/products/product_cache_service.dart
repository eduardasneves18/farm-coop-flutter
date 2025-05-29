class ProductCacheService {
  List<Map<String, dynamic>>? _productsCache;

  Future<void> saveProducts(List<Map<String, dynamic>> products) async {
    _productsCache = List<Map<String, dynamic>>.from(products);
  }

  Future<List<Map<String, dynamic>>> getProducts() async {
    return _productsCache ?? [];
  }

  Future<void> clearCache() async {
    _productsCache = null;
  }
}
