import 'package:flutter/material.dart';
import 'package:peaman/models/app_models/level_model.dart';
import 'package:peaman/views/widgets/game_widgets/levels_list_item.dart';

class LevelsList extends StatelessWidget {
  final List<Level> levels;
  final Function(Level) editLevel;
  final Function(Level) deleteLevel;

  const LevelsList(
    this.levels,
    this.editLevel,
    this.deleteLevel, {
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      itemCount: levels.length,
      itemBuilder: (context, index) {
        return LevelItem(levels[index], editLevel, deleteLevel);
      },
      separatorBuilder: (context, index) {
        return Divider();
      },
    );
  }
}
