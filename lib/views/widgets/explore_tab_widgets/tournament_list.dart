import 'package:flutter/material.dart';
import 'package:peaman/models/app_models/tournament_model.dart';
import 'package:peaman/views/widgets/explore_tab_widgets/tournament_list_item.dart';

class TournamentList extends StatelessWidget {
  final List<Tournament> tournaments;
  TournamentList(this.tournaments);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _titleBuilder(),
        SizedBox(
          height: 10.0,
        ),
        ListView.builder(
          shrinkWrap: true,
          physics: NeverScrollableScrollPhysics(),
          itemCount: tournaments.length,
          itemBuilder: (context, index) {
            return TournamentListItem(tournaments[index]);
          },
        ),
      ],
    );
  }

  Widget _titleBuilder() {
    return Row(
      children: [
        SizedBox(
          width: 20.0,
        ),
        Text(
          'Tournaments',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 18.0,
            color: Color(0xff3D4A5A),
          ),
        ),
      ],
    );
  }
}
