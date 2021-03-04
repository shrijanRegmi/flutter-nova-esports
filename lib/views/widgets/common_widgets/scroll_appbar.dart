import 'package:flutter/material.dart';

class ScrollAppbar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        IconButton(
          icon: Icon(Icons.arrow_back_ios),
          color: Color(0xff3D4A5A),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ],
    );
  }
}
