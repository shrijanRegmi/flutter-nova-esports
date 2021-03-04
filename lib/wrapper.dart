import 'package:flutter/material.dart';
import 'package:peaman/views/screens/auth/login_screen.dart';
import 'package:peaman/views/screens/home_screen.dart';
import 'package:peaman/views/screens/splash_screen.dart';
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
    if (_isLoading) {
      return SplashScreen();
    } else {
      if (widget.appUser == null) {
        return LoginScreen();
      } else {
        return HomeScreen(widget.appUser.uid);
      }
    }
  }
}
