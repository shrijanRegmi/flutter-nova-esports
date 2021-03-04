import 'package:flutter/material.dart';
import 'package:peaman/helpers/dialog_provider.dart';
import 'package:peaman/models/app_models/user_model.dart';
import 'package:peaman/models/moment_model.dart';
import 'package:peaman/viewmodels/app_vm.dart';
import 'package:peaman/views/widgets/explore_tab_widgets/moments_list_item.dart';

class MomentsList extends StatelessWidget {
  final List<Moment> moments;
  final Function createMoment;
  final AppUser appUser;
  final AppVm appVm;

  MomentsList({
    this.moments,
    this.createMoment,
    this.appUser,
    this.appVm,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _momentTextBuilder(),
        SizedBox(
          height: 10.0,
        ),
        _momentsListBuilder(),
      ],
    );
  }

  Widget _momentTextBuilder() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10.0),
      child: Text(
        'Moments',
        style: TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 16.0,
          color: Color(0xff3D4A5A),
        ),
      ),
    );
  }

  Widget _momentsListBuilder() {
    final _list = moments == null ? [null] : [null, ...moments];

    return Container(
      height: 100.0,
      child: Center(
        child: ListView.builder(
          scrollDirection: Axis.horizontal,
          itemCount: _list.length,
          itemBuilder: (context, index) {
            final _moment = _list[index];

            if (_moment == null) {
              return _addMomentBuilder(context);
            }
            return MomentsListItem(
              _moment,
              moments,
              appUser,
            );
          },
        ),
      ),
    );
  }

  Widget _addMomentBuilder(final BuildContext context) {
    return GestureDetector(
      onTap: () {
        final _myMoment = appVm.moments.firstWhere(
            (element) => element.ownerId == appUser.uid,
            orElse: () => null);
        if (_myMoment == null) {
          createMoment(appUser, appVm);
        } else {
          DialogProvider(context).showLimitedMomentDialog();
        }
      },
      child: Container(
        color: Colors.transparent,
        child: Padding(
          padding: const EdgeInsets.only(left: 10.0, right: 10.0),
          child: Column(
            children: [
              Container(
                width: 62.0,
                height: 62.0,
                decoration: BoxDecoration(
                  color: Colors.pink.withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child: Center(
                  child: Icon(
                    Icons.add,
                    color: Colors.pink,
                  ),
                ),
              ),
              SizedBox(
                height: 5.0,
              ),
              Text(
                'My moment',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 12.0,
                  color: Color(0xff3D4A5A),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
