import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:peaman/models/app_models/tournament_model.dart';
import 'package:peaman/views/screens/tounament_view_screen.dart';

class TournamentListItem extends StatelessWidget {
  final Tournament tournament;
  TournamentListItem(this.tournament);
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(
        left: 20.0,
        right: 20.0,
        bottom: 20.0,
      ),
      child: GestureDetector(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => TournamentViewScreen(tournament),
            ),
          );
        },
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(10.0),
            boxShadow: [
              BoxShadow(
                color: Colors.grey[300],
                blurRadius: 20.0,
              ),
            ],
          ),
          height: 250.0,
          child: Column(
            children: [
              _imgBuilder(),
              _detailsBuilder(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _imgBuilder() {
    return Container(
      height: 150.0,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(10.0),
          topRight: Radius.circular(10.0),
        ),
        image: DecorationImage(
          image: CachedNetworkImageProvider(
            '${tournament.imgUrl}',
          ),
          fit: BoxFit.cover,
        ),
      ),
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.transparent, Colors.black87],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Row(
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                tournament.isRegistered ? _registeredBuilder() : Container(),
                Padding(
                  padding: const EdgeInsets.symmetric(
                      vertical: 5.0, horizontal: 10.0),
                  child: Text(
                    'March 5, 2021 7 PM',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 12.0,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _detailsBuilder() {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: 200.0,
                  child: Text(
                    '${tournament.title}',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                SizedBox(
                  height: 10.0,
                ),
                Row(
                  children: [
                    _typeBuilder(),
                    SizedBox(width: 10.0),
                    _playersCountBuilder(),
                    SizedBox(width: 10.0),
                    _coinBuilder(),
                  ],
                ),
              ],
            ),
          ),
          Icon(
            Icons.arrow_forward_ios,
            size: 15.0,
          ),
        ],
      ),
    );
  }

  Widget _typeBuilder() {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20.0),
        color: Colors.black,
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 3.0, horizontal: 8.0),
        child: Text(
          '${Tournament().getTypeTitle(tournament.type)}',
          style: TextStyle(
            color: Colors.white,
            fontSize: 10.0,
          ),
        ),
      ),
    );
  }

  Widget _coinBuilder() {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20.0),
        color: Color(0xfff6c358).withOpacity(0.3),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 3.0, horizontal: 8.0),
        child: Row(
          children: [
            SvgPicture.asset(
              'assets/images/svgs/coin.svg',
              width: 10.0,
              height: 10.0,
            ),
            SizedBox(
              width: 5.0,
            ),
            Text(
              '${tournament.entryCost}',
              style: TextStyle(
                color: Color(0xffdc8843),
                fontSize: 10.0,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _playersCountBuilder() {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20.0),
        color: Colors.blue,
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 3.0, horizontal: 8.0),
        child: Row(
          children: [
            Icon(
              Icons.person,
              size: 13.0,
              color: Colors.white,
            ),
            SizedBox(
              width: 5.0,
            ),
            Text(
              '${tournament.joinedPlayers} / ${tournament.maxPlayers}',
              style: TextStyle(
                color: Colors.white,
                fontSize: 10.0,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _registeredBuilder() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.green,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(10.0),
          bottomRight: Radius.circular(10.0),
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: 10.0,
          vertical: 4.0,
        ),
        child: Text(
          'Registered',
          style: TextStyle(
            color: Colors.white,
          ),
        ),
      ),
    );
  }
}
