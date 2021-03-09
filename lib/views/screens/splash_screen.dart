import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  AnimationController _lottieController;

  @override
  void initState() {
    super.initState();
    _lottieController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 1000),
    );
  }

  @override
  void dispose() {
    _lottieController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // backgroundColor: Color(0xff5C49E0),
      body: Container(
        child: Stack(
          children: <Widget>[
            // Positioned(
            //   top: 0.0,
            //   right: 0.0,
            //   child: Image.asset(
            //     'assets/images/svgs/splash_top.png',
            //     width: MediaQuery.of(context).size.width - 100.0,
            //   ),
            // ),
            Positioned.fill(
              bottom: 240.0,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Image.asset(
                    'assets/images/logo.png',
                    width: 200.0,
                    height: 200.0,
                  ),
                  SizedBox(
                    height: 10.0,
                  ),
                  Text(
                    'NOVA ESPORTS',
                    style: TextStyle(
                      fontSize: 34.0,
                      fontWeight: FontWeight.bold,
                      color: Color(0xff3D4A5A),
                    ),
                  ),
                  Text(
                    'Tounaments to the limit',
                    style: TextStyle(
                      fontSize: 14.0,
                      fontWeight: FontWeight.bold,
                      color: Color(0xff3D4A5A),
                    ),
                  ),
                ],
              ),
            ),
            Positioned.fill(
              top: 150.0,
              child: Center(
                child: Lottie.asset(
                  'assets/lottie/circle_loader.json',
                  controller: _lottieController,
                  onLoaded: (compo) {
                    _lottieController.repeat();
                  },
                  width: 100.0,
                  height: 100.0,
                ),
              ),
            ),
            // Positioned(
            //   bottom: -30.0,
            //   right: 0.0,
            //   left: 0.0,
            //   child: Image.asset(
            //     'assets/images/svgs/splash_bottom.png',
            //     width: MediaQuery.of(context).size.width - 100.0,
            //   ),
            // ),
          ],
        ),
      ),
    );
  }
}
