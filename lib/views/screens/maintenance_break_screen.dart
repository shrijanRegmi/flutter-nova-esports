import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:peaman/services/auth_services/auth_provider.dart';

class MaintenanceBreakScreen extends StatelessWidget {
  const MaintenanceBreakScreen({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: SvgPicture.asset(
        'assets/images/svgs/auth_bottom.svg',
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                IconButton(
                  icon: Icon(Icons.logout),
                  onPressed: () => AuthProvider().logOut(),
                ),
                SizedBox(
                  width: 20.0,
                ),
              ],
            ),
            SizedBox(
              height: 10.0,
            ),
            Image.asset(
              'assets/images/logo.png',
              width: 170.0,
              height: 170.0,
            ),
            SizedBox(
              height: 30.0,
            ),
            Text(
              'Maintenance Break'.toUpperCase(),
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 24.0,
              ),
            ),
            SizedBox(
              height: 10.0,
            ),
            Text(
              'The app is currently under maintenance.\nPlease come again later.',
              style: TextStyle(
                fontSize: 14.0,
                color: Colors.grey,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
