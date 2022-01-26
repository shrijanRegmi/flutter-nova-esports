import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:peaman/viewmodels/auth_vm.dart';
import 'package:peaman/viewmodels/viewmodel_builder.dart';
import 'package:peaman/views/widgets/auth_widgets/otp_input.dart';
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
                _numberBuilder(context, vm),
                _otpBuilder(context, vm),
              ],
            ),
          ),
          bottomNavigationBar:
              SvgPicture.asset('assets/images/svgs/auth_bottom.svg'),
        );
      },
    );
  }

  Widget _numberBuilder(final BuildContext context, final AuthVm vm) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Center(
          child: Column(
            children: [
              _headerBuilder(
                imgUrl: 'assets/images/logo.png',
                title: 'Number Verification',
                subtitle:
                    'We need to register your Mobile Number\nbefore getting started.',
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
                    controller: vm.phoneController,
                    keyboardType: TextInputType.phone,
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      hintText: 'Eg: +9779808950454',
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
                'Send OTP Code',
                onPressed: vm.signInWithPhone,
                loading: vm.isLoading,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _otpBuilder(final BuildContext context, final AuthVm vm) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Center(
          child: Column(
            children: [
              _headerBuilder(
                imgUrl: 'assets/images/logo.png',
                title: 'Enter OTP Code',
                subtitle:
                    'We have just sent you the OTP code\nplease enter below.',
              ),
              SizedBox(
                height: 30.0,
              ),
              OtpInput(
                controller: vm.otpController,
              ),
              SizedBox(
                height: 27.0,
              ),
              _buttonBuilder(
                context,
                'Verify Mobile Number',
                onPressed: vm.submitOtpCode,
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
          width: 230.0,
          height: 230.0,
        ),
        SizedBox(
          height: 40.0,
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
