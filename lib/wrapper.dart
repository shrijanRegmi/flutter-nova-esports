import 'package:data_connection_checker/data_connection_checker.dart';
import 'package:flutter/material.dart';
import 'package:peaman/views/screens/no_internet_screen.dart';
import 'package:peaman/views/screens/auth/login_screen.dart';
import 'package:peaman/views/screens/select_mode_screen.dart';
import 'package:peaman/views/screens/splash_screen.dart';
import 'package:provider/provider.dart';
import 'models/app_models/user_model.dart';

class Wrapper extends StatefulWidget {
  final AppUser appUser;
  Wrapper({this.appUser});

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
    if (_isLoading) return SplashScreen();

    if (_internetStatus == DataConnectionStatus.disconnected)
      return NoInternetScreen();

    if (widget.appUser == null)
      return LoginScreen();
    else
      return SelectModeScreen();
  }
}
