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
}
