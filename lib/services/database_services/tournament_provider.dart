import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:peaman/enums/match_type.dart';
import 'package:peaman/enums/update_type.dart';
import 'package:peaman/helpers/dialog_provider.dart';
import 'package:peaman/models/app_models/lobby_notification_model.dart';
import 'package:peaman/models/app_models/team_model.dart';
import 'package:peaman/models/app_models/tournament_model.dart';
import 'package:peaman/models/app_models/tournament_update_model.dart';
import 'package:peaman/models/app_models/user_model.dart';
import 'package:peaman/models/app_models/video_stream_model.dart';
import 'package:peaman/services/database_services/user_provider.dart';
import 'package:peaman/viewmodels/tournament_view_vm.dart';

class TournamentProvider {
  final BuildContext context;
  final Tournament tournament;
  final VideoStream videoStream;
  final AppUser appUser;
  final Team team;
  final int round;
  final int lobby;

  TournamentProvider({
    this.context,
    this.tournament,
    this.videoStream,
    this.appUser,
    this.team,
    this.round = 1,
    this.lobby,
  });

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
      return _tournament;
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
  Future updateTournament({final Map<String, dynamic> data}) async {
    try {
      final _tournamentRef = _ref.collection('tournaments').doc(tournament.id);
      await _tournamentRef.update(data ?? tournament.toJson());
      print('Success: Updating tournament ${tournament.id}');
      return 'Success';
    } catch (e) {
      print(e);
      print('Error!!!: Updating tournament');
      return null;
    }
  }

  // add video streams
  Future addVideoStreams() async {
    try {
      final _videoStreamRef =
          _ref.collection('video_streams').doc(videoStream.id);
      await _videoStreamRef.set(videoStream.toJson());
      print('Success: Adding video stream ${videoStream.id}');
      return videoStream;
    } catch (e) {
      print(e);
      print('Error!!!: Adding video stream');
    }
  }

  // remove video streams
  Future removeVideoStreams() async {
    try {
      final _videoStreamRef =
          _ref.collection('video_streams').doc(videoStream.id);
      await _videoStreamRef.delete();
      print('Success: Adding video stream ${videoStream.id}');
      return videoStream;
    } catch (e) {
      print(e);
      print('Error!!!: Adding video stream');
    }
  }

  // add wildcard
  Future addWildCardTeam(final List<AppUser> users) async {
    try {
      final _tournamentRef = _ref.collection('tournaments').doc(tournament.id);
      final _allUserIds = users.map((e) => e.uid).toList();
      final _teamsRef = _tournamentRef.collection('teams').doc();
      final _team = team.copyWith(
        id: _teamsRef.id,
        userIds: _allUserIds,
        users: users,
        rounds: [
          tournament.activeRound,
        ],
      );
      await _teamsRef.set({
        ..._team.toJson(),
        'team_completed_at': DateTime.now().millisecondsSinceEpoch,
      });
      await _tournamentRef.update({
        'users': FieldValue.arrayUnion(_allUserIds),
        'teams_count': FieldValue.increment(1),
      });
      await sendUpdate(
        _team.id,
        'Admin registered the team in the tournament.',
      );
      return 'Success';
    } catch (e) {
      print(e);
      print('Error!!!: Adding wildcard team');
      return null;
    }
  }

  // register in a tournament
  Future register() async {
    try {
      final _tournamentRef = _ref.collection('tournaments').doc(tournament.id);
      final _teamsRef = _tournamentRef.collection('teams').doc();
      var _team = team.copyWith(
        id: _teamsRef.id,
      );
      final _teamJson = _team.toJson();

      if (tournament.type == MatchType.solo) {
        _teamJson['team_completed_at'] = DateTime.now().millisecondsSinceEpoch;
      }

      await _teamsRef.set(_teamJson);
      await _tournamentRef.update({
        'users': FieldValue.arrayUnion([
          appUser.uid,
        ]),
        'teams_count': FieldValue.increment(1),
      });
      await sendUpdate(
        _team.id,
        '${appUser.name} registered the team in the tournament.',
      );
      await AppUserProvider(uid: appUser.uid).updateUserDetail(
        data: {
          'coins': appUser.coins - tournament.entryCost,
        },
      );
      print('Success: Registering user in tournament ${tournament.id}');
      return _teamsRef;
    } catch (e) {
      print(e);
      print('Error!!!: Registering user in tournament ${tournament.id}');
      return null;
    }
  }

  // get team
  Future<Team> getTeam() async {
    Team _team;
    try {
      final _teamsRef = _ref
          .collection('tournaments')
          .doc(tournament.id)
          .collection('teams')
          .limit(1)
          .where('user_ids', arrayContains: appUser.uid);
      final _teamsSnap = await _teamsRef.get();
      if (_teamsSnap.docs.isNotEmpty) {
        final _teamData = _teamsSnap.docs.first.data();

        if (_teamData != null) {
          _team = Team.fromJson(_teamData);
          print('Success: Getting team');
        }
      }
    } catch (e) {
      print(e);
      print('Error!!!: Getting team');
    }

    return _team;
  }

