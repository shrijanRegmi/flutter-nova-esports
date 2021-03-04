import 'package:flutter/material.dart';
import 'package:peaman/models/app_models/user_model.dart';
import 'package:peaman/models/moment_model.dart';
import 'package:peaman/services/database_services/feed_provider.dart';
import 'package:peaman/viewmodels/app_vm.dart';

class MomentVm extends ChangeNotifier {
  Moment _thisMoment;
  Moment get thisMoment => _thisMoment;

  // init function
  onInit(final AppUser appUser, final AppVm appVm, final Moment moment) {
    _updateMoment(moment);
    viewMoment(appUser, appVm);
  }

  // view moment
  viewMoment(final AppUser appUser, final AppVm appVm) async {
    if (_thisMoment.isSeen != null &&
        !_thisMoment.isSeen &&
        _thisMoment.owner.uid != appUser.uid) {
      final _moment = _thisMoment.copyWith(
        isSeen: true,
      );
      _updateMoment(_moment);
      appVm.updateSingleMoment(_moment);

      await FeedProvider(appUser: appUser, moment: _thisMoment).viewMoment();
    }
  }

  // update value of moment
  _updateMoment(final Moment newMoment) {
    _thisMoment = newMoment;
    notifyListeners();
  }
}
