import 'package:flutter/material.dart';
import 'package:peaman/models/app_models/tournament_model.dart';
import 'package:peaman/viewmodels/tournament_view_vm.dart';

class JoinTeam extends StatelessWidget {
  final Tournament tournament;
  final TournamentViewVm vm;
  JoinTeam(this.tournament, this.vm);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      child: Column(
        children: [
          _shareLinkBuilder(),
        ],
      ),
    );
  }

  Widget _shareLinkBuilder() {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10.0),
        color: Colors.white,
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
        child: vm.team == null
            ? Center(
                child: CircularProgressIndicator(),
              )
            : Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'TEAM CODE',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 10.0,
                          color: Colors.grey,
                        ),
                      ),
                      SizedBox(
                        height: 5.0,
                      ),
                      Text(
                        '${vm.team.id}',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 12.0,
                        ),
                      ),
                    ],
                  ),
                  MaterialButton(
                    onPressed: vm.shareTeamCode,
                    color: Colors.blue,
                    child: Text(
                      'Share Code',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ],
              ),
      ),
    );
  }
}
