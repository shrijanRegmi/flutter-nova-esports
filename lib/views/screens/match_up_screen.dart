import 'package:flutter/material.dart';
import 'package:peaman/models/app_models/tournament_model.dart';
import 'package:peaman/views/widgets/common_widgets/appbar.dart';
import 'package:peaman/views/widgets/matchup_widgets/lobbies_list.dart';

class MatchUpScreen extends StatelessWidget {
  final Tournament tournament;
  MatchUpScreen(this.tournament);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(60.0),
        child: CommonAppbar(
          title: Text(
            'Match Ups',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 20.0,
              color: Color(0xff3D4A5A),
            ),
          ),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _roundSelectionBuilder(),
              LobbiesList(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _roundSelectionBuilder() {
    final _items = <int>[1, 2, 3, 4, 5, 6, 7, 8, 9, 10];
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      child: DropdownButton(
        items: _items
            .map(
              (e) => DropdownMenuItem(
                value: e,
                child: Text(
                  'Round $e',
                ),
              ),
            )
            .toList(),
        underline: Container(),
        value: _items[0],
        onChanged: (val) {},
      ),
    );
  }
}
