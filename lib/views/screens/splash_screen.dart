import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xff5C49E0),
      body: Container(
        child: Stack(
          children: <Widget>[
            Positioned(
              top: 0.0,
              right: 0.0,
              child: Image.asset(
                'assets/images/svgs/splash_top.png',
                width: MediaQuery.of(context).size.width - 100.0,
              ),
            ),
            Positioned.fill(
              bottom: 140.0,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Text(
                    'Peaman',
                    style: TextStyle(
                      fontSize: 34.0,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  Text(
                    'Chats and much more',
                    style: TextStyle(
                      fontSize: 12.0,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            ),
            Positioned.fill(
              top: 100.0,
              child: Lottie.asset('assets/lottie/paperplane.json'),
            ),
            Positioned(
              bottom: -30.0,
              right: 0.0,
              left: 0.0,
              child: Image.asset(
                'assets/images/svgs/splash_bottom.png',
                width: MediaQuery.of(context).size.width - 100.0,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
