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
          child: Column(
        children: [
          Container(
            height: MediaQuery.of(context).size.height - 300.0,
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage(
                  'assets/images/banner.jpg',
                ),
                fit: BoxFit.cover,
              ),
            ),
          ),
          Expanded(
            child: Stack(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      padding: const EdgeInsets.all(20.0),
                      child: Column(
                        // crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
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
                  ],
                ),
                Positioned.fill(
                  top: 100.0,
                  bottom: 20.0,
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
              ],
            ),
          ),
        ],
      )),
    );
  }
}
