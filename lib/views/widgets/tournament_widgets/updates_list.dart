import 'package:flutter/material.dart';
import 'package:peaman/models/app_models/team_model.dart';
import 'package:peaman/models/app_models/tournament_update_model.dart';
import 'package:peaman/services/database_services/tournament_provider.dart';
import 'package:peaman/views/widgets/tournament_widgets/updates_list_item.dart';

class UpdatesList extends StatelessWidget {
  final Team team;
  UpdatesList(this.team);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _titleBuilder(),
          team == null ? _emptyUpdatesBuilder() : _updatesListBuilder(),
        ],
      ),
    );
  }

  Widget _titleBuilder() {
    return Row(
      children: [
        Text(
          'UPDATES',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 16.0,
          ),
        ),
      ],
    );
  }

  Widget _updatesListBuilder() {
    return StreamBuilder<List<TournamentUpdate>>(
      stream: TournamentProvider(team: team).tournamentUpdatesList,
      builder: (context, snap) {
        if (snap.hasData) {
          final _list = snap.data ?? [];
          return _list.isEmpty
              ? _emptyUpdatesBuilder()
              : ListView.separated(
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  itemCount: _list.length,
                  itemBuilder: (context, index) {
                    return UpdatesListItem(_list[index]);
                  },
                  separatorBuilder: (context, index) {
                    return Center(
                      child: Container(
                        height: 20.0,
                        width: 4.0,
                        color: Colors.grey,
                      ),
                    );
                  },
                );
        }
        return Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                height: 100.0,
              ),
              CircularProgressIndicator(),
            ],
          ),
        );
      },
    );
  }

  Widget _emptyUpdatesBuilder() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(
            height: 100.0,
          ),
          Text(
            'No updates to show',
            style: TextStyle(
              fontStyle: FontStyle.italic,
            ),
          ),
        ],
      ),
    );
  }
}
