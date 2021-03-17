import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:lottie/lottie.dart';
import 'package:peaman/models/app_models/user_model.dart';
import 'package:peaman/viewmodels/edit_profile_vm.dart';
import 'package:peaman/viewmodels/viewmodel_builder.dart';
import 'package:peaman/views/widgets/common_widgets/appbar.dart';
import 'package:peaman/views/widgets/common_widgets/filled_btn.dart';
import 'package:peaman/views/widgets/create_tournament_widgets/new_tournament_field.dart';
import 'package:provider/provider.dart';

class EditProfileScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final _appUser = Provider.of<AppUser>(context);
    return ViewmodelProvider<EditProfileVm>(
      vm: EditProfileVm(context),
      onInit: (vm) => vm.onInit(_appUser),
      builder: (context, vm, appVm, appUser) {
        return Scaffold(
          appBar: vm.isLoading
              ? null
              : PreferredSize(
                  preferredSize: Size.fromHeight(60.0),
                  child: CommonAppbar(
                    title: Text(
                      'Edit Profile',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 20.0,
                        color: Color(0xff3D4A5A),
                      ),
                    ),
                  ),
                ),
          body: vm.isLoading
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
                            'Loading...',
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
          bottomNavigationBar: vm.isLoading
              ? null
              : Padding(
                  padding: MediaQuery.of(context).viewInsets,
                  child: _editBtnBuilder(context, appUser, vm),
                ),
        );
      },
    );
  }

  Widget _imgBuilder(final BuildContext context, final AppUser appUser,
      final EditProfileVm vm) {
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
          height: 10.0,
        ),
        TextButton(
          onPressed: vm.getPhotoFromGallery,
          child: Text(
            vm.photo == null ? 'UPLOAD' : 'CHANGE',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 16.0,
              color: Color(0xff3D4A5A),
            ),
          ),
        ),
      ],
    );
  }

  Widget _inputFieldsBuilder(final EditProfileVm vm) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _inputFieldItem(
          'Your Username',
          'Enter Username',
          vm.nameController,
        ),
      ],
    );
  }

  Widget _inputFieldItem(final String title, final String hintText,
      final TextEditingController controller) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '$title',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Color(0xff3D4A5A),
          ),
        ),
        SizedBox(
          height: 15.0,
        ),
        NewTournamentField(
          hintText: '$hintText',
          requiredCapitalization: false,
          controller: controller,
        ),
      ],
    );
  }

  Widget _editBtnBuilder(final BuildContext context, final AppUser appUser,
      final EditProfileVm vm) {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: FilledBtn(
        title: 'Save Changes',
        minWidth: MediaQuery.of(context).size.width,
        color: Color(0xff5C49E0),
        onPressed: () => vm.editProfile(appUser),
      ),
    );
  }
}
