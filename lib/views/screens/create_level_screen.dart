import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:peaman/models/app_models/level_model.dart';
import 'package:peaman/viewmodels/create_level_vm.dart';
import 'package:peaman/viewmodels/viewmodel_builder.dart';
import 'package:peaman/views/widgets/common_widgets/appbar.dart';
import 'package:peaman/views/widgets/common_widgets/color_toggler.dart';
import 'package:peaman/views/widgets/common_widgets/filled_btn.dart';
import 'package:peaman/views/widgets/create_tournament_widgets/new_tournament_field.dart';

class CreateLevelScreen extends StatelessWidget {
  final Level level;
  const CreateLevelScreen({
    Key key,
    this.level,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ViewmodelProvider<CreateLevelVm>(
      vm: CreateLevelVm(context),
      onInit: (vm) => vm.onInit(level),
      builder: (context, vm, appUser, appVm) {
        return Scaffold(
          appBar: PreferredSize(
            preferredSize: Size.fromHeight(60.0),
            child: CommonAppbar(
              title: Text(
                'Create Level',
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
                            'Creating level...',
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
                  child: Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _textFieldsContainer(context, vm),
                        SizedBox(
                          height: 50.0,
                        ),
                        _buttonBuilder(vm),
                        SizedBox(
                          height: 20.0,
                        ),
                      ],
                    ),
                  ),
                ),
        );
      },
    );
  }

  Widget _textFieldsContainer(
      final BuildContext context, final CreateLevelVm vm) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Level of the game',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Color(0xff3D4A5A),
          ),
        ),
        SizedBox(
          height: 10.0,
        ),
        NewTournamentField(
          hintText: 'Enter Level',
          controller: vm.levelController,
          textInputType: TextInputType.number,
        ),
        SizedBox(
          height: 20.0,
        ),
        ///////////// NEXT
        Text(
          'Difficulty of the level',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Color(0xff3D4A5A),
          ),
        ),
        SizedBox(
          height: 10.0,
        ),
        NewTournamentField(
          hintText: 'Enter Difficulty (2 - 15)',
          controller: vm.difficultyController,
          textInputType: TextInputType.number,
        ),
        SizedBox(
          height: 20.0,
        ),
        ///////////// NEXT
        _colorTogglerBuilder(vm),
        SizedBox(
          height: 20.0,
        ),
        ///////////// NEXT
        Text(
          'Add level picture',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Color(0xff3D4A5A),
          ),
        ),
        SizedBox(
          height: 10.0,
        ),
        _addDpBuilder(context, vm),
        ///////////// NEXT
      ],
    );
  }

  Widget _addDpBuilder(BuildContext context, final CreateLevelVm vm) {
    return GestureDetector(
      onTap: vm.getImgFromGallery,
      child: Container(
        width: MediaQuery.of(context).size.width,
        height: 200.0,
        decoration: BoxDecoration(
          color: Colors.transparent,
          border: Border.all(
            color: Colors.grey.shade400,
            width: 1.5,
          ),
          borderRadius: BorderRadius.circular(5.0),
          image: vm.img != null
              ? DecorationImage(
                  image: vm.img.path.contains('.com')
                      ? CachedNetworkImageProvider(
                          vm.img.path,
                        )
                      : FileImage(vm.img),
                  fit: BoxFit.cover,
                )
              : null,
        ),
        child: vm.img != null
            ? Container()
            : Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.add_photo_alternate,
                      color: Colors.grey,
                      size: 30.0,
                    ),
                  ],
                ),
              ),
      ),
    );
  }

  Widget _buttonBuilder(final CreateLevelVm vm) {
    return Align(
      alignment: Alignment.center,
      child: FilledBtn(
        title: 'Publish',
        color: Colors.green,
        onPressed: vm.createLevel,
      ),
    );
  }

  Widget _colorTogglerBuilder(final CreateLevelVm vm) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Select color of numbers',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Color(0xff3D4A5A),
          ),
        ),
        ColorToggler(
          onChange: vm.updateNumColorWhite,
        ),
      ],
    );
  }
}
