import 'package:flutter/material.dart';
import 'package:peaman/models/app_models/options_model.dart';

class OptionsListItem extends StatelessWidget {
  final Option option;
  OptionsListItem(this.option);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding:
          const EdgeInsets.symmetric(horizontal: 20.0, vertical: 5.0),
      leading: Icon(
        option.iconData,
        color: Color(0xff9496ab),
      ),
      title: Text(
        '${option.title}',
        style: TextStyle(
          fontWeight: FontWeight.bold,
        ),
      ),
      trailing: Icon(
        Icons.arrow_forward_ios,
        color: Color(0xff9496ab),
        size: 17.0,
      ),
      onTap: () => option.onPressed(context),
    );
  }
}
