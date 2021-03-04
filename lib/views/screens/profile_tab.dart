import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:peaman/models/app_models/user_model.dart';
import 'package:peaman/viewmodels/profile_vm.dart';
import 'package:peaman/viewmodels/viewmodel_builder.dart';
import 'package:peaman/views/screens/chat_convo_screen.dart';
import 'package:peaman/views/widgets/common_widgets/border_btn.dart';
import 'package:peaman/views/widgets/profile_tab_widgets/general_settings_list.dart';

class ProfileTab extends StatelessWidget {
  final AppUser friend;
  ProfileTab({this.friend});
  @override
  Widget build(BuildContext context) {
    return ViewmodelProvider<ProfileVm>(
      vm: ProfileVm(context: context),
      builder: (context, vm, appVm, appUser) {
        AppUser _user = friend ?? vm.appUser;
        return Scaffold(
          backgroundColor: Color(0xffF3F5F8),
          body: _user == null
              ? Center(
                  child: Lottie.asset(
                    'assets/lottie/loader.json',
                    width: MediaQuery.of(context).size.width - 100.0,
                    height: MediaQuery.of(context).size.width - 100.0,
                  ),
                )
              : SafeArea(
                  child: Container(
                    child: SingleChildScrollView(
                      physics: BouncingScrollPhysics(),
                      child: Column(
                        children: <Widget>[
                          _user == friend
                              ? _backIconBuilder(context)
                              : SizedBox(
                                  height: 20.0,
                                ),
                          _userDetailBuilder(context, _user),
                          SizedBox(
                            height: _user == friend ? 50.0 : 30.0,
                          ),
                          _user == friend
                              ? _messsageBtnBuilder(context)
                              : Column(
                                  children: <Widget>[
                                    _generalTextBuilder(),
                                    SizedBox(
                                      height: 20.0,
                                    ),
                                    GeneralSettingsList(
                                      appUser: _user,
                                    ),
                                  ],
                                )
                        ],
                      ),
                    ),
                  ),
                ),
        );
      },
    );
  }

  Widget _backIconBuilder(BuildContext context) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: IconButton(
          icon: Icon(Icons.arrow_back_ios),
          color: Color(0xff3D4A5A),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
    );
  }

  Widget _userDetailBuilder(BuildContext context, AppUser appUser) {
    final _width = MediaQuery.of(context).size.width * 0.60;
    return Column(
      children: <Widget>[
        Stack(
          children: <Widget>[
            Positioned.fill(
              child: Center(
                child: Lottie.asset(
                  'assets/lottie/loader.json',
                  width: _width - 50.0,
                  height: _width - 50.0,
                ),
              ),
            ),
            Container(
              width: _width,
              height: _width,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: Colors.white,
                  width: 13.0,
                ),
                boxShadow: [
                  BoxShadow(
                      offset: Offset(2.0, 10.0),
                      blurRadius: 20.0,
                      color: Colors.black12)
                ],
                image: DecorationImage(
                  image: CachedNetworkImageProvider(
                    '${appUser?.photoUrl}',
                  ),
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ],
        ),
        SizedBox(
          height: 20.0,
        ),
        Text(
          '${appUser?.name}',
          style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 26.0,
              color: Color(0xff3D4A5A)),
        ),
        Text(
          '${appUser?.profileStatus}',
          style: TextStyle(fontSize: 16.0, color: Color(0xff3D4A5A)),
        ),
      ],
    );
  }

  Widget _generalTextBuilder() {
    return Padding(
      padding: const EdgeInsets.only(left: 20.0),
      child: Align(
        alignment: Alignment.centerLeft,
        child: Text(
          "General",
          style: TextStyle(
            color: Colors.black38,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  Widget _messsageBtnBuilder(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      child: BorderBtn(
        title: 'Message',
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => ChatConvoScreen(
                fromSearch: true,
                friend: friend,
              ),
            ),
          );
        },
        textColor: Colors.blue[600],
      ),
    );
  }
}