  // get team by id
  Future<Team> getTeamById(final String id) async {
    Team _team;
    try {
      final _teamsRef = _ref
          .collection('tournaments')
          .doc(tournament.id)
          .collection('teams')
          .doc(id);
      final _teamsSnap = await _teamsRef.get();
      if (_teamsSnap.exists) {
        final _teamData = _teamsSnap.data();

        if (_teamData != null) {
          _team = Team.fromJson(_teamData);
          print('Success: Getting team');
        }
      } else {
        print('Warning: Team not found');
        await DialogProvider(context).showWarningDialog(
          'Team not found !',
          "The team code you have entered is incorrect or the team doesn't exists.",
          () {},
        );
      }
    } catch (e) {
      print(e);
      print('Error!!!: Getting team');
    }

    return _team;
  }

  // join tournament
  Future joinTournament(
    final String teamCode,
    final TournamentViewVm vm,
  ) async {
    try {
      final _team = await getTeamById(teamCode);

      if (_team != null) {
        final _teamFull = _team.users.length >= tournament.getPlayersCount();

        final _assignLobby =
            _team.users.length == (tournament.getPlayersCount() - 1);

        if (!_teamFull) {
          final _tournamentRef =
              _ref.collection('tournaments').doc(tournament.id);
          final _teamRef = _tournamentRef.collection('teams').doc(_team.id);

          await DialogProvider(context).showConfirmationDialog(
            'Are you sure you want to join team "${_team.teamName}" ?',
            () async {
              if (!_team.userIds.contains(appUser.uid)) {
                await _tournamentRef.update({
                  'users': FieldValue.arrayUnion([appUser.uid]),
                });
                if (_assignLobby) {
                  await _teamRef.update({
                    'user_ids': FieldValue.arrayUnion([appUser.uid]),
                    'users': FieldValue.arrayUnion([appUser.toShortJson()]),
                    'team_completed_at': DateTime.now().millisecondsSinceEpoch,
                  });
                } else {
                  await _teamRef.update({
                    'user_ids': FieldValue.arrayUnion([appUser.uid]),
                    'users': FieldValue.arrayUnion([appUser.toShortJson()]),
                  });
                }

                await sendUpdate(
                  _team.id,
                  '${appUser.name} just joined the party.',
                );

                await AppUserProvider(uid: appUser.uid).updateUserDetail(
                  data: {
                    'coins': appUser.coins - tournament.entryCost,
                  },
                );

                final _tournament = vm.thisTournament.copyWith(
                  users: [...vm.thisTournament.users, appUser.uid],
                );
                vm.updateTournament(_tournament);
                vm.updateIsShowingDetails(false);
                vm.getTeam(tournament, appUser);
              }
              print('Sucess: Joining team');
              Navigator.pop(context);
            },
            description: 'This will cost you ${tournament.entryCost} coins.',
          );
          return 'Success';
        } else {
          print('Warning: Team already full');
          await DialogProvider(context).showWarningDialog(
            'Team already full !',
            "Team \"${_team.teamName}\" already has ${_team.users.length} players and it's full.",
            () {},
          );
          return null;
        }
      } else {
        return null;
      }
    } catch (e) {
      print(e);
      print('Error!!!: Joining team');
      return null;
    }
  }

  // send an update to team
  Future sendUpdate(
    final String teamId,
    final String message, {
    final AppUser sender,
    final int lobby,
  }) async {
    try {
      final _updatesRef = _ref
          .collection('tournament_updates')
          .doc(teamId)
          .collection('updates')
          .doc();
      final _update = TournamentUpdate(
        id: _updatesRef.id,
        message: message,
        sender: sender,
        lobby: lobby,
        type: UpdateType.lobby,
        updatedAt: DateTime.now().millisecondsSinceEpoch,
      );
      await _updatesRef.set(_update.toJson());
      print('Success: Sending an update to team $teamId');
      return _update;
    } catch (e) {
      print(e);
      print('Error!!!: Sending an update to team $teamId');
      return null;
    }
  }

  // send a lobby notification
  Future sendLobbyNotification(
    final LobbyNotification lobbyNotification,
  ) async {
    try {
      final _updatesRef = _ref
          .collection('lobby_notifications')
          .doc(lobbyNotification.tournamentId)
          .collection(
            '${lobbyNotification.tournamentId}_${lobbyNotification.lobby}',
          )
          .doc();
      final _lobbyNotif = lobbyNotification.copyWith(id: _updatesRef.id);
      await _updatesRef.set(_lobbyNotif.toJson());
      print(
        'Success: Sending lobby notification to lobby ${_lobbyNotif.lobby}',
      );
      return _lobbyNotif;
    } catch (e) {
      print(e);
      print(
        'Error!!!: Sending lobby notification to lobby ${lobbyNotification.lobby}',
      );
      return null;
    }
  }

