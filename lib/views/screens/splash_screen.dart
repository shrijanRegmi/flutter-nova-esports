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
      body: Container(
        child: Stack(
          children: [
            Container(
              height: MediaQuery.of(context).size.height,
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage(
                    'assets/images/banner.jpg',
                  ),
                  fit: BoxFit.cover,
                ),
              ),
            ),
            Center(
              child: Container(
                height: 180.0,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20.0),
                  color: Colors.black.withOpacity(0.5),
                ),
                child: Container(
                  padding: const EdgeInsets.all(30.0),
                  child: Stack(
                    overflow: Overflow.visible,
                    children: [
                      Column(
                        children: [
                          Text(
                            'NOVA ESPORTS',
                            style: TextStyle(
                              fontSize: 34.0,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                          Text(
                            'Tounaments to the limit',
                            style: TextStyle(
                              fontSize: 14.0,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
            Positioned.fill(
              top: 110.0,
              bottom: 20.0,
              child: Center(
                child: Lottie.asset(
                  'assets/lottie/circle_loader.json',
                  controller: _lottieController,
                  onLoaded: (compo) {
                    _lottieController.repeat();
                  },
                  width: 60.0,
                  height: 60.0,
                ),
              ),
            ),
            Positioned(
              bottom: 10.0,
              left: 0.0,
              right: 0.0,
              child: Center(
                child: Text(
                  'Made in India'.toUpperCase(),
                  style: TextStyle(
                    fontSize: 14.0,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
