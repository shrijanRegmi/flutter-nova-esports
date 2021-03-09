import 'package:flutter/material.dart';
import 'package:peaman/models/app_models/options_model.dart';
import 'package:peaman/views/widgets/profile_widgets/options_list_item.dart';

class OptionsList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: optionsList.length,
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      itemBuilder: (context, index) {
        return OptionsListItem(optionsList[index]);
      },
    );
  }
}