  // release room key
  Future releaseRoomKey(final List<String> users, final int lobby) async {
    try {
      final _tournamentRef = _ref.collection('tournaments').doc(tournament.id);
      await _tournamentRef.update({
        'room_keys': tournament.roomKeys,
      });
      print('Success: Releasing room key');
      return 'Success';
    } catch (e) {
      print(e);
      print('Error!!!: Releasing room key');
      return null;
    }
  }

  // add data to trigger
  Future trigger(
    final DocumentReference ref,
    final Map<String, dynamic> data,
  ) async {
    try {
      await ref.set({
        ...data,
        'updated_at': DateTime.now().millisecondsSinceEpoch,
      });
      print('Success: Adding $data to ${ref.path}');
      return 'Success';
    } catch (e) {
      print(e);
      print('Error: Adding $data to ${ref.path}');
      return null;
    }
  }

  // select winners when the tournament ends
  Future selectLobbyWinners(
      final List<Team> winners, final List<Team> losers) async {
    try {
      final _tournamentRef = _ref.collection('tournaments').doc(tournament.id);
      var _winnerIds = <String>[];
      var _loserIds = <String>[];

      for (int i = 0; i < winners.length; i++) {
        final _team = winners[i];
        _winnerIds += _team.userIds;

        final _teamRef = _tournamentRef.collection('teams').doc(_team.id);
        await _teamRef.update({
          'rounds': FieldValue.arrayUnion([tournament.activeRound + 1]),
        });

        await sendUpdate(
          _team.id,
          'Congrats! Your team has won round ${tournament.activeRound} and have qualified for round ${tournament.activeRound + 1}',
        );

        print(
          'Success: Sending team ${_team.teamName} to round ${tournament.activeRound + 1}',
        );
      }

      for (int i = 0; i < losers.length; i++) {
        final _team = losers[i];
        _loserIds += _team.userIds;

        await sendUpdate(
          _team.id,
          'Sorry! Your team has lost round ${tournament.activeRound}. Please try next time',
        );
      }

      final _roundWinLoseTriggersRef =
          _ref.collection('round_win_lose_triggers').doc();

      final roundWinLoseData = {
        'id': _roundWinLoseTriggersRef.id,
        'tournament_id': tournament.id,
        'updated_at': DateTime.now().millisecondsSinceEpoch,
        'winners': _winnerIds,
        'losers': _loserIds,
      };

      await trigger(
        _roundWinLoseTriggersRef,
        roundWinLoseData,
      );

      return 'Success';
    } catch (e) {
      print(e);
      print(
        'Error!!!: Sending teams to next round',
      );
    }
  }

  // get list of tournaments from firestore
  List<Tournament> _tournamentsFromFirestore(final QuerySnapshot colSnap) {
    return colSnap.docs.map((e) => Tournament.fromJson(e.data())).toList();
  }

  // get list of videostreams from firestore
  List<VideoStream> _videoStreamsFromFirestore(final QuerySnapshot colSnap) {
    return colSnap.docs.map((e) => VideoStream.fromJson(e.data())).toList();
  }

  // get list of updates from firebase
  List<TournamentUpdate> _updatesFromFirebase(final QuerySnapshot colSnap) {
    return colSnap.docs
        .map((e) => TournamentUpdate.fromJson(e.data()))
        .toList();
  }

  // get list of lobby notifications from firebase
  List<LobbyNotification> _lobbyNotificationFromFirebase(
    final QuerySnapshot colSnap,
  ) {
    return colSnap.docs
        .map((e) => LobbyNotification.fromJson(e.data()))
        .toList();
  }

  // get list of tournament teams
  List<Team> _tournamentTeamsFromFirebase(final QuerySnapshot colSnap) {
    return colSnap.docs.map((e) => Team.fromJson(e.data())).toList();
  }

  // stream of list of tournaments
  Stream<List<Tournament>> get tournamentsList {
    return _ref
        .collection('tournaments')
        .orderBy('date')
        .snapshots()
        .map(_tournamentsFromFirestore);
  }

  // stream of list of tournaments
  Stream<List<VideoStream>> get videoStreamsList {
    return _ref
        .collection('video_streams')
        .snapshots()
        .map(_videoStreamsFromFirestore);
  }

  // stream of list of tournament updates
  Stream<List<TournamentUpdate>> get tournamentUpdatesList {
    return _ref
        .collection('tournament_updates')
        .doc(team.id)
        .collection('updates')
        .orderBy('updated_at', descending: true)
        .snapshots()
        .map(_updatesFromFirebase);
  }

  // stream of list of lobby notifications
  Stream<List<LobbyNotification>> get lobbyNotificationsList {
    return _ref
        .collection('lobby_notifications')
        .doc(tournament.id)
        .collection('${tournament.id}_$lobby')
        .orderBy('updated_at', descending: true)
        .snapshots()
        .map(_lobbyNotificationFromFirebase);
  }

  // stream of list of tournament teams
  Stream<List<Team>> get tournamentTeamsList {
    return _ref
        .collection('tournaments')
        .doc(tournament.id)
        .collection('teams')
        .orderBy('team_completed_at')
        .where('rounds', arrayContains: round)
        .snapshots()
        .map(_tournamentTeamsFromFirebase);
  }
}
