import 'package:flutter/material.dart';
import 'package:peaman/models/app_models/video_stream_model.dart';
import 'package:peaman/viewmodels/create_tournament_vm.dart';
import 'package:peaman/viewmodels/viewmodel_builder.dart';
import 'package:peaman/views/widgets/common_widgets/appbar.dart';
import 'package:peaman/views/widgets/common_widgets/filled_btn.dart';
import 'package:peaman/views/widgets/create_tournament_widgets/new_tournament_field.dart';

class CreateVideoStreamScreen extends StatelessWidget {
  final List<VideoStream> videoStreams;
  CreateVideoStreamScreen({this.videoStreams});

  @override
  Widget build(BuildContext context) {
    return ViewmodelProvider<CreateTournamentVm>(
      onInit: (vm) => vm.onInit(null, videoStreams),
      vm: CreateTournamentVm(context),
      builder: (context, vm, appVm, appUser) {
        return Scaffold(
          appBar: PreferredSize(
            preferredSize: Size.fromHeight(60.0),
            child: CommonAppbar(
              title: Text(
                'Video streams',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 20.0,
                  color: Color(0xff3D4A5A),
                ),
              ),
            ),
          ),
          body: SingleChildScrollView(
            child: GestureDetector(
              onTap: () => FocusScope.of(context).unfocus(),
              child: Container(
                height: MediaQuery.of(context).size.height,
                color: Colors.transparent,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20.0),
                  child: Column(
                    children: [
                      SizedBox(
                        height: 10.0,
                      ),
                      ..._linkBuilder(vm),
                      SizedBox(
                        height: 50.0,
                      ),
                      _buttonBuilder(vm),
                      SizedBox(
                        height: 50.0,
                      ),
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

  List<Widget> _linkBuilder(final CreateTournamentVm vm) {
    return <Widget>[
      Row(
        children: [
          Expanded(
            child: NewTournamentField(
              hintText: 'Link 1',
              controller: vm.link1,
            ),
          ),
          _isLiveBuilder(
            vm.live1,
            (val) => vm.updateLives(newVal1: val),
          ),
        ],
      ),
      SizedBox(
        height: 20.0,
      ),
      Row(
        children: [
          Expanded(
            child: NewTournamentField(
              hintText: 'Link 2',
              controller: vm.link2,
            ),
          ),
          _isLiveBuilder(
            vm.live2,
            (val) => vm.updateLives(newVal2: val),
          ),
        ],
      ),
      SizedBox(
        height: 20.0,
      ),
      Row(
        children: [
          Expanded(
            child: NewTournamentField(
              hintText: 'Link 3',
              controller: vm.link3,
            ),
          ),
          _isLiveBuilder(
            vm.live3,
            (val) => vm.updateLives(newVal3: val),
          ),
        ],
      ),
      SizedBox(
        height: 20.0,
      ),
    ];
  }

  Widget _isLiveBuilder(final bool val, final Function(bool) onChanged) {
    final _items = <bool>[false, true];
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      child: DropdownButton(
        items: _items
            .map(
              (e) => DropdownMenuItem(
                value: e,
                child: Text(
                  e ? 'Live' : 'Not Live',
                ),
              ),
            )
            .toList(),
        underline: Container(),
        value: val,
        onChanged: onChanged,
      ),
    );
  }

  Widget _buttonBuilder(final CreateTournamentVm vm) {
    return Align(
      alignment: Alignment.center,
      child: FilledBtn(
        title: 'Publish',
        color: Colors.green,
        onPressed: vm.publishVideoStream,
      ),
    );
  }
}
