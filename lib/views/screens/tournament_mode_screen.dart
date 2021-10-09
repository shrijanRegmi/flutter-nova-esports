import "package:flutter/material.dart";
import 'package:peaman/models/app_models/user_model.dart';
import 'package:peaman/views/screens/home_screen.dart';
import 'package:provider/provider.dart';

class TournamentModeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final _appUser = Provider.of<AppUser>(context);

    return HomeScreen(_appUser?.uid);
  }
}
