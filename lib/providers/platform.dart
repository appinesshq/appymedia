import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/platform.dart';

class PlatformProvider {
  final _collection = FirebaseFirestore.instance.collection('platforms');

  List<Platform> _platforms = [];
  Platform _platform;

  Future<Platform> create(Platform platform) async {
    final res = await _collection.add(platform.toMap());
    platform.id = res.id;
    return platform;
  }

  Future<Platform> read(String id) async {
    final res = await _collection.doc(id).get();

    if (res == null) throw 'Not found';

    return Platform.fromMap(res.data(), id: res.id);
  }

  Future<List<Platform>> fetch() async {
    final res = await _collection.get();
    List<Platform> p = [];
    res.docs.forEach((element) {
      p.add(Platform.fromMap(element.data(), id: element.id));
    });
    return p;
  }

  Future<void> update(Platform platform) async {
    final o = await read(platform.id);
    final old = o.toMap();

    _collection.doc(platform.id).update(platform.toMap().map((k, v) {
          if (k == 'id') return null;
          if (old[k] != v) return v;
        }));
  }

  Future<void> delete(Platform platform) async {
    return _collection.doc(platform.id).delete();
  }
}
