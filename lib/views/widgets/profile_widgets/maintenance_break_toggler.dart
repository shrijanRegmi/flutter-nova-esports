import 'package:flutter/material.dart';

class MaintenanceBreakToggler extends StatefulWidget {
  final bool initialVal;
  final Function(bool) onChanged;
  MaintenanceBreakToggler({
    Key key,
    @required this.initialVal,
    @required this.onChanged,
  }) : super(key: key);

  @override
  _MaintenanceBreakTogglerState createState() =>
      _MaintenanceBreakTogglerState();
}

class _MaintenanceBreakTogglerState extends State<MaintenanceBreakToggler> {
  bool _val = false;

  @override
  void initState() {
    super.initState();
    setState(() {
      _val = widget.initialVal;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          'Maintenance Break:',
          style: TextStyle(
            fontSize: 16.0,
          ),
        ),
        Switch(
          value: _val,
          onChanged: (val) {
            widget.onChanged?.call(val);
            setState(() => _val = val);
          },
        )
      ],
    );
  }
}
