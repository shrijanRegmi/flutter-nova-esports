import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:peaman/models/app_models/tournament_model.dart';

class TournamentProvider {
  final Tournament tournament;
  TournamentProvider({this.tournament});

  final _ref = FirebaseFirestore.instance;

  // create tournament
  Future createTournament() async {
    try {
      final _tournamentRef = _ref.collection('tournaments').doc();
      final _tournament = tournament.copyWith(
        id: _tournamentRef.id,
      );
      await _tournamentRef.set(_tournament.toJson());
      print('Success: Creating tournament ${_tournament.id}');
      return 'Success';
    } catch (e) {
      print(e);
      print('Error!!!: Creating tournament');
      return null;
    }
  }

  // delete tournament
  Future deleteTournament() async {
    try {
      final _tournamentRef = _ref.collection('tournaments').doc(tournament.id);
      await _tournamentRef.delete();
      print('Success: Deleting tournament ${tournament.id}');
      return 'Success';
    } catch (e) {
      print(e);
      print('Error!!!: Deleting tournament');
      return null;
    }
  }

  // update tournament
  Future updateTournament() async {
    try {
      final _tournamentRef = _ref.collection('tournaments').doc(tournament.id);
      await _tournamentRef.update(tournament.toJson());
      print('Success: Updating tournament ${tournament.id}');
      return 'Success';
    } catch (e) {
      print(e);
      print('Error!!!: Updating tournament');
      return null;
    }
  }

  // get list of tournaments from firestore
  List<Tournament> _tournamentsFromFirestore(final QuerySnapshot colSnap) {
    return colSnap.docs.map((e) => Tournament.fromJson(e.data())).toList();
  }

  // stream of list of tournaments
  Stream<List<Tournament>> get tournamentsList {
    return _ref
        .collection('tournaments')
        .orderBy('date')
        .snapshots()
        .map(_tournamentsFromFirestore);
  }
}
