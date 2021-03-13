import 'package:flutter/material.dart';
import 'package:peaman/models/app_models/tournament_update_model.dart';

class UpdatesListItem extends StatelessWidget {
  final TournamentUpdate update;
  UpdatesListItem(this.update);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10.0),
        color: Colors.white,
      ),
      padding: const EdgeInsets.all(20.0),
      child: Row(
        children: [
          Icon(
            Icons.campaign,
            color: Colors.grey,
          ),
          SizedBox(
            width: 20.0,
          ),
          Expanded(
            child: Text(
              '${update.message}',
            ),
          ),
        ],
      ),
    );
  }
}
