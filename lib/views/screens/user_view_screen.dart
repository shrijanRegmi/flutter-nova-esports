import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:peaman/models/app_models/user_model.dart';
import 'package:peaman/viewmodels/user_view_vm.dart';
import 'package:peaman/viewmodels/viewmodel_builder.dart';
import 'package:peaman/views/widgets/common_widgets/appbar.dart';
import 'package:peaman/views/widgets/common_widgets/filled_btn.dart';
import 'package:peaman/views/widgets/create_tournament_widgets/new_tournament_field.dart';

class UserViewScreen extends StatelessWidget {
  final AppUser user;
  UserViewScreen(this.user);

  @override
  Widget build(BuildContext context) {
    return ViewmodelProvider<UserViewVm>(
      vm: UserViewVm(context),
      onInit: (vm) => vm.onInit(user),
      builder: (context, vm, appVm, appUser) {
        return Scaffold(
          appBar: PreferredSize(
            preferredSize: Size.fromHeight(60.0),
            child: CommonAppbar(
              title: Text(
                'View User',
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
                color: Colors.transparent,
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    children: [
                      _imgBuilder(context, appUser, vm),
                      SizedBox(
                        height: 20.0,
                      ),
                      _inputFieldsBuilder(vm),
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

  Widget _imgBuilder(
      final BuildContext context, final AppUser appUser, final UserViewVm vm) {
    final _width = MediaQuery.of(context).size.width * 0.50;
    return Column(
      children: [
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
            image: vm.photo == null
                ? null
                : DecorationImage(
                    image: vm.photo.path.contains('.com')
                        ? CachedNetworkImageProvider('${vm.photo.path}')
                        : FileImage(vm.photo),
                    fit: BoxFit.cover,
                  ),
          ),
          child: vm.photo == null
              ? SvgPicture.asset(
                  'assets/images/svgs/upload_img.svg',
                  color: Colors.grey,
                )
              : Container(),
        ),
        SizedBox(
          height: 20.0,
        ),
        FilledBtn(
          title: !vm.isWorker ? 'Make Worker' : 'Remove From Worker',
          minWidth: 120.0,
          color: Color(0xff3D4A5A),
          onPressed: () => vm.makeWorker(user),
        ),
      ],
    );
  }

  Widget _inputFieldsBuilder(final UserViewVm vm) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _inputFieldItem(
          'Username',
          'Username',
          vm.nameController,
          onTapped: () {},
        ),
        SizedBox(
          height: 20.0,
        ),
        _inputFieldItem(
          'Email',
          'Email',
          vm.emailController,
          onTapped: () {},
        ),
        SizedBox(
          height: 20.0,
        ),
        _inputFieldItem(
          'In-Game Name',
          'In-Game Name',
          vm.inGameNameController,
          onTapped: () {},
        ),
        SizedBox(
          height: 20.0,
        ),
        _inputFieldItem(
          'In-Game Id',
          'In-Game Id',
          vm.inGameIdController,
          onTapped: () {},
        ),
        SizedBox(
          height: 20.0,
        ),
        _inputFieldItem(
          'Phone Number',
          'Phone number',
          vm.phoneController,
          onTapped: () {},
        ),
        SizedBox(
          height: 20.0,
        ),
        _inputFieldItem(
          'Location',
          'Location',
          vm.addressController,
          onTapped: () {},
        ),
        SizedBox(
          height: 20.0,
        ),
      ],
    );
  }

  Widget _inputFieldItem(final String title, final String hintText,
      final TextEditingController controller,
      {final Function onTapped, final bool isLoading = false}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(
              '$title',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Color(0xff3D4A5A),
              ),
            ),
            SizedBox(
              width: 10.0,
            ),
            if (isLoading)
              Container(
                width: 19.0,
                height: 19.0,
                child: CircularProgressIndicator(
                  strokeWidth: 3.0,
                ),
              ),
          ],
        ),
        SizedBox(
          height: 15.0,
        ),
        NewTournamentField(
          hintText: '$hintText',
          requiredCapitalization: false,
          controller: controller,
          onTapped: onTapped,
        ),
      ],
    );
  }
}
