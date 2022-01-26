import 'package:flutter/material.dart';
import 'package:pin_code_fields/pin_code_fields.dart';

class OtpInput extends StatelessWidget {
  final TextEditingController controller;
  const OtpInput({
    Key key,
    @required this.controller,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return PinCodeTextField(
      appContext: context,
      controller: controller,
      textStyle: TextStyle(
        fontSize: 28.0,
      ),
      length: 6,
      blinkWhenObscuring: true,
      animationType: AnimationType.fade,
      pinTheme: PinTheme(
        shape: PinCodeFieldShape.box,
        borderRadius: BorderRadius.circular(20.0),
        fieldHeight: 45.0,
        fieldWidth: 52.0,
        activeFillColor: Color(0xffE0E0E0),
        inactiveFillColor: Color(0xffE0E0E0),
        inactiveColor: Color(0xffE0E0E0),
        selectedFillColor: Color(0xffE0E0E0),
        selectedColor: Color(0xffE0E0E0),
        borderWidth: 1.5,
      ),
      animationDuration: Duration(milliseconds: 300),
      enableActiveFill: true,
      keyboardType: TextInputType.number,
      onCompleted: (v) {},
      onChanged: (value) {},
    );
  }
}
