import 'package:flutter/material.dart';

class CommonAppbar extends StatelessWidget {
  final Widget title;
  final Widget leading;
  final Color color;
  final List<Widget> actions;
  CommonAppbar({
    this.title,
    this.leading,
    this.color = const Color(0xffF3F5F8),
    this.actions = const [],
  });

  @override
  Widget build(BuildContext context) {
    // return AppBar(
    //   title: title,
    //   backgroundColor: Colors.blue,
    //   elevation: 0.0,
    //   leading: leading != null
    //       ? leading
    //       : IconButton(
    //           onPressed: () {
    //             Navigator.pop(context);
    //           },
    //           icon: Icon(Icons.arrow_back_ios),
    //           color: Color(0xff3D4A5A),
    //         ),
    //   actions: actions,
    // );

    return Container(
      color: color,
      child: Row(
        children: [
          Row(
            children: [
              leading != null
                  ? leading
                  : IconButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      icon: Icon(Icons.arrow_back_ios),
                      color: Color(0xff3D4A5A),
                    ),
              SizedBox(
                width: 10.0,
              ),
              if (title != null) title,
            ],
          ),
          ...actions
        ],
      ),
    );
  }
}
