import 'package:flutter/material.dart';
import 'package:peaman/models/app_models/tournament_model.dart';
import 'package:peaman/views/widgets/explore_tab_widgets/tournament_list.dart';

class LiveTournamentList extends StatelessWidget {
  final List<Tournament> tournaments;
  LiveTournamentList(this.tournaments);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _titleBuilder(),
        SizedBox(
          height: 10.0,
        ),
        TournamentList(
          tournaments,
          isHorizontal: true,
          requiredTitle: false,
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
          'Live Tournaments',
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
