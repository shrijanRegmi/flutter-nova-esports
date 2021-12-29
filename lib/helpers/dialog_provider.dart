import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:geolocator/geolocator.dart';
import 'package:image_picker/image_picker.dart';
import 'package:peaman/models/app_models/user_model.dart';
import 'package:peaman/views/widgets/common_widgets/avatar_builder.dart';

class DialogProvider {
  final BuildContext context;
  DialogProvider(this.context);

  // show this when user taps on add moment button if they already have a story posted
  showLimitedMomentDialog() async {
    await showDialog(
      context: context,
      useRootNavigator: false,
      builder: (context) => AlertDialog(
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(
              height: 20.0,
            ),
            _addMomentBuilder(),
            SizedBox(
              height: 20.0,
            ),
            Text(
              'Oops! You can only post one moment until previous has expired.',
              textAlign: TextAlign.center,
            ),
          ],
        ),
        actions: [
          TextButton(
            child: Text(
              'Got it!',
              style: TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.bold,
              ),
            ),
            onPressed: () {
              Navigator.pop(context);
            },
          )
        ],
      ),
    );
  }

  // show this when the friend that user is trying to call is already in call
  showAlreadyInCallDialog(final AppUser friend) async {
    await showDialog(
      context: context,
      useRootNavigator: false,
      builder: (context) => AlertDialog(
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(
              height: 20.0,
            ),
            _userDetailsBuilder(friend),
            SizedBox(
              height: 20.0,
            ),
            Text(
              'Oops! It seems like ${friend.name} is already in a call. Try calling later.',
              textAlign: TextAlign.center,
            ),
          ],
        ),
        actions: [
          TextButton(
            child: Text(
              'Got it!',
              style: TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.bold,
              ),
            ),
            onPressed: () {
              Navigator.pop(context);
            },
          )
        ],
      ),
    );
  }

  // show this when friend that user is trying to call is not online
  showFriendNotOnlineDialog(final AppUser friend) async {
    await showDialog(
      context: context,
      useRootNavigator: false,
      builder: (context) => AlertDialog(
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(
              height: 20.0,
            ),
            _userDetailsBuilder(friend),
            SizedBox(
              height: 20.0,
            ),
            Text(
              'Oops! It seems like ${friend.name} is not online. Try calling later when you see them online.',
              textAlign: TextAlign.center,
            ),
          ],
        ),
        actions: [
          TextButton(
            child: Text(
              'Got it!',
              style: TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.bold,
              ),
            ),
            onPressed: () {
              Navigator.pop(context);
            },
          )
        ],
      ),
    );
  }

  // show this to confirm something
  showConfirmationDialog(
    final String title,
    final Function onPressed, {
    final String description,
  }) async {
    return await showDialog(
      context: context,
      useRootNavigator: false,
      builder: (_) => AlertDialog(
        title: Text('$title'),
        content: description != null ? Text('$description') : null,
        actions: [
          TextButton(
            child: Text(
              'No',
              style: TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.bold,
              ),
            ),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
          TextButton(
            child: Text(
              'Yes',
              style: TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.bold,
              ),
            ),
            onPressed: () {
              Navigator.pop(context);
              onPressed();
            },
          ),
        ],
      ),
    );
  }

  // show this when location permission is denied multiple times
  showLocationPermissionDeniedDialog() async {
    return await showDialog(
      context: context,
      useRootNavigator: false,
      builder: (_) => AlertDialog(
        title: Text('Location permission denied multiple times'),
        content: Text(
          'You need to accept location permission to continue. It looks like you have denied location permission multiple times. Please goto you app settings and turn on location permission for this app manually and try signing up in the app.',
        ),
        actions: [
          TextButton(
            child: Text(
              'Cancel',
              style: TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.bold,
              ),
            ),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
          TextButton(
            child: Text(
              'GOTO SETTINGS',
              style: TextStyle(
                color: Colors.blue,
                fontWeight: FontWeight.bold,
              ),
            ),
            onPressed: () {
              Geolocator.openLocationSettings();
              Navigator.pop(context);
            },
          ),
        ],
      ),
    );
  }

  // show this to warn the user
  showWarningDialog(
    final String title,
    final String description,
    final Function onPressed, {
    final bool requiredCancelBtn = false,
  }) async {
    return await showDialog(
      context: context,
      // useRootNavigator: false,
      builder: (_) => AlertDialog(
        title: Text('$title'),
        content: Text('$description'),
        actions: [
          if (requiredCancelBtn)
            TextButton(
              child: Text(
                'Cancel',
                style: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                ),
              ),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
          TextButton(
            child: Text(
              'OK, Got it!',
              style: TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.bold,
              ),
            ),
            onPressed: () {
              Navigator.pop(context);
              onPressed();
            },
          ),
        ],
      ),
    );
  }

  // show this when user wants to join private tournament
  showPrivateTournamentDialog(final TextEditingController passController,
      final Function onPressed) async {
    return await showDialog(
      context: context,
      useRootNavigator: false,
      builder: (_) => AlertDialog(
        title: Text('Enter password'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextFormField(
              style: TextStyle(
                fontSize: 14.0,
              ),
              controller: passController,
              decoration: InputDecoration(
                hintText: 'Eg: EViYEhEnLLHkO8ObUVyx',
              ),
            ),
            SizedBox(
              height: 20.0,
            ),
            Text(
              'This is a private tournament. You need to enter password to register.',
              style: TextStyle(
                color: Colors.grey,
                fontSize: 12.0,
                // fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            child: Text(
              'Cancel',
              style: TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.bold,
              ),
            ),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
          TextButton(
            child: Text(
              'Done',
              style: TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.bold,
              ),
            ),
            onPressed: () {
              Navigator.pop(context);
              onPressed();
            },
          ),
        ],
      ),
    );
  }

  // show this when admin wants to search user
  showAdminSearchDialog(
      final TextEditingController controller, final Function onPressed) async {
    return await showDialog(
      context: context,
      useRootNavigator: false,
      builder: (_) => AlertDialog(
        title: Text('Search User'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextFormField(
              style: TextStyle(
                fontSize: 14.0,
              ),
              controller: controller,
              decoration: InputDecoration(
                hintText: 'Type something...',
              ),
            ),
            SizedBox(
              height: 20.0,
            ),
            Text(
              'You can search user using email, in-game-id or in-game-name.',
              style: TextStyle(
                color: Colors.grey,
                fontSize: 12.0,
                // fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            child: Text(
              'Cancel',
              style: TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.bold,
              ),
            ),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
          TextButton(
            child: Text(
              'Search',
              style: TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.bold,
              ),
            ),
            onPressed: () {
              Navigator.pop(context);
              onPressed();
            },
          ),
        ],
      ),
    );
  }

  // show this when user earns coins through video
  showCoinsEarnDialog(final int coins, final Function onPressed) async {
    return await showDialog(
      context: context,
      useRootNavigator: false,
      builder: (_) => AlertDialog(
        title: Text('Good Job !'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              // mainAxisAlignment: MainAxisAlignment.center,
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
                  '$coins Coins',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16.0,
                  ),
                ),
              ],
            ),
            SizedBox(
              height: 20.0,
            ),
            Text(
              'Congrats! You have earned $coins coins. You can also view this in your profile tab.',
            ),
          ],
        ),
        actions: [
          TextButton(
            child: Text(
              'OK, Got it!',
              style: TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.bold,
              ),
            ),
            onPressed: () {
              Navigator.pop(context);
              onPressed();
            },
          ),
        ],
      ),
    );
  }

  // show this when admin wants to add something about the app
  showEditAboutDialog(
    final TextEditingController aboutController,
    final TextEditingController appLinkController,
    final Function onPressed,
  ) async {
    return await showDialog(
      context: context,
      useRootNavigator: false,
      builder: (_) => AlertDialog(
        title: Text('About the app'),
        content: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              height: 200.0,
              child: TextFormField(
                style: TextStyle(
                  fontSize: 14.0,
                ),
                minLines: 10,
                maxLines: 10,
                controller: aboutController,
                decoration: InputDecoration(
                  hintText: 'About Novaesports',
                  border: OutlineInputBorder(),
                ),
              ),
            ),
            SizedBox(
              height: 20.0,
            ),
            Text(
              'App Link',
              style: TextStyle(
                color: Colors.grey,
                fontSize: 12.0,
              ),
            ),
            SizedBox(
              height: 10.0,
            ),
            TextFormField(
              style: TextStyle(
                fontSize: 14.0,
              ),
              controller: appLinkController,
              decoration: InputDecoration(
                hintText: 'App Link',
                border: OutlineInputBorder(),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            child: Text(
              'Cancel',
              style: TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.bold,
              ),
            ),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
          TextButton(
            child: Text(
              'Done',
              style: TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.bold,
              ),
            ),
            onPressed: () {
              Navigator.pop(context);
              onPressed();
            },
          ),
        ],
      ),
    );
  }

  // show this when admin wants to add support email
  showSupportEmailDialog(
    final TextEditingController supportEmailController,
    final Function onPressed,
  ) async {
    return await showDialog(
      context: context,
      useRootNavigator: false,
      builder: (_) => AlertDialog(
        title: Text('Enter Support Email'),
        content: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            TextFormField(
              style: TextStyle(
                fontSize: 14.0,
              ),
              controller: supportEmailController,
              decoration: InputDecoration(
                hintText: 'Support Email',
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            child: Text(
              'Cancel',
              style: TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.bold,
              ),
            ),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
          TextButton(
            child: Text(
              'Done',
              style: TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.bold,
              ),
            ),
            onPressed: () {
              Navigator.pop(context);
              onPressed();
            },
          ),
        ],
      ),
    );
  }

  // show this when admin wants to add support email
  showAddSocialLinksDialog({
    final TextEditingController linkController,
    final Function(File) onPressed,
    final Function onSelectImage,
  }) async {
    File _socialImg;
    return await showDialog(
      context: context,
      useRootNavigator: false,
      builder: (_) => StatefulBuilder(
        builder: (context, setState) {
          return AlertDialog(
            title: Text('Enter social link and image url'),
            content: Container(
              height: 160.0,
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    _socialImg != null
                        ? Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Image.file(
                                _socialImg,
                                width: 100.0,
                                height: 100.0,
                              ),
                            ],
                          )
                        : MaterialButton(
                            onPressed: () async {
                              final _pickedImg = await ImagePicker().getImage(
                                source: ImageSource.gallery,
                              );
                              if (_pickedImg != null) {
                                setState(() {
                                  _socialImg = File(_pickedImg.path);
                                });
                              }
                            },
                            color: Colors.blue,
                            textColor: Colors.white,
                            child: Text('Add Image'),
                          ),
                    SizedBox(
                      height: 10.0,
                    ),
                    TextFormField(
                      style: TextStyle(
                        fontSize: 14.0,
                      ),
                      controller: linkController,
                      decoration: InputDecoration(
                        hintText: 'Enter Social Link',
                      ),
                    ),
                  ],
                ),
              ),
            ),
            actions: [
              TextButton(
                child: Text(
                  'Cancel',
                  style: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                onPressed: () {
                  setState(() {
                    _socialImg = null;
                  });
                  Navigator.pop(context);
                },
              ),
              TextButton(
                child: Text(
                  'Done',
                  style: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                onPressed: () {
                  final _newImg = _socialImg;
                  setState(() {
                    _socialImg = null;
                  });
                  Navigator.pop(context);
                  onPressed(_newImg);
                },
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _addMomentBuilder() {
    return Container(
      color: Colors.transparent,
      child: Padding(
        padding: const EdgeInsets.only(left: 10.0, right: 10.0),
        child: Column(
          children: [
            Container(
              width: 62.0,
              height: 62.0,
              decoration: BoxDecoration(
                color: Colors.pink.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: Center(
                child: Icon(
                  Icons.add,
                  color: Colors.pink,
                ),
              ),
            ),
            SizedBox(
              height: 5.0,
            ),
            Text(
              'My moment',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 12.0,
                color: Color(0xff3D4A5A),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _userDetailsBuilder(final AppUser appUser) {
    return Column(
      children: [
        AvatarBuilder(
          imgUrl: appUser.photoUrl,
          radius: 31.0,
        ),
        SizedBox(
          height: 5.0,
        ),
        Text(
          '${appUser.name}',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 12.0,
            color: Color(0xff3D4A5A),
          ),
        ),
      ],
    );
  }
}
