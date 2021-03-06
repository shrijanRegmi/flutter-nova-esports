import 'package:flutter/material.dart';
import 'package:peaman/views/widgets/matchup_widgets/lobbies_list_item.dart';

class LobbiesList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      itemCount: 100,
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      itemBuilder: (context, index) {
        return LobbiesListItem(index);
      },
      separatorBuilder: (context, index) {
        return Divider(
          height: 1.0,
        );
      },
    );
  }
}
