import 'package:flutter/material.dart';
import 'package:peaman/models/app_models/level_model.dart';
import 'package:provider/provider.dart';

class LevelVm extends ChangeNotifier {
  final BuildContext context;
  LevelVm(this.context);

  List<Level> get levels => Provider.of<List<Level>>(context);
}
