import 'package:flutter/material.dart';
import 'package:peaman/models/app_models/options_model.dart';
import 'package:peaman/viewmodels/profile_vm.dart';
import 'package:peaman/views/widgets/profile_widgets/options_list_item.dart';

class OptionsList extends StatelessWidget {
  final ProfileVm vm;
  OptionsList(this.vm);

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: optionsList.length,
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      itemBuilder: (context, index) {
        final _option = optionsList[index];
        final _isWatchAndEarn = _option.title == 'Watch and Earn';
        if (_isWatchAndEarn) {
          return FutureBuilder<bool>(
            future: vm.rewardedAd.isLoaded(),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                final _val = snapshot.data;
                if (_val) return OptionsListItem(_option);
              }
              return Container();
            },
          );
        }
        return OptionsListItem(_option);
      },
    );
  }
}
