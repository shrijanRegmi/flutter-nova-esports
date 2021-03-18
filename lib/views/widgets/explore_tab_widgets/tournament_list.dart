import 'package:flutter/material.dart';
import 'package:peaman/models/app_models/tournament_model.dart';
import 'package:peaman/views/widgets/explore_tab_widgets/tournament_list_item.dart';

class TournamentList extends StatelessWidget {
  final List<Tournament> tournaments;
  final bool requiredTitle;
  final bool isHorizontal;
  TournamentList(
    this.tournaments, {
    this.requiredTitle = true,
    this.isHorizontal = false,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        if (requiredTitle) _titleBuilder(),
        SizedBox(
          height: 10.0,
        ),
        Container(
          height: isHorizontal ? 300.0 : null,
          child: ListView.builder(
            shrinkWrap: isHorizontal ? false : true,
            scrollDirection: isHorizontal ? Axis.horizontal : Axis.vertical,
            physics: isHorizontal ? null : NeverScrollableScrollPhysics(),
            itemCount: tournaments.length,
            itemBuilder: (context, index) {
              return TournamentListItem(tournaments[index]);
            },
          ),
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
