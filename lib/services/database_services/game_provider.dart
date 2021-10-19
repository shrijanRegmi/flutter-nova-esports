import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:peaman/models/app_models/level_model.dart';

class GameProvider {
  final Level level;
  GameProvider({this.level});
  final _ref = FirebaseFirestore.instance;

  // create level
  Future<Level> createLevel() async {
    try {
      final _levelRef = _ref.collection('levels').doc();
      final _level = level.copyWith(id: _levelRef.id);

      await _levelRef.set(_level.toJson());
      print('Success!!!: Creating level ${_level.id}');
      return _level;
    } catch (e) {
      print(e);
      print('Error!!!: Creating level');
      return null;
    }
  }

  // levels from firebase
  List<Level> _levelsFromFirebase(final QuerySnapshot snap) {
    return snap.docs.map((e) => Level.fromJson(e.data())).toList();
  }

  // stream of levels from firebase
  Stream<List<Level>> get levelsList {
    return _ref
        .collection('levels')
        .orderBy('level')
        .snapshots()
        .map(_levelsFromFirebase);
  }
}
