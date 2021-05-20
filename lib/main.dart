import 'package:data_connection_checker/data_connection_checker.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:peaman/models/app_models/user_model.dart';
import 'package:peaman/services/ad_services/ad_provider.dart';
import 'package:peaman/services/auth_services/auth_provider.dart';
import 'package:peaman/services/database_services/user_provider.dart';
import 'package:peaman/viewmodels/app_vm.dart';
import 'package:peaman/wrapper.dart';
import 'package:peaman/wrapper_builder.dart';
import 'package:provider/provider.dart';

import 'models/app_models/app_config.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  AdProvider.init();
  MobileAds.instance.initialize();

  runApp(PeamanApp());
}

class PeamanApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: Firebase.initializeApp(),
      builder: (context, snap) {
        if (snap.hasData) {
          return MultiProvider(
            providers: [
              ChangeNotifierProvider<AppVm>(
                create: (_) => AppVm(context),
              ),
              StreamProvider<AppUser>.value(
                value: AuthProvider().user,
              ),
              StreamProvider<AppConfig>.value(
                value: AppUserProvider().appConfig,
              ),
              StreamProvider<DataConnectionStatus>.value(
                value: AuthProvider().internetConnection,
              ),
            ],
            child: WrapperBuilder(
              builder: (BuildContext context, AppUser appUser) {
                return MyMaterialApp(appUser);
              },
            ),
          );
        }
        return Container();
      },
    );
  }
}

class MyMaterialApp extends StatefulWidget {
  final AppUser appUser;
  MyMaterialApp(this.appUser);

  @override
  _MyMaterialAppState createState() => _MyMaterialAppState();
}

class _MyMaterialAppState extends State<MyMaterialApp> {
  @override
  Widget build(BuildContext context) {
    final _appConfig = Provider.of<AppConfig>(context);

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        fontFamily: 'Nunito',
        canvasColor: Color(0xffF3F5F8),
      ),
      home: SafeArea(
        child: Column(
          children: [
            _appConfig != null
                ? Container(
                    height: 50.0,
                    child: AdProvider.banner(context),
                  )
                : Container(),
            Expanded(
              child: MaterialApp(
                debugShowCheckedModeBanner: false,
                title: "NOVA ESPORTS",
                theme: ThemeData(
                  fontFamily: 'Nunito',
                  canvasColor: Color(0xffF3F5F8),
                ),
                home: Material(
                  child: Wrapper(
                    appUser: widget.appUser,
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
