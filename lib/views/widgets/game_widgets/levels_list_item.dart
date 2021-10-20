import 'package:flutter/material.dart';
import 'package:peaman/helpers/dialog_provider.dart';
import 'package:peaman/models/app_models/level_model.dart';
import 'package:peaman/models/app_models/user_model.dart';
import 'package:peaman/views/screens/puzzle_screen.dart';
import 'package:provider/provider.dart';

class LevelItem extends StatelessWidget {
  final Level level;
  final Function(Level) editLevel;
  final Function(Level) deleteLevel;
  const LevelItem(
    this.level,
    this.editLevel,
    this.deleteLevel, {
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final _appUser = Provider.of<AppUser>(context);

    return ListTile(
      onTap: () {
        if (_appUser.admin) {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => PuzzleScreen(level),
            ),
          );
        } else if (_appUser.currentLevel >= level.level) {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => PuzzleScreen(level),
            ),
          );
        } else {
          DialogProvider(context).showWarningDialog(
            'Level Locked',
            'Please complete previous levels to unlock this level.',
            () {},
          );
        }
      },
      leading: Icon(
        Icons.sports_esports,
        color: _appUser.admin
            ? Color(0xff3D4A5A)
            : _appUser.currentLevel >= level.level
                ? Color(0xff3D4A5A)
                : Colors.grey,
      ),
      title: Text(
        'Level ${level.level}',
        style: TextStyle(
          fontWeight: FontWeight.bold,
          color: _appUser.admin
              ? Color(0xff3D4A5A)
              : _appUser.currentLevel >= level.level
                  ? Color(0xff3D4A5A)
                  : Colors.grey,
        ),
      ),
      trailing: _appUser.admin
          ? Container(
              width: 100.0,
              child: Row(
                children: [
                  IconButton(
                    icon: Icon(Icons.edit),
                    color: Color(0xff3D4A5A),
                    splashRadius: 1.0,
                    iconSize: 22.0,
                    onPressed: () => editLevel(level),
                  ),
                  IconButton(
                    icon: Icon(Icons.delete),
                    color: Colors.red,
                    splashRadius: 1.0,
                    iconSize: 22.0,
                    onPressed: () => deleteLevel(level),
                  ),
                ],
              ),
            )
          : _appUser.currentLevel > level.level
              ? Icon(
                  Icons.check_circle,
                  color: Colors.green,
                )
              : _appUser.currentLevel == level.level
                  ? null
                  : Icon(
                      Icons.lock,
                      color: Colors.grey,
                    ),
    );
  }
}
