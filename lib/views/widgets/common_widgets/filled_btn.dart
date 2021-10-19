import 'package:flutter/material.dart';

class FilledBtn extends StatelessWidget {
  final Icon icon;
  final String title;
  final Function onPressed;
  final Color color;
  final Color textColor;
  final double minWidth;
  FilledBtn({
    this.icon,
    this.title,
    this.onPressed,
    this.color = Colors.orange,
    this.textColor = Colors.white,
    this.minWidth,
  });

  @override
  Widget build(BuildContext context) {
    return MaterialButton(
      color: color,
      textColor: textColor,
      onPressed: onPressed,
      disabledColor: Colors.grey.withOpacity(0.5),
      minWidth: minWidth ?? MediaQuery.of(context).size.width - 100.0,
      height: 50.0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.all(
          Radius.circular(4.0),
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          if (icon != null) icon,
          if (icon != null)
            SizedBox(
              width: 10.0,
            ),
          if (title != null)
            Text(
              '$title',
              style: TextStyle(
                fontSize: 16.0,
              ),
            ),
        ],
      ),
    );
  }
}
