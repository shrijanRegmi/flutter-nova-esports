import 'package:flutter/material.dart';
import 'package:peaman/models/app_models/social_links_model.dart';
import 'package:peaman/views/widgets/profile_widgets/social_links_list_item.dart';

class SocialLinkList extends StatelessWidget {
  final List<SocialLink> socialLinks;
  SocialLinkList(this.socialLinks);
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 100.0,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: _listBuilder(),
      ),
    );
  }

  List<Widget> _listBuilder() {
    final _list = <Widget>[];

    socialLinks.forEach((element) {
      _list.add(SocialLinkListItem(
        element,
      ));
    });

    return _list;
  }
}
