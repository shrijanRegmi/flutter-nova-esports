import 'package:flutter/material.dart';
import 'package:peaman/models/app_models/user_model.dart';
import 'package:peaman/views/widgets/common_widgets/avatar_builder.dart';

class DialogProvider {
  final BuildContext context;
  DialogProvider(this.context);

  // show this when user taps on add moment button if they already have a story posted
  showLimitedMomentDialog() async {
    await showDialog(
      context: context,
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

  // show this to warn the user
  showWarningDialog(
    final String title,
    final String description,
    final Function onPressed, {
    final bool requiredCancelBtn = false,
  }) async {
    return await showDialog(
      context: context,
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
