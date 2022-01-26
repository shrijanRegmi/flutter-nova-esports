import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:lottie/lottie.dart';
import 'package:peaman/models/app_models/app_config.dart';
import 'package:peaman/services/auth_services/auth_provider.dart';
import 'package:peaman/viewmodels/auth_vm.dart';
import 'package:peaman/viewmodels/viewmodel_builder.dart';
import 'package:peaman/views/widgets/auth_widgets/auth_field.dart';
import 'package:peaman/views/widgets/common_widgets/border_btn.dart';
import 'package:peaman/views/widgets/common_widgets/filled_btn.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

class SignUpScreen extends StatefulWidget {
  @override
  _SignUpScreenState createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final Color _textColor = Color(0xff3D4A5A);

  @override
  Widget build(BuildContext context) {
    final _appConfig = Provider.of<AppConfig>(context);

    return ViewmodelProvider<AuthVm>(
      vm: AuthVm(context),
      onInit: (vm) => vm.onInit(_appConfig),
      onDispose: (vm) => vm.onDispose(),
      builder: (context, vm, appVm, appUser) {
        return Scaffold(
          key: vm.scaffoldKey,
          body: vm.isLoading
              ? Center(
                  child: Stack(
                    children: [
                      Positioned.fill(
                        bottom: 100.0,
                        child: Lottie.asset(
                          'assets/lottie/game_loader.json',
                          width: MediaQuery.of(context).size.width - 100.0,
                          height: MediaQuery.of(context).size.width - 100.0,
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
              : Container(
                  height: MediaQuery.of(context).size.height,
                  child: SingleChildScrollView(
                    child: GestureDetector(
                      onTap: () {
                        FocusScope.of(context).unfocus();
                      },
                      child: Container(
                        color: Colors.transparent,
                        child: Padding(
                          padding: const EdgeInsets.only(
                            left: 20.0,
                            right: 20.0,
                            bottom: 20.0,
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              SizedBox(
                                height: 20.0,
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  GestureDetector(
                                    child: Icon(
                                      Icons.logout,
                                      color: _textColor,
                                    ),
                                    behavior: HitTestBehavior.opaque,
                                    onTap: () =>
                                        AuthProvider(appUser: appUser).logOut(),
                                  ),
                                ],
                              ),
                              _signUpTextBuilder(),
                              SizedBox(
                                height: 10.0,
                              ),
                              _signUpDescBuilder(),
                              SizedBox(
                                height: 20.0,
                              ),
                              vm.isNextPressed
                                  ? _userCredBuilder(vm, context)
                                  : _userInfoBuilder(context, vm),
                              SizedBox(
                                height: 50.0,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
          bottomNavigationBar: vm.isLoading
              ? null
              : SvgPicture.asset(
                  'assets/images/svgs/auth_bottom.svg',
                ),
        );
      },
    );
  }

  Widget _signUpTextBuilder() {
    return Text(
      'Sign up',
      style: TextStyle(
        fontSize: 30.0,
        fontWeight: FontWeight.bold,
        color: _textColor,
      ),
    );
  }

  Widget _signUpDescBuilder() {
    return Text(
      'Let us know about yourself',
      style: TextStyle(
        fontSize: 20.0,
        color: _textColor,
      ),
    );
  }

  Widget _userInfoBuilder(BuildContext context, AuthVm vm) {
    return Column(
      children: <Widget>[
        _uploadImageBuilder(context, vm),
        SizedBox(
          height: 20.0,
        ),
        AuthField(
          label: 'Username',
          type: TextInputType.text,
          controller: vm.nameController,
        ),
        SizedBox(
          height: 20.0,
        ),
        AuthField(
          label: 'In-Game Name',
          type: TextInputType.text,
          controller: vm.inGameNameController,
        ),
        SizedBox(
          height: 20.0,
        ),
        AuthField(
          label: 'In-Game Id',
          type: TextInputType.number,
          controller: vm.inGameIdController,
        ),
        SizedBox(
          height: 50.0,
        ),
        _termsAndConditionBuilder(vm),
        SizedBox(
          height: 30.0,
        ),
        BorderBtn(
          title: 'Continue',
          onPressed: vm.onPressedNextBtn,
          textColor: Color(0xff5C49E0),
        ),
        SizedBox(
          height: 100.0,
        ),
      ],
    );
  }

  Widget _termsAndConditionBuilder(final AuthVm vm) {
    return Column(
      children: [
        Text(
          "Please agree to our terms & condition and privacy policy.",
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
        Row(
          children: [
            Checkbox(
              value: vm.isTermsAccepted,
              onChanged: (val) => vm.updateIsTermsAccepted(val),
            ),
            Expanded(
              child: Row(
                children: [
                  Text(
                    'Accept ',
                  ),
                  GestureDetector(
                    onTap: () async {
                      try {
                        await launch(
                            "https://nirmalkumarpadhan.blogspot.com/2021/04/terms-and-condition.html");
                      } catch (e) {
                        print(e);
                      }
                    },
                    child: Text(
                      'Terms & Condition ',
                      style: TextStyle(
                        color: Colors.green,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  Text(
                    'and ',
                  ),
                  GestureDetector(
                    onTap: () async {
                      try {
                        await launch(
                            "https://nirmalkumarpadhan.blogspot.com/2021/04/nova-esports-privacy-policy.html");
                      } catch (e) {
                        print(e);
                      }
                    },
                    child: Text(
                      'Privacy policy ',
                      style: TextStyle(
                        color: Colors.green,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
      ],
    );
  }

  Widget _userCredBuilder(AuthVm vm, final BuildContext context) {
    return Column(
      children: <Widget>[
        _authFieldContainerBuilder(vm),
        SizedBox(
          height: 20.0,
        ),
        BorderBtn(
          title: 'Sign up',
          onPressed: vm.signUpUser,
          textColor: Color(0xff5C49E0),
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
          child: FilledBtn(
            title: 'Google',
            minWidth: MediaQuery.of(context).size.width,
            color: Color(0xffe81515),
            onPressed: vm.signUpWithGoogle,
          ),
        ),
        SizedBox(
          height: 100.0,
        ),
      ],
    );
  }

  Widget _uploadImageBuilder(BuildContext context, AuthVm vm) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        Expanded(
          child: Text(
            'Upload your image\n(optional)',
            style: TextStyle(
              fontSize: 16.0,
              color: _textColor,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        SizedBox(
          width: 10.0,
        ),
        GestureDetector(
          onTap: vm.uploadImage,
          child: vm.imgFile == null
              ? Stack(
                  clipBehavior: Clip.none,
                  children: <Widget>[
                    SvgPicture.asset('assets/images/svgs/upload_img.svg'),
                    Positioned(
                      bottom: 10.0,
                      left: -10.0,
                      child: Container(
                        width: 35.0,
                        height: 35.0,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: Color(0xff3D4A5A),
                          ),
                          color: Theme.of(context).canvasColor,
                        ),
                        child: Center(
                          child: Icon(
                            Icons.photo_camera,
                            size: 18.0,
                            color: Color(0xff3D4A5A),
                          ),
                        ),
                      ),
                    ),
                  ],
                )
              : Container(
                  width: 120.0,
                  height: 120.0,
                  decoration: BoxDecoration(
                      image: DecorationImage(
                          image: FileImage(vm.imgFile), fit: BoxFit.cover),
                      shape: BoxShape.circle),
                ),
        )
      ],
    );
  }

  Widget _authFieldContainerBuilder(AuthVm vm) {
    return Column(
      children: <Widget>[
        SizedBox(
          height: 20.0,
        ),
        AuthField(
          label: 'Email',
          type: TextInputType.emailAddress,
          controller: vm.emailController,
        ),
        SizedBox(
          height: 20.0,
        ),
        AuthField(
          label: 'Password',
          type: TextInputType.text,
          controller: vm.passController,
          isPassword: true,
        ),
        SizedBox(
          height: 20.0,
        ),
      ],
    );
  }
}
