import 'package:flutter/cupertino.dart';
import 'package:peaman/models/app_models/user_model.dart';
import 'package:provider/provider.dart';

class ProfileVm extends ChangeNotifier {
  BuildContext context;
  ProfileVm({@required this.context});

  AppUser get appUser => Provider.of<AppUser>(context);
}
