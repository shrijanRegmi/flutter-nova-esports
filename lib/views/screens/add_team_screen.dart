import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:peaman/models/app_models/tournament_model.dart';
import 'package:peaman/models/app_models/user_model.dart';
import 'package:peaman/viewmodels/add_team_vm.dart';
import 'package:peaman/viewmodels/viewmodel_builder.dart';
import 'package:peaman/views/widgets/common_widgets/appbar.dart';
import 'package:peaman/views/widgets/create_tournament_widgets/new_tournament_field.dart';

class AddTeamScreen extends StatelessWidget {
  final Tournament tournament;
  AddTeamScreen(this.tournament);

  @override
  Widget build(BuildContext context) {
    return ViewmodelProvider(
      vm: AddTeamVm(context),
      builder: (context, vm, appVm, appUser) {
        return Scaffold(
          appBar: PreferredSize(
            preferredSize: Size.fromHeight(60.0),
            child: CommonAppbar(
              title: Text(
                'Add Team',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 20.0,
                  color: Color(0xff3D4A5A),
                ),
              ),
            ),
          ),
          body: vm.isLoading
              ? Center(
                  child: Stack(
                    children: [
                      Positioned.fill(
                        bottom: 100.0,
                        child: Lottie.asset(
                          'assets/lottie/game_loader.json',
                          width: MediaQuery.of(context).size.width - 100.0,
                          height: MediaQuery.of(context).size.width - 100.0,
                        ),
                      ),
                      Positioned.fill(
                        top: 100.0,
                        child: Center(
                          child: Text(
                            'Adding team to tournament...',
                            style: TextStyle(
                              color: Color(0xff3D4A5A),
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
                )
              : SingleChildScrollView(
                  child: GestureDetector(
                    onTap: () => FocusScope.of(context).unfocus(),
                    child: Container(
                      height: MediaQuery.of(context).size.height,
                      color: Colors.transparent,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _addDetailsBuilder(vm),
                            SizedBox(
                              height: 20.0,
                            ),
                            ..._playersListBuilder(vm),
                            _addPlayerBuilder(vm),
                            SizedBox(
                              height: 50.0,
                            ),
                            _registerBtnBuilder(context, vm, appUser),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
        );
      },
    );
  }

  Widget _addDetailsBuilder(final AddTeamVm vm) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Name of the team',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Color(0xff3D4A5A),
          ),
        ),
        SizedBox(
          height: 10.0,
        ),
        NewTournamentField(
          hintText: 'Enter Team Name',
          requiredCapitalization: false,
          controller: vm.teamNameController,
        ),
      ],
    );
  }

  Widget _addPlayerBuilder(final AddTeamVm vm) {
    return MaterialButton(
      onPressed: () => vm.searchUser(),
      color: Color(0xff5C49E0),
      child: Text(
        'Add Player',
        style: TextStyle(
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
      ),
    );
  }

  Widget _registerBtnBuilder(
    final BuildContext context,
    final AddTeamVm vm,
    final AppUser appUser,
  ) {
    return MaterialButton(
      onPressed: () => vm.addTeam(tournament),
      color: Color(0xffdc8843),
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Add Team',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }

  List<Widget> _playersListBuilder(final AddTeamVm vm) {
    final _list = <Widget>[];

    vm.players.forEach((element) {
      final _widget = Padding(
        padding: const EdgeInsets.only(bottom: 5.0),
        child: Container(
          color: Colors.grey.withOpacity(0.2),
          padding: const EdgeInsets.only(left: 10.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('${element.inGameName} - ${element.name}'),
              SizedBox(
                width: 10.0,
              ),
              IconButton(
                icon: Icon(
                  Icons.close,
                ),
                onPressed: () {
                  final _players = vm.players;
                  _players.remove(element);
                  vm.updatePlayers(_players);
                },
              ),
            ],
          ),
        ),
      );
      _list.add(_widget);
    });

    return _list;
  }
}
