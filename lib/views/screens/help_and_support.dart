import 'package:flutter/material.dart';
import 'package:peaman/models/app_models/app_config.dart';
import 'package:peaman/viewmodels/help_and_support_vm.dart';
import 'package:peaman/viewmodels/viewmodel_builder.dart';
import 'package:peaman/views/widgets/common_widgets/appbar.dart';
import 'package:provider/provider.dart';

class HelpAndSupportScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final _appConfig = Provider.of<AppConfig>(context);

    return ViewmodelProvider<HelpAndSupportVm>(
      vm: HelpAndSupportVm(context),
      onInit: (vm) => vm.onInit(_appConfig),
      builder: (context, vm, appVm, appUser) {
        return Scaffold(
          appBar: PreferredSize(
            preferredSize: Size.fromHeight(60.0),
            child: CommonAppbar(
              title: Text(
                'Help And Support',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 20.0,
                  color: Color(0xff3D4A5A),
                ),
              ),
            ),
          ),
          body: Container(
            padding: const EdgeInsets.all(20.0),
            child: Text(
              'For any kind of help, please contact on this email: ${vm.supportEmailController.text.trim() == '' ? 'N/A' : vm.supportEmailController.text.trim()}',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Color(0xff3D4A5A),
              ),
            ),
          ),
          floatingActionButton: !appUser.admin
              ? null
              : Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: FloatingActionButton(
                    backgroundColor: Colors.blue,
                    heroTag: 'about',
                    onPressed: () => vm.saveSupportEmail(_appConfig),
                    child: Icon(Icons.edit),
                  ),
                ),
        );
      },
    );
  }
}
