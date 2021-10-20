import 'package:flutter/material.dart';
import 'package:peaman/helpers/dialog_provider.dart';
import 'package:peaman/models/app_models/level_model.dart';
import 'package:peaman/services/database_services/game_provider.dart';
import 'package:peaman/views/screens/create_level_screen.dart';
import 'package:provider/provider.dart';

class LevelVm extends ChangeNotifier {
  final BuildContext context;
  LevelVm(this.context);

  List<Level> get levels => Provider.of<List<Level>>(context);

  // edit a level
  editLevel(final Level level) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => CreateLevelScreen(level: level),
      ),
    );
  }

  // delete a level
  deleteLevel(final Level level) {
    DialogProvider(context).showConfirmationDialog(
      'Are you sure you want to delete this level ?',
      () {
        GameProvider(level: level).deleteLevel();
      },
    );
  }
}
