import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:peaman/viewmodels/level_vm.dart';
import 'package:peaman/viewmodels/viewmodel_builder.dart';
import 'package:peaman/views/screens/create_level_screen.dart';
import 'package:peaman/views/widgets/common_widgets/appbar.dart';
import 'package:peaman/views/widgets/game_widgets/levels_list.dart';

class LevelScreen extends StatelessWidget {
  const LevelScreen({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ViewmodelProvider<LevelVm>(
      vm: LevelVm(context),
      builder: (context, vm, appVm, appUser) {
        return Scaffold(
          appBar: PreferredSize(
            preferredSize: Size.fromHeight(60.0),
            child: CommonAppbar(
              title: Text(
                'Levels',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 20.0,
                  color: Color(0xff3D4A5A),
                ),
              ),
            ),
          ),
          floatingActionButton: appUser.admin
              ? FloatingActionButton(
                  child: Icon(Icons.add),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => CreateLevelScreen(),
                      ),
                    );
                  },
                )
              : null,
          body: vm.levels == null
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
                            'Loading...',
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
                  child: Column(
                    children: [
                      SizedBox(
                        height: 10.0,
                      ),
                      if (!appUser.admin &&
                          vm.levels.length < appUser.currentLevel)
                        _completedLevelBuilder(),
                      LevelsList(vm.levels),
                    ],
                  ),
                ),
        );
      },
    );
  }

  Widget _completedLevelBuilder() {
    return Container(
      padding: const EdgeInsets.all(10.0),
      color: Colors.green,
      child: Row(
        children: [
          Icon(
            Icons.check_circle,
            color: Colors.white,
          ),
          SizedBox(
            width: 10.0,
          ),
          Text(
            'Congratulations! You have completed all the levels.',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          )
        ],
      ),
    );
  }
}
