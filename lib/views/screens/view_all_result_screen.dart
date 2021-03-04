import 'package:flutter/material.dart';
import 'package:peaman/models/app_models/user_model.dart';
import 'package:peaman/viewmodels/search_vm.dart';
import 'package:peaman/viewmodels/viewmodel_builder.dart';
import 'package:peaman/views/widgets/common_widgets/appbar.dart';
import 'package:peaman/views/widgets/search_widgets/users_list_item.dart';
import 'package:provider/provider.dart';

class ViewAllResultScreen extends StatelessWidget {
  final List<AppUser> users;
  final String searchKey;
  ViewAllResultScreen(this.users, this.searchKey);

  @override
  Widget build(BuildContext context) {
    final _appUser = Provider.of<AppUser>(context);

    return ViewmodelProvider<SearchVm>(
      vm: SearchVm(context: context),
      onInit: (vm) {
        vm.onInit(_appUser, users, searchKey);
      },
      builder: (context, vm, appVm, appUser) {
        return Scaffold(
          backgroundColor: Color(0xffF3F5F8),
          appBar: PreferredSize(
            preferredSize: Size.fromHeight(60.0),
            child: CommonAppbar(
              title: Text(
                'View All Results',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 20.0,
                  color: Color(0xff3D4A5A),
                ),
              ),
            ),
          ),
          body: SingleChildScrollView(
            controller: vm.scrollController,
            child: Column(
              children: [
                _listOfUsers(vm),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _listOfUsers(final SearchVm vm) {
    return ListView.builder(
      itemCount: vm.searchedNames.length,
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      itemBuilder: (context, index) {
        return UserListItem(
          friend: vm.searchedNames[index],
        );
      },
    );
  }
}
