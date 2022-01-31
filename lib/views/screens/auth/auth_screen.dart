import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:peaman/viewmodels/auth_vm.dart';
import 'package:peaman/viewmodels/viewmodel_builder.dart';
import 'package:peaman/views/widgets/common_widgets/filled_btn.dart';

class AuthScreen extends StatelessWidget {
  AuthScreen({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ViewmodelProvider<AuthVm>(
      vm: AuthVm(context),
      builder: (context, vm, appVm, appUser) {
        return Scaffold(
          backgroundColor: Colors.white,
          body: SafeArea(
            child: PageView(
              physics: NeverScrollableScrollPhysics(),
              controller: vm.pageController,
              children: [
                _emailBuilder(context, vm),
                _passwordBuilder(context, vm),
              ],
            ),
          ),
          bottomNavigationBar: SvgPicture.asset(
            'assets/images/svgs/auth_bottom.svg',
          ),
        );
      },
    );
  }

  Widget _emailBuilder(final BuildContext context, final AuthVm vm) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Center(
          child: Column(
            children: [
              _headerBuilder(
                imgUrl: 'assets/images/logo.png',
                title: 'Email Verification',
                subtitle:
                    'We need to register your email before\ngetting started.',
              ),
              SizedBox(
                height: 30.0,
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                decoration: BoxDecoration(
                  color: Color(0xffE0E0E0),
                  borderRadius: BorderRadius.circular(20.0),
                ),
                child: Padding(
                  padding: const EdgeInsets.only(bottom: 1.0),
                  child: TextFormField(
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 22.0,
                    ),
                    controller: vm.emailController,
                    keyboardType: TextInputType.emailAddress,
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      hintText: 'Eg: abcdef@hello.com',
                      hintStyle: TextStyle(
                        color: Colors.grey,
                        fontWeight: FontWeight.normal,
                        fontSize: 18.0,
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: 27.0,
              ),
              _buttonBuilder(
                context,
                'Continue',
                onPressed: vm.onPressedContinueBtn,
                loading: vm.isLoading,
              ),
              SizedBox(
                height: 10.0,
              ),
              Row(
                children: [
                  Expanded(child: Divider()),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 5.0),
                    child: Text(
                      'OR',
                      style: TextStyle(
                        color: Colors.grey,
                      ),
                    ),
                  ),
                  Expanded(child: Divider()),
                ],
              ),
              SizedBox(
                height: 10.0,
              ),
              FilledBtn(
                title: 'Google Login',
                color: Color(0xffe81515).withOpacity(0.9),
                onPressed: vm.signUpWithGoogle,
                borderRadius: 20.0,
                minWidth: MediaQuery.of(context).size.width,
                loading: vm.isLoadingGoogleSignUp,
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget _passwordBuilder(final BuildContext context, final AuthVm vm) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Center(
          child: Column(
            children: [
              _headerBuilder(
                imgUrl: 'assets/images/logo.png',
                title: 'Enter Password',
                subtitle: 'Please enter your password below\nto sign up.',
              ),
              SizedBox(
                height: 30.0,
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                decoration: BoxDecoration(
                  color: Color(0xffE0E0E0),
                  borderRadius: BorderRadius.circular(20.0),
                ),
                child: Padding(
                  padding: const EdgeInsets.only(bottom: 1.0),
                  child: TextFormField(
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 22.0,
                    ),
                    controller: vm.passController,
                    keyboardType: TextInputType.text,
                    obscureText: true,
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      hintText: 'Password',
                      hintStyle: TextStyle(
                        color: Colors.grey,
                        fontWeight: FontWeight.normal,
                        fontSize: 18.0,
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: 27.0,
              ),
              _buttonBuilder(
                context,
                'Continue',
                onPressed: vm.signInWithEmailAndPassword,
                loading: vm.isLoading,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buttonBuilder(
    final BuildContext context,
    final String value, {
    final Function onPressed,
    final bool loading = false,
  }) {
    return FilledBtn(
      title: value,
      color: Color(0xff5C49E0).withOpacity(0.8),
      onPressed: onPressed ?? () {},
      borderRadius: 20.0,
      minWidth: MediaQuery.of(context).size.width,
      loading: loading,
    );
  }

  Widget _headerBuilder({
    @required final String imgUrl,
    @required final String title,
    @required final String subtitle,
  }) {
    return Column(
      children: [
        Image.asset(
          imgUrl,
          width: 170.0,
          height: 170.0,
        ),
        SizedBox(
          height: 30.0,
        ),
        Text(
          title,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 24.0,
          ),
        ),
        SizedBox(
          height: 10.0,
        ),
        Text(
          subtitle,
          style: TextStyle(
            fontSize: 14.0,
            color: Colors.grey,
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
}
