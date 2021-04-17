import 'package:flutter/material.dart';
import 'package:peaman/models/app_models/app_config.dart';
import 'package:peaman/viewmodels/about_app_vm.dart';
import 'package:peaman/viewmodels/viewmodel_builder.dart';
import 'package:peaman/views/widgets/common_widgets/appbar.dart';
import 'package:provider/provider.dart';

class AboutAppScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final _appConfig = Provider.of<AppConfig>(context);

    return ViewmodelProvider<AboutAppVm>(
      vm: AboutAppVm(context),
      onInit: (vm) => vm.onInit(_appConfig),
      builder: (context, vm, appVm, appUser) {
        return Scaffold(
          appBar: PreferredSize(
            preferredSize: Size.fromHeight(60.0),
            child: CommonAppbar(
              title: Text(
                'About Novaesports',
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
              '${_appConfig.aboutApp}',
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
                    onPressed: () => vm.saveAboutApp(_appConfig),
                    child: Icon(Icons.edit),
                  ),
                ),
        );
      },
    );
  }
}
