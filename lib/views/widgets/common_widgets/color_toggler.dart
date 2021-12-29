import 'package:flutter/material.dart';

class ColorToggler extends StatefulWidget {
  final bool value;
  final Function(bool) onChange;
  const ColorToggler({
    Key key,
    this.value = false,
    this.onChange,
  }) : super(key: key);

  @override
  _ColorTogglerState createState() => _ColorTogglerState();
}

class _ColorTogglerState extends State<ColorToggler> {
  bool _val = false;

  @override
  void initState() {
    super.initState();
    setState(() {
      _val = widget.value;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 30.0,
          height: 30.0,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: Colors.black,
            border: Border.all(color: Colors.amber),
          ),
        ),
        Switch(
          value: _val,
          onChanged: (val) {
            setState(() => _val = val);
            widget.onChange?.call(val);
          },
        ),
        Container(
          width: 30.0,
          height: 30.0,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: Colors.white,
            border: Border.all(color: Colors.amber),
          ),
        ),
      ],
    );
  }
}
