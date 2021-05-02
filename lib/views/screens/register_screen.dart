import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:lottie/lottie.dart';
import 'package:peaman/models/app_models/app_config.dart';
import 'package:peaman/models/app_models/tournament_model.dart';
import 'package:peaman/models/app_models/user_model.dart';
import 'package:peaman/viewmodels/register_vm.dart';
import 'package:peaman/viewmodels/tournament_view_vm.dart';
import 'package:peaman/viewmodels/viewmodel_builder.dart';
import 'package:peaman/views/widgets/common_widgets/appbar.dart';
import 'package:peaman/views/widgets/create_tournament_widgets/new_tournament_field.dart';
import 'package:provider/provider.dart';

class RegisterScreen extends StatefulWidget {
  final TournamentViewVm tournamentViewVm;
  final Tournament tournament;
  RegisterScreen(this.tournament, this.tournamentViewVm);

  @override
  _RegisterScreenState createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  @override
  Widget build(BuildContext context) {
    final _appConfig = Provider.of<AppConfig>(context);
    return ViewmodelProvider<RegisterVm>(
      vm: RegisterVm(context),
      onInit: (vm) => vm.onInit(_appConfig),
      onDispose: (vm) => vm.onDis(),
      builder: (context, vm, appVm, appUser) {
        return Scaffold(
          appBar: PreferredSize(
            preferredSize: Size.fromHeight(60.0),
            child: CommonAppbar(
              title: Text(
                'Register Team',
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
                            'Registering...',
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

  Widget _addDetailsBuilder(final RegisterVm vm) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Name of your team',
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

  Widget _registerBtnBuilder(
      final BuildContext context, final RegisterVm vm, final AppUser appUser) {
    return MaterialButton(
      onPressed: () =>
          vm.registerTeam(widget.tournament, appUser, widget.tournamentViewVm),
      color: Color(0xffdc8843),
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'REGISTER',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            SizedBox(
              width: 30.0,
            ),
            Row(
              children: [
                SvgPicture.asset(
                  'assets/images/svgs/coin.svg',
                  width: 30.0,
                  height: 30.0,
                ),
                SizedBox(
                  width: 5.0,
                ),
                Text(
                  '${widget.tournament.entryCost}',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 14.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
