import 'package:cloud_functions/cloud_functions.dart';
import 'package:peaman/models/app_models/user_model.dart';

class UserFunctions {
  final _functions = FirebaseFunctions.instance;
  HttpsCallable _callable;

  // send user to functions
  Future sendUserToFunctions(AppUser _user) async {
    try {
      _callable = _functions.httpsCallable('sendUser');
      final _jsonUser = AppUser.toJson(_user);

      print('Success: Sending user with name ${_user.name} to functions');
      return await _callable.call(_jsonUser);
    } catch (e) {
      print(e);
      print('Error!!!: Sending user with name ${_user.name} to functions');
      return null;
    }
  }
}
