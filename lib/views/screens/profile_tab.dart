import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:peaman/enums/online_status.dart';
import 'package:peaman/models/app_models/user_model.dart';
import 'package:peaman/viewmodels/profile_vm.dart';
import 'package:peaman/viewmodels/viewmodel_builder.dart';
import 'package:peaman/views/widgets/profile_widgets/options_list.dart';

class ProfileTab extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ViewmodelProvider<ProfileVm>(
      vm: ProfileVm(),
      builder: (context, vm, appVm, appUser) {
        return SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(
                height: 10.0,
              ),
              _headerBuilder(appUser),
              SizedBox(
                height: 20.0,
              ),
              _userDetailBuilder(context, appUser),
              SizedBox(
                height: 40.0,
              ),
              OptionsList(),
            ],
          ),
        );
      },
    );
  }

  Widget _userDetailBuilder(BuildContext context, AppUser appUser) {
    final _width = MediaQuery.of(context).size.width * 0.50;
    return Column(
      children: <Widget>[
        Container(
          width: _width,
          height: _width,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(
              color: Colors.white,
              width: 10.0,
            ),
            boxShadow: [
              BoxShadow(
                offset: Offset(2.0, 10.0),
                blurRadius: 20.0,
                color: Colors.black12,
              )
            ],
            image: appUser.photoUrl == null
                ? null
                : DecorationImage(
                    image: CachedNetworkImageProvider('${appUser.photoUrl}'),
                    fit: BoxFit.cover,
                  ),
          ),
          child: appUser.photoUrl == null
              ? SvgPicture.asset(
                  'assets/images/svgs/upload_img.svg',
                )
              : Container(),
        ),
        SizedBox(
          height: 20.0,
        ),
        Text(
          '${appUser.name}',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 24.0,
            color: Color(0xff3D4A5A),
          ),
        ),
        SizedBox(
          height: 8.0,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircleAvatar(
              radius: 4.0,
              backgroundColor: appUser.onlineStatus == OnlineStatus.active
                  ? Colors.green
                  : Color(0xff9496ab),
            ),
            SizedBox(
              width: 8.0,
            ),
            Text(
              'Active Status',
              style: TextStyle(
                fontSize: 12.0,
                color: Color(0xff3D4A5A),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _headerBuilder(final AppUser appUser) {
    return Container(
      padding: const EdgeInsets.only(left: 20.0, top: 10.0),
      child: Row(
        children: [
          SvgPicture.asset(
            'assets/images/svgs/coin.svg',
            width: 50.0,
            height: 50.0,
          ),
          SizedBox(
            width: 10.0,
          ),
          Text(
            '${appUser.coins} Coins',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 16.0,
              color: Color(0xff3D4A5A),
            ),
          ),
        ],
      ),
    );
  }
}
