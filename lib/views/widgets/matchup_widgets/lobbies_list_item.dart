import 'package:flutter/material.dart';

class LobbiesListItem extends StatelessWidget {
  final int index;
  LobbiesListItem(this.index);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: () {},
      contentPadding: const EdgeInsets.symmetric(
        vertical: 8.0,
        horizontal: 20.0,
      ),
      leading: Icon(
        Icons.sports_esports,
        color: Color(0xff3D4A5A),
      ),
      title: Text(
        'Lobby ${index + 1}',
        style: TextStyle(
          color: Color(0xff3D4A5A),
        ),
      ),
      trailing: Icon(
        Icons.arrow_forward_ios,
        size: 12.0,
        color: Color(0xff3D4A5A),
      ),
    );
  }
}
