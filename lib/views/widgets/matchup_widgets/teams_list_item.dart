import 'package:flutter/material.dart';
import 'package:peaman/models/app_models/team_model.dart';
import 'package:peaman/models/app_models/user_model.dart';
import 'package:peaman/viewmodels/viewmodel_builder.dart';

class TeamsListItem extends StatelessWidget {
  final Team team;
  final bool isMyTeam;
  TeamsListItem(
    this.team, {
    this.isMyTeam = false,
  });

  @override
  Widget build(BuildContext context) {
    return ViewmodelProvider<TeamsListItemVm>(
      vm: TeamsListItemVm(),
      builder: (context, vm, appVm, appUser) {
        return Column(
          children: [
            ListTile(
              onTap: () => vm.updateIsTapped(!vm.isTapped),
              contentPadding: const EdgeInsets.symmetric(
                vertical: 3.0,
                horizontal: 20.0,
              ),
              leading: Icon(
                Icons.sports_esports,
                color: isMyTeam ? Colors.green : Color(0xff3D4A5A),
              ),
              title: Text(
                '${team.teamName}',
                style: TextStyle(
                  color: isMyTeam ? Colors.green : Color(0xff3D4A5A),
                  fontWeight: isMyTeam ? FontWeight.bold : FontWeight.normal,
                ),
              ),
              trailing: Icon(
                vm.isTapped
                    ? Icons.keyboard_arrow_down
                    : Icons.keyboard_arrow_right,
                size: 20.0,
                color: isMyTeam ? Colors.green : Color(0xff3D4A5A),
              ),
            ),
            if (vm.isTapped) ..._usersBuilder(appUser),
            if (vm.isTapped)
              SizedBox(
                height: 10.0,
              ),
          ],
        );
      },
    );
  }

  List<Widget> _usersBuilder(final AppUser appUser) {
    final _list = <Widget>[];
    team.users.forEach((element) {
      _list.add(
        Padding(
          padding: const EdgeInsets.all(10.0),
          child: Row(
            children: [
              SizedBox(
                width: 60.0,
              ),
              Icon(
                Icons.person,
                color: Color(0xff3D4A5A),
              ),
              SizedBox(
                width: 20.0,
              ),
              Text(
                '${element.name}',
                style: TextStyle(
                  color: Color(0xff3D4A5A),
                ),
              ),
            ],
          ),
        ),
      );
    });
    return _list;
  }
}

class TeamsListItemVm extends ChangeNotifier {
  bool _isTapped = false;

  bool get isTapped => _isTapped;

  // update value of isTapped
  updateIsTapped(final bool newVal) {
    _isTapped = newVal;
    notifyListeners();
  }
}
