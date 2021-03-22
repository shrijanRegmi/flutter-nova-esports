import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:peaman/enums/match_type.dart';
import 'package:peaman/enums/tournament_type.dart';
import 'package:peaman/helpers/date_time_helper.dart';
import 'package:peaman/models/app_models/tournament_model.dart';
import 'package:peaman/viewmodels/create_tournament_vm.dart';
import 'package:peaman/viewmodels/viewmodel_builder.dart';
import 'package:peaman/views/widgets/common_widgets/appbar.dart';
import 'package:peaman/views/widgets/common_widgets/filled_btn.dart';
import 'package:peaman/views/widgets/create_tournament_widgets/new_tournament_field.dart';

class CreateTournamentScreen extends StatelessWidget {
  final Tournament tournament;
  CreateTournamentScreen({this.tournament});

  @override
  Widget build(BuildContext context) {
    return ViewmodelProvider<CreateTournamentVm>(
      vm: CreateTournamentVm(context),
      onInit: (vm) => vm.onInit(tournament, null),
      builder: (context, vm, appVm, appUser) {
        return Scaffold(
          appBar: PreferredSize(
            preferredSize: Size.fromHeight(60.0),
            child: CommonAppbar(
              title: Text(
                tournament == null
                    ? 'Create new tournament'
                    : 'Edit tournament',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 20.0,
                  color: Color(0xff3D4A5A),
                ),
              ),
            ),
          ),
          body: GestureDetector(
            onTap: () => FocusScope.of(context).unfocus(),
            child: Container(
              color: Colors.transparent,
              child: vm.isLoading
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
                                'Publishing tournament...',
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
                            height: 20.0,
                          ),
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
          ),
        );
      },
    );
  }

  Widget _textFieldsContainer(
    final BuildContext context,
    final CreateTournamentVm vm,
  ) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Title of the tournament',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Color(0xff3D4A5A),
                ),
              ),
              SizedBox(
                height: 10.0,
              ),
              NewTournamentField(
                hintText: 'Enter Title',
                controller: vm.titleController,
                requiredCapitalization: false,
              ),
              //////////////////////////////////// next
              SizedBox(
                height: 20.0,
              ),
              Text(
                'Add a display picture (Optional)',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Color(0xff3D4A5A),
                ),
              ),
              SizedBox(
                height: 10.0,
              ),
              _addDpBuilder(context, vm),
            ],
          ),
        ),
        /////////////////////////////////////// next
        Row(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  height: 20.0,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20.0),
                  child: Text(
                    'Select type of match',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Color(0xff3D4A5A),
                    ),
                  ),
                ),
                _matchTypeBuilder(vm),
                SizedBox(
                  height: 10.0,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20.0),
                  child: Text(
                    'Select type of tournament',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Color(0xff3D4A5A),
                    ),
                  ),
                ),
                _tournamentTypeBuilder(vm),
              ],
            ),
          ],
        ),
        /////////////////////////////////////// next
        if (vm.selectedTournament == TournamentType.state)
          Row(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    height: 10.0,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20.0),
                    child: Text(
                      'Select state',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Color(0xff3D4A5A),
                      ),
                    ),
                  ),
                  _stateBuilder(vm),
                ],
              ),
            ],
          ),
        /////////////////////////////////////// next
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                height: 10.0,
              ),
              Text(
                'Entry cost to register in tournament',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Color(0xff3D4A5A),
                ),
              ),
              SizedBox(
                height: 10.0,
              ),
              NewTournamentField(
                hintText: 'Enter entry cost',
                textInputType: TextInputType.number,
                controller: vm.entryController,
              ),
              /////////////////////////////////////// next
              SizedBox(
                height: 20.0,
              ),
              Text(
                'Maximum number of players to join tournament',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Color(0xff3D4A5A),
                ),
              ),
              SizedBox(
                height: 10.0,
              ),
              NewTournamentField(
                hintText: 'Enter max players',
                textInputType: TextInputType.number,
                controller: vm.maxPlayersController,
              ),
              /////////////////////////////////////// next
              SizedBox(
                height: 20.0,
              ),
              Text(
                'Add date and time of tournament',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Color(0xff3D4A5A),
                ),
              ),
              SizedBox(
                height: 5.0,
              ),
              _addDateTimeBuilder(vm),
              /////////////////////////////////////// next
              SizedBox(
                height: 20.0,
              ),
              Text(
                'Add date and time of registration period',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Color(0xff3D4A5A),
                ),
              ),
              SizedBox(
                height: 5.0,
              ),
              _addRegistrationDateTimeBuilder(vm),
            ],
          ),
        ),
      ],
    );
  }

  Widget _matchTypeBuilder(final CreateTournamentVm vm) {
    final _items = <MatchType>[MatchType.solo, MatchType.duo, MatchType.squad];
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      child: DropdownButton(
        items: _items
            .map(
              (e) => DropdownMenuItem(
                value: e,
                child: Text(
                  '${Tournament().getMatchTypeTitle(matchType: e)}',
                ),
              ),
            )
            .toList(),
        underline: Container(),
        value: vm.selectedMatchType,
        onChanged: (val) {
          vm.updateSelectedMatchType(val);
        },
      ),
    );
  }

  Widget _tournamentTypeBuilder(final CreateTournamentVm vm) {
    final _items = <TournamentType>[
      TournamentType.normal,
      TournamentType.private,
      TournamentType.state
    ];
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      child: DropdownButton(
        items: _items
            .map(
              (e) => DropdownMenuItem(
                value: e,
                child: Text(
                  '${Tournament().getTournamentTypeTitle(e)}',
                ),
              ),
            )
            .toList(),
        underline: Container(),
        value: vm.selectedTournament,
        onChanged: (val) {
          vm.updateSelectedTournament(val);
        },
      ),
    );
  }

  Widget _stateBuilder(final CreateTournamentVm vm) {
    final _items = <String>[
      'Choose State',
      'Andhra Pradesh',
      'Arunachal Pradesh',
      'Assam',
      'Bihar',
      'Chhattisgarh',
      'Goa',
      'Gujarat',
      'Haryana',
      'Himachal Pradesh',
      'Jharkhand',
      'Karnataka',
      'Kerala',
      'Madhya Pradesh',
      'Maharashtra',
      'Manipur',
      'Meghalaya',
      'Mizoram',
      'Odisha',
      'Punjab',
      'Rajasthan',
      'Sikkim',
      'Tamil Nadu',
      'Telangana',
      'Tripura',
      'Uttar Pradesh',
      'Uttarakhand',
      'West Bengal',
    ];
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      child: DropdownButton(
        items: _items
            .map(
              (e) => DropdownMenuItem(
                value: e,
                child: Text(
                  '$e',
                ),
              ),
            )
            .toList(),
        underline: Container(),
        value: vm.selectedState,
        onChanged: (val) {
          vm.updateSelectedState(val);
        },
      ),
    );
  }

  Widget _addDpBuilder(BuildContext context, final CreateTournamentVm vm) {
    final _dp = vm.dp;
    return GestureDetector(
      onTap: vm.getImage,
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
          image: _dp != null
              ? DecorationImage(
                  image: _dp.path.contains('.com')
                      ? CachedNetworkImageProvider(
                          _dp.path,
                        )
                      : FileImage(_dp),
                  fit: BoxFit.cover,
                )
              : null,
        ),
        child: _dp != null
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

  Widget _addDateTimeBuilder(final CreateTournamentVm vm) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: MaterialButton(
                onPressed: vm.openDatePicker,
                color: Colors.green,
                child: Text(
                  vm.matchDate == null
                      ? 'Select tournament date'
                      : 'Change tournament date',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
            SizedBox(
              width: 10.0,
            ),
            if (vm.matchDate != null)
              Text(
                DateTimeHelper().getFormattedDate(vm.matchDate),
              ),
          ],
        ),
        SizedBox(
          height: 5.0,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: MaterialButton(
                onPressed: vm.openTimePicker,
                color: Colors.green,
                child: Text(
                  vm.matchTime == null
                      ? 'Select tournament time'
                      : 'Change tournament time',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
            SizedBox(
              width: 10.0,
            ),
            if (vm.matchTime != null)
              Text(DateTimeHelper().getFormattedTime(vm.matchTime)),
          ],
        ),
      ],
    );
  }

  Widget _addRegistrationDateTimeBuilder(final CreateTournamentVm vm) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: MaterialButton(
                onPressed: vm.registrationStartPicker,
                color: Colors.green,
                child: Text(
                  vm.registrationStartDate == null
                      ? 'Select registration start date'
                      : 'Change registration start date',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
            SizedBox(
              width: 10.0,
            ),
            if (vm.registrationStartDate != null)
              Text(
                DateTimeHelper().getFormattedDate(vm.registrationStartDate),
              ),
          ],
        ),
        SizedBox(
          height: 5.0,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: MaterialButton(
                onPressed: vm.registrationEndPicker,
                color: Colors.green,
                child: Text(
                  vm.registrationEndDate == null
                      ? 'Select registration end date'
                      : 'Change registration end date',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
            SizedBox(
              width: 10.0,
            ),
            if (vm.registrationEndDate != null)
              Text(
                DateTimeHelper().getFormattedDate(vm.registrationEndDate),
              ),
          ],
        ),
        SizedBox(
          height: 5.0,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: MaterialButton(
                onPressed: vm.registrationEndTimePicker,
                color: Colors.green,
                child: Text(
                  vm.registrationEndTime == null
                      ? 'Select registration end time'
                      : 'Change registration end timed',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
            SizedBox(
              width: 10.0,
            ),
            if (vm.registrationEndTime != null)
              Text(DateTimeHelper().getFormattedTime(vm.registrationEndTime)),
          ],
        ),
      ],
    );
  }

  Widget _buttonBuilder(final CreateTournamentVm vm) {
    return Align(
      alignment: Alignment.center,
      child: FilledBtn(
        title: 'Publish',
        color: Colors.green,
        onPressed: vm.createTournament,
      ),
    );
  }
}
