import 'package:data_connection_checker/data_connection_checker.dart';
import 'package:flutter/material.dart';
import 'package:peaman/models/app_models/app_config.dart';
import 'package:peaman/models/app_models/user_model.dart';
import 'package:peaman/views/screens/auth/auth_screen.dart';
import 'package:peaman/views/screens/auth/signup_screen.dart';
import 'package:peaman/views/screens/maintenance_break_screen.dart';
import 'package:peaman/views/screens/no_internet_screen.dart';
import 'package:peaman/views/screens/select_mode_screen.dart';
import 'package:peaman/views/screens/splash_screen.dart';
import 'package:provider/provider.dart';

class Wrapper extends StatefulWidget {
  @override
  _WrapperState createState() => _WrapperState();
}

class _WrapperState extends State<Wrapper> {
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    Future.delayed(Duration(milliseconds: 5000), () {
      setState(() {
        _isLoading = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final _internetStatus = Provider.of<DataConnectionStatus>(context) ??
        DataConnectionStatus.connected;
    final _appUser = Provider.of<AppUser>(context);
    final _appConfig = Provider.of<AppConfig>(context);

    if (_isLoading)
      return SplashScreen();
    else if (_internetStatus == DataConnectionStatus.disconnected)
      return NoInternetScreen();
    else if (_appUser == null)
      return AuthScreen();
    else if (_appConfig.maintenanceBreak && !(_appUser.admin ?? false))
      return MaintenanceBreakScreen();
    else if (_appUser.inGameId == null)
      return SignUpScreen();
    else
      return SelectModeScreen();
  }
}
