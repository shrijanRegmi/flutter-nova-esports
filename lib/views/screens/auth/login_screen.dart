import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:lottie/lottie.dart';
import 'package:peaman/models/app_models/app_config.dart';
import 'package:peaman/viewmodels/auth_vm.dart';
import 'package:peaman/viewmodels/viewmodel_builder.dart';
import 'package:peaman/views/screens/auth/signup_screen.dart';
import 'package:peaman/views/widgets/auth_widgets/auth_field.dart';
import 'package:peaman/views/widgets/common_widgets/filled_btn.dart';
import 'package:provider/provider.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  @override
  Widget build(BuildContext context) {
    final _appConfig = Provider.of<AppConfig>(context);
    return Stack(
      children: [
        Container(
          height: MediaQuery.of(context).size.height,
          child: ViewmodelProvider<AuthVm>(
            vm: AuthVm(context),
            onInit: (vm) => vm.onInit(_appConfig),
            onDispose: (vm) => vm.onDispose(),
            builder: (context, vm, appVm, appUser) {
              return Scaffold(
                key: vm.scaffoldKey,
                body: SafeArea(
                  child: vm.isLoading
                      ? Center(
                          child: Stack(
                            children: [
                              Positioned.fill(
                                bottom: 100.0,
                                child: Lottie.asset(
                                  'assets/lottie/game_loader.json',
                                  width:
                                      MediaQuery.of(context).size.width - 100.0,
                                  height:
                                      MediaQuery.of(context).size.width - 100.0,
                                ),
                              ),
                              Positioned.fill(
                                top: 100.0,
                                child: Center(
                                  child: Text(
                                    'Loading...',
                                    style: TextStyle(
                                      color: Color(0xff3D4A5A),
                                    ),
                                  ),
                                ),
                              )
                            ],
                          ),
                        )
                      : Stack(
                          children: <Widget>[
                            Container(
                              height: MediaQuery.of(context).size.height,
                              child: SingleChildScrollView(
                                child: GestureDetector(
                                  onTap: () {
                                    FocusScope.of(context).unfocus();
                                  },
                                  child: Container(
                                    color: Colors.transparent,
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: <Widget>[
                                        SizedBox(
                                          height: 40.0,
                                        ),
                                        _loginTextSection(),
                                        SizedBox(
                                          height: 10.0,
                                        ),
                                        _authFieldSection(vm),
                                        SizedBox(
                                          height: 40.0,
                                        ),
                                        // _forgetPassSection(),
                                        // SizedBox(
                                        //   height: 50.0,
                                        // ),
                                        _btnSection(context, vm),
                                        SizedBox(
                                          height: 50.0,
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            if (!vm.keyboardVisibility)
                              Positioned(
                                bottom: -10.0,
                                left: 0.0,
                                right: 0.0,
                                child: SvgPicture.asset(
                                  'assets/images/svgs/auth_bottom.svg',
                                ),
                              ),
                          ],
                        ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _loginTextSection() {
    return Padding(
      padding: const EdgeInsets.only(left: 20.0),
      child: Text(
        'LOGIN',
        style: TextStyle(
          fontSize: 30.0,
          fontWeight: FontWeight.bold,
          color: Color(0xff3D4A5A),
        ),
      ),
    );
  }

  Widget _authFieldSection(AuthVm vm) {
    return Column(
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          child: AuthField(
            label: 'Email',
            type: TextInputType.emailAddress,
            controller: vm.emailController,
          ),
        ),
        SizedBox(
          height: 20.0,
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          child: AuthField(
            label: 'Password',
            type: TextInputType.visiblePassword,
            isPassword: true,
            controller: vm.passController,
          ),
        ),
      ],
    );
  }

  Widget _btnSection(BuildContext context, AuthVm vm) {
    return Column(
      children: <Widget>[
        Align(
          alignment: Alignment.center,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            child: FilledBtn(
              title: 'Log in',
              minWidth: MediaQuery.of(context).size.width,
              color: Color(0xff5C49E0),
              onPressed: vm.loginUser,
            ),
          ),
        ),
        SizedBox(
          height: 20.0,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 100.0,
              child: Divider(),
            ),
            SizedBox(
              width: 5.0,
            ),
            Text(
              'or',
              style: TextStyle(
                color: Color(0xff3D4A5A),
              ),
            ),
            SizedBox(
              width: 5.0,
            ),
            Container(
              width: 100.0,
              child: Divider(),
            ),
          ],
        ),
        SizedBox(
          height: 20.0,
        ),
        Align(
          alignment: Alignment.center,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            child: FilledBtn(
              title: 'Google',
              color: Color(0xffe81515),
              minWidth: MediaQuery.of(context).size.width,
              onPressed: vm.logInWithGoogle,
            ),
          ),
        ),
        SizedBox(
          height: 20.0,
        ),
        _newUserSection(context),
      ],
    );
  }

  Widget _newUserSection(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => SignUpScreen(),
          ),
        );
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 30.0, vertical: 10.0),
        child: RichText(
          text: TextSpan(
            style: TextStyle(
              color: Color(0xff3D4A5A),
            ),
            children: [
              TextSpan(
                text: 'New user ? ',
              ),
              TextSpan(
                text: 'Sign up',
                style: TextStyle(
                    color: Color(0xff5C49E0), fontWeight: FontWeight.bold),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
