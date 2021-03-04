import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class SingleIconBtn extends StatelessWidget {
  final String icon;
  final Function onPressed;
  final double radius;
  final Color color;
  SingleIconBtn({this.icon, this.onPressed, this.radius, this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: radius,
      height: radius,
      child: FittedBox(
        child: FloatingActionButton(
          backgroundColor: Color(0xffF3F5F8),
          elevation: 5.0,
          onPressed: onPressed,
          heroTag: icon,
          child: Padding(
            padding: const EdgeInsets.all(15.0),
            child: Center(
              child: SvgPicture.asset(
                icon,
                color: color,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
