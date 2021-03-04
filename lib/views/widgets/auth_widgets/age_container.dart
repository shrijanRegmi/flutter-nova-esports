import 'package:flutter/material.dart';

class AgeContainer extends StatelessWidget {
  final String ageRange;
  final Color color;
  final Function onPressed;
  AgeContainer({
    this.ageRange,
    this.onPressed,
    this.color = Colors.transparent,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 5.0, horizontal: 15.0),
        decoration: BoxDecoration(
          border: Border.all(
            color: Color(0xff3D4A5A),
          ),
          borderRadius: BorderRadius.all(Radius.circular(20.0)),
          color: color,
        ),
        child: Center(
          child: Text(
            '$ageRange',
            style: TextStyle(
              fontSize: 12.0,
              color: color == null
                  ? Color(0xff3D4A5A)
                  : Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }
}
