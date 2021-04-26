import 'package:flutter/material.dart';
import 'package:peaman/models/app_models/team_model.dart';
import 'package:peaman/models/app_models/user_model.dart';
import 'package:peaman/services/database_services/user_provider.dart';
import 'package:peaman/viewmodels/team_view_vm.dart';
import 'package:peaman/viewmodels/viewmodel_builder.dart';
import 'package:peaman/views/screens/user_view_screen.dart';
import 'package:provider/provider.dart';

class TeamsListItem extends StatefulWidget {
  final Team team;
  final bool isMyTeam;
  final bool isWinner;
  TeamsListItem(
    this.team, {
    this.isMyTeam = false,
    this.isWinner = false,
  });

  @override
  _TeamsListItemState createState() => _TeamsListItemState();
}

class _TeamsListItemState extends State<TeamsListItem> {
  bool _isChecked = false;
  bool _isLoadingProfile = false;

  @override
  Widget build(BuildContext context) {
    final _teamViewVm = Provider.of<TeamViewVm>(context);

    print(
        'The selected winners are ${_teamViewVm.selectedWinners.map((e) => e.teamName)}');

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
                color: widget.isMyTeam ? Colors.green : Color(0xff3D4A5A),
              ),
              title: Text(
                '${widget.team.teamName}',
                style: TextStyle(
                  color: widget.isMyTeam ? Colors.green : Color(0xff3D4A5A),
                  fontWeight:
                      widget.isMyTeam ? FontWeight.bold : FontWeight.normal,
                ),
              ),
              trailing: !widget.isWinner &&
                      !_teamViewVm.selectedWinners.contains(widget.team) &&
                      _teamViewVm.isCheckBox
                  ? Checkbox(
                      value: _isChecked,
                      onChanged: (val) {
                        setState(() => _isChecked = val);
                        final _checkedWinners =
                            _teamViewVm.checkedWinners ?? [];

                        if (_isChecked) {
                          _checkedWinners.add(widget.team);
                          _teamViewVm.updateCheckedWinner(_checkedWinners);
                        } else {
                          _checkedWinners.remove(widget.team);
                          _teamViewVm.updateCheckedWinner(_checkedWinners);
                        }
                      },
                    )
                  : Row(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        if (widget.isWinner ||
                            _teamViewVm.selectedWinners.contains(widget.team))
                          Text(
                            'Winner',
                            style: TextStyle(
                              fontStyle: FontStyle.italic,
                              fontSize: 12.0,
                              fontWeight: FontWeight.bold,
                              color: Color(0xff3D4A5A),
                            ),
                          ),
                        if (widget.isWinner ||
                            _teamViewVm.selectedWinners.contains(widget.team))
                          SizedBox(
                            width: 10.0,
                          ),
                        Icon(
                          vm.isTapped
                              ? Icons.keyboard_arrow_down
                              : Icons.keyboard_arrow_right,
                          size: 20.0,
                          color: widget.isMyTeam
                              ? Colors.green
                              : Color(0xff3D4A5A),
                        ),
                      ],
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
    widget.team.users.forEach((element) {
      _list.add(
        GestureDetector(
          onTap: () async {
            if (appUser.admin) {
              setState(() {
                _isLoadingProfile = true;
              });
              final _user =
                  await AppUserProvider(uid: element.uid).getUserById();
              setState(() {
                _isLoadingProfile = false;
              });

              if (_user != null) {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => UserViewScreen(_user),
                  ),
                );
              }
            }
          },
          child: Container(
            color: Colors.transparent,
            child: Padding(
              padding: const EdgeInsets.all(10.0),
              child: Row(
                children: [
                  SizedBox(
                    width: 60.0,
                  ),
                  _isLoadingProfile
                      ? Container(
                          width: 20.0,
                          height: 20.0,
                          child: Center(
                            child: CircularProgressIndicator(),
                          ),
                        )
                      : Icon(
                          Icons.person,
                          color: Color(0xff3D4A5A),
                        ),
                  SizedBox(
                    width: 20.0,
                  ),
                  Text(
                    '${element.inGameName}',
                    style: TextStyle(
                      color: Color(0xff3D4A5A),
                    ),
                  ),
                ],
              ),
            ),
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
