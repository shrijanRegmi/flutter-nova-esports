import 'package:flutter/material.dart';

class NoInternetScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.info_outline,
                  size: 100.0,
                  color: Color(0xff3D4A5A),
                ),
                SizedBox(
                  height: 10.0,
                ),
                Text(
                  'No Internet !',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 24.0,
                    color: Color(0xff3D4A5A),
                  ),
                ),
                Text(
                  "You don't have internet connection.\nPlease check your internet connection\nand try again.",
                  style: TextStyle(
                    fontSize: 16.0,
                    color: Color(0xff3D4A5A),
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
