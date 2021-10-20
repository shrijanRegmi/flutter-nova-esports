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

  // delete level
  Future deleteLevel() async {
    try {
      final _levelRef = _ref.collection('levels').doc(level.id);

      await _levelRef.delete();
      await _updateOtherLevels(level.level, increment: false);

      print('Success: Deleting level ${level.id}');
      return 'Success';
    } catch (e) {
      print(e);
      print('Error!!!: Deleting level ${level.id}');
    }
  }

  // update level
  Future updateLevel() async {
    try {
      final _levelRef = _ref.collection('levels').doc(level.id);

      await _levelRef.update(level.toJson());
      print('Success: Updating level ${level.id}');
      return 'Success';
    } catch (e) {
      print(e);
      print('Error!!!: Updating level ${level.id}');
    }
  }

  // update other levels
  Future _updateOtherLevels(
    final int level, {
    final bool increment = true,
  }) async {
    try {
      Query _levelsRef;

      if (increment) {
        _levelsRef = _ref
            .collection('levels')
            .orderBy('level')
            .where('level', isLessThan: level);
      } else {
        _levelsRef = _ref
            .collection('levels')
            .orderBy('level')
            .where('level', isGreaterThan: level);
      }
      final _levelsSnap = await _levelsRef.get();
      for (final _levelSnap in _levelsSnap.docs) {
        final _data = _levelSnap.data();
        if (_data != null) {
          var _level = Level.fromJson(_data);
          _level = _level.copyWith(
            level: increment
                ? _level.level + 1
                : _level.level > 1
                    ? _level.level - 1
                    : 1,
            updatedAt: DateTime.now().millisecondsSinceEpoch,
          );

          await _levelSnap.reference.update(_level.toJson());
          print('Success: Updating other levels');
        }
      }
    } catch (e) {
      print(e);
      print('Error!!!: Updating other levels');
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
