import "package:flutter/material.dart";
import 'package:peaman/helpers/dialog_provider.dart';
import 'package:peaman/views/screens/tournament_mode_screen.dart';
import 'package:peaman/views/widgets/common_widgets/filled_btn.dart';

class SelectModeScreen extends StatefulWidget {
  @override
  _SelectModeScreenState createState() => _SelectModeScreenState();
}

class _SelectModeScreenState extends State<SelectModeScreen> {
  int selectedMode;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _headerBuilder(),
              SizedBox(
                height: 50.0,
              ),
              _buttonsRowBuilder(),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: FilledBtn(
                  title: 'Continue',
                  color: Color(0xff3D4A5A),
                  minWidth: MediaQuery.of(context).size.width,
                  onPressed: selectedMode == null
                      ? null
                      : () {
                          if (selectedMode == 0)
                            // Navigator.push(
                            //   context,
                            //   MaterialPageRoute(
                            //     builder: (_) => GameModeScreen(),
                            //   ),
                            // );
                            DialogProvider(context).showWarningDialog(
                              'Underdevelopment',
                              "FF Puzzles is underdevelopment and will be live soon.",
                              () {},
                            );
                          else
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => TournamentModeScreen(),
                              ),
                            );
                        },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _headerBuilder() {
    return Column(
      children: [
        Text(
          "WELCOME TO NOVA FF\nGAMERS",
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 22.0,
            color: Color(0xff3D4A5A),
          ),
          textAlign: TextAlign.center,
        ),
        SizedBox(
          height: 20.0,
        ),
        Image.asset(
          "assets/images/logo.png",
          width: MediaQuery.of(context).size.width / 2.2,
        ),
      ],
    );
  }

  Widget _buttonsRowBuilder() {
    return Expanded(
      child: Column(
        children: [
          Text(
            "SELECT A MODE",
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 18.0,
              color: Color(0xff3D4A5A),
            ),
          ),
          SizedBox(
            height: 10.0,
          ),
          Row(
            children: [
              _buttonBuilder(
                "FF PUZZLE",
                onPressed: () => setState(() => selectedMode = 0),
                iconData: Icons.bookmarks_outlined,
                active: selectedMode == 0,
              ),
              _buttonBuilder(
                "FF TOURNAMENT",
                onPressed: () => setState(() => selectedMode = 1),
                iconData: Icons.people_alt_outlined,
                active: selectedMode == 1,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buttonBuilder(
    final String title, {
    final Function onPressed,
    final IconData iconData,
    final bool active = false,
  }) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: GestureDetector(
          onTap: onPressed,
          behavior: HitTestBehavior.opaque,
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10.0),
              border: Border.all(color: Color(0xff3D4A5A), width: 2.0),
              color: active ? Color(0xff3D4A5A) : null,
            ),
            padding: const EdgeInsets.all(20.0),
            child: Center(
              child: Column(
                children: [
                  Icon(
                    iconData ?? Icons.book,
                    color: active ? Colors.white : Color(0xff3D4A5A),
                    size: 30.0,
                  ),
                  SizedBox(
                    height: 10.0,
                  ),
                  Text(
                    "$title",
                    style: TextStyle(
                      color: active ? Colors.white : Color(0xff3D4A5A),
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
