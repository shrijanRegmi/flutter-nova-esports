import 'package:flutter/material.dart';

class FilledBtn extends StatelessWidget {
  final Icon icon;
  final String title;
  final Function onPressed;
  final Color color;
  final Color textColor;
  final double minWidth;
  final double borderRadius;
  final bool loading;
  FilledBtn({
    this.icon,
    this.title,
    this.onPressed,
    this.color = Colors.orange,
    this.textColor = Colors.white,
    this.minWidth,
    this.borderRadius = 4.0,
    this.loading = false,
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
          Radius.circular(borderRadius),
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
          if (loading)
            SizedBox(
              width: 20.0,
            ),
          if (loading)
            Container(
              width: 30.0,
              height: 30.0,
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation(Colors.white),
              ),
            ),
        ],
      ),
    );
  }
}
