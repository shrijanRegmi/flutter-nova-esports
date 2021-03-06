import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:peaman/models/app_models/tournament_model.dart';
import 'package:peaman/views/screens/match_up_screen.dart';
import 'package:peaman/views/widgets/tournament_widgets/updates_list.dart';

class TournamentViewScreen extends StatelessWidget {
  final Tournament tournament;
  TournamentViewScreen(this.tournament);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            _headerBuilder(context),
            SizedBox(
              height: 60.0,
            ),
            UpdatesList(),
          ],
        ),
      ),
      bottomNavigationBar: Padding(
        padding: MediaQuery.of(context).viewInsets,
        child: _playBtnBuilder(),
      ),
    );
  }

  Widget _headerBuilder(final BuildContext context) {
    return Stack(
      overflow: Overflow.visible,
      children: [
        _imgBuilder(),
        Positioned(
          bottom: -33.0,
          left: 0.0,
          right: 0.0,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _actionBtnBuilder(context),
            ],
          ),
        ),
      ],
    );
  }

  Widget _imgBuilder() {
    return Stack(
      children: [
        Container(
          height: 200.0,
          decoration: BoxDecoration(
            image: DecorationImage(
              image: CachedNetworkImageProvider(tournament.imgUrl),
              fit: BoxFit.cover,
            ),
          ),
        ),
        Container(
          height: 200.0,
          decoration: BoxDecoration(
            color: Colors.black45,
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _liveBuilder(),
                SizedBox(
                  height: 20.0,
                ),
                Text(
                  '${tournament.title}',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                    fontSize: 16.0,
                  ),
                  textAlign: TextAlign.center,
                ),
                Text(
                  'March 5, 2021 7 PM',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 14.0,
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _actionBtnBuilder(final BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10.0),
        boxShadow: [
          BoxShadow(
            color: Colors.grey[300],
            offset: Offset(0.0, 3.0),
            blurRadius: 10.0,
          ),
        ],
      ),
      padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
      child: Row(
        children: [
          _btnBuilder(Icons.assignment, 'Details', () {}),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 25.0),
            child: Container(
              height: 40.0,
              width: 2.0,
              color: Colors.grey[300],
            ),
          ),
          _btnBuilder(
            Icons.mediation,
            'Match-ups',
            () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => MatchUpScreen(tournament),
                ),
              );
            },
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 25.0),
            child: Container(
              height: 40.0,
              width: 2.0,
              color: Colors.grey[300],
            ),
          ),
          _btnBuilder(Icons.chat, 'Chat', () {}),
        ],
      ),
    );
  }

  Widget _btnBuilder(
      final IconData icon, final String title, final Function onPressed) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        color: Colors.white,
        child: Column(
          children: [
            Icon(icon),
            SizedBox(
              height: 5.0,
            ),
            Text(
              '$title',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 12.0,
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget _liveBuilder() {
    return Center(
      child: Container(
        decoration: BoxDecoration(
          color: Colors.red,
          borderRadius: BorderRadius.circular(10.0),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 5.0, horizontal: 10.0),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.circle,
                color: Colors.white,
                size: 10.0,
              ),
              SizedBox(
                width: 5.0,
              ),
              Text(
                'Live',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _playBtnBuilder() {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: MaterialButton(
        onPressed: () {},
        color: Color(0xffdc8843),
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'PLAY',
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
                    '${tournament.entryCost}',
                    style: TextStyle(
                      // color: Color(0xffdc8843),
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
      ),
    );
  }
}
