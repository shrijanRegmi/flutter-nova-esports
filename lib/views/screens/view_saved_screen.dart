import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:peaman/models/app_models/user_model.dart';
import 'package:peaman/viewmodels/saved_vm.dart';
import 'package:peaman/viewmodels/viewmodel_builder.dart';
import 'package:peaman/views/widgets/common_widgets/appbar.dart';
import 'package:peaman/views/widgets/explore_tab_widgets/feeds_list.dart';
import 'package:provider/provider.dart';

class ViewSavedScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final _appUser = Provider.of<AppUser>(context);

    return ViewmodelProvider<SavedVm>(
      vm: SavedVm(),
      onInit: (vm) {
        vm.getSavedFeeds(_appUser);
      },
      builder: (context, vm, appVm, appUser) {
        return Scaffold(
          backgroundColor: Color(0xffF3F5F8),
          appBar: PreferredSize(
            preferredSize: Size.fromHeight(60.0),
            child: CommonAppbar(
              title: Text(
                'Saved Posts',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 20.0,
                  color: Color(0xff3D4A5A),
                ),
              ),
            ),
          ),
          body: vm.isLoading
              ? Center(
                  child: Lottie.asset(
                    'assets/lottie/loader.json',
                    width: MediaQuery.of(context).size.width - 100.0,
                    height: MediaQuery.of(context).size.width - 100.0,
                  ),
                )
              : SingleChildScrollView(
                  child: FeedsList(vm.feeds),
                ),
        );
      },
    );
  }
}
