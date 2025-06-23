import 'package:firebase_database/firebase_database.dart';

class FirebaseServiceGeneric {

  final DatabaseReference _database = FirebaseDatabase.instance.ref();


  DatabaseReference getReference() {
    return _database;
  }

  Future<void> create(String path, Map<String, dynamic> data) async {
    await _database.child(path).push().set(data);
  }

  Future<void> update(String path, String id, Map<String, dynamic> data) async {
    await _database.child('$path/$id').update(data);
  }

  Future<void> delete(String path, String id) async {
    await _database.child('$path/$id').remove();
  }

  Future<DatabaseEvent> fetch(String path) async {
    return await _database.child(path).once();
  }

  Future<List<Map<String, dynamic>>> getWhere(String path, String field, String value) async {
    final snapshot = await _database.child(path).orderByChild(field).equalTo(value).once();

    final List<Map<String, dynamic>> result = [];
    if (snapshot.snapshot.value != null) {
      final data = Map<String, dynamic>.from(snapshot.snapshot.value as Map);
      data.forEach((key, value) {
        final item = Map<String, dynamic>.from(value);
        item['id'] = key;
        result.add(item);
      });
    }

    return result;
  }
}
