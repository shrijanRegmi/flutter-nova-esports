import 'package:flutter/material.dart';

class BorderBtn extends StatelessWidget {
  final String title;
  final Function onPressed;
  final Color color;
  final Color textColor;
  BorderBtn({
    this.title,
    this.onPressed,
    this.color,
    this.textColor = Colors.white,
  });

  @override
  Widget build(BuildContext context) {
    return MaterialButton(
      color: color,
      textColor: textColor,
      splashColor: textColor.withOpacity(0.2),
      highlightColor: Colors.transparent,
      onPressed: onPressed,
      minWidth: MediaQuery.of(context).size.width,
      height: 50.0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.all(
          Radius.circular(4.0),
        ),
        side: BorderSide(
          color: textColor,
        ),
      ),
      child: Text(
        '$title',
        style: TextStyle(
          fontSize: 16.0,
        ),
      ),
    );
  }
}
