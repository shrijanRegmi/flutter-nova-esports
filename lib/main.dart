import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:peaman/models/app_models/user_model.dart';
import 'package:peaman/services/auth_services/auth_provider.dart';
import 'package:peaman/services/database_services/user_provider.dart';
import 'package:peaman/viewmodels/app_vm.dart';
import 'package:peaman/wrapper.dart';
import 'package:peaman/wrapper_builder.dart';
import 'package:provider/provider.dart';

import 'models/app_models/app_config.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
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
            ],
            child: WrapperBuilder(
              builder: (BuildContext context, AppUser appUser) {
                return MaterialApp(
                  debugShowCheckedModeBanner: false,
                  title: "NOVA ESPORTS",
                  theme: ThemeData(
                    fontFamily: 'Nunito',
                    canvasColor: Color(0xffF3F5F8),
                  ),
                  home: Material(
                      child: Wrapper(
                    appUser: appUser,
                  )),
                );
              },
            ),
          );
        }
        return Container();
      },
    );
  }
}
