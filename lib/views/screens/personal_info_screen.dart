import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:lottie/lottie.dart';
import 'package:peaman/viewmodels/profile_info_vm.dart';
import 'package:peaman/viewmodels/viewmodel_builder.dart';
import 'package:peaman/views/widgets/common_widgets/appbar.dart';
import 'package:peaman/views/widgets/common_widgets/filled_btn.dart';

class PersonalInfoScreen extends StatefulWidget {
  final String uid;
  final String imgUrl;
  final String name;
  final String email;
  final String status;
  PersonalInfoScreen({
    @required this.uid,
    @required this.imgUrl,
    @required this.name,
    @required this.email,
    @required this.status,
  });

  @override
  _PersonalInfoScreenState createState() => _PersonalInfoScreenState();
}

class _PersonalInfoScreenState extends State<PersonalInfoScreen> {
  final TextEditingController _nameController = TextEditingController();

  final TextEditingController _emailController = TextEditingController();

  final TextEditingController _statusController = TextEditingController();

  File _imgFile;

  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    return ViewmodelProvider(
      vm: ProfileInfoVm(),
      builder: (context, vm, appVm, appUser) {
        return Scaffold(
          backgroundColor: Color(0xffF3F5F8),
          appBar: _isLoading
              ? null
              : PreferredSize(
                  preferredSize: Size.fromHeight(60.0),
                  child: CommonAppbar(
                    title: Text(
                      'Profile information',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 20.0,
                        color: Color(0xff3D4A5A),
                      ),
                    ),
                  ),
                ),
          body: _isLoading
              ? Center(
                  child: Lottie.asset(
                    'assets/lottie/loader.json',
                    width: MediaQuery.of(context).size.width - 100.0,
                    height: MediaQuery.of(context).size.width - 100.0,
                  ),
                )
              : Container(
                  child: GestureDetector(
                    onTap: () {
                      FocusScope.of(context).unfocus();
                    },
                    child: Container(
                      color: Colors.transparent,
                      child: SingleChildScrollView(
                        child: Column(
                          children: <Widget>[
                            SizedBox(
                              height: 20.0,
                            ),
                            _userImageBuilder(context),
                            SizedBox(
                              height: 50.0,
                            ),
                            _inputFieldBuilder(),
                            SizedBox(
                              height: 30.0,
                            ),
                            _btnSection(vm.updateUsersData),
                            SizedBox(
                              height: 20.0,
                            ),
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

  Widget _userImageBuilder(BuildContext context) {
    final _width = MediaQuery.of(context).size.width * 0.60;
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.end,
      children: <Widget>[
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
              image: _imgFile != null
                  ? FileImage(_imgFile)
                  : CachedNetworkImageProvider(
                      widget.imgUrl,
                    ),
              fit: BoxFit.cover,
            ),
          ),
        ),
        GestureDetector(
          onTap: () async {
            final _pickedImg = await ImagePicker().getImage(
              source: ImageSource.gallery,
              imageQuality: 20,
              maxHeight: 500.0,
              maxWidth: 500.0,
            );
            File _myImg = _pickedImg != null ? File(_pickedImg.path) : null;

            setState(() {
              _imgFile = _myImg;
            });
          },
          child: Container(
            width: 40.0,
            height: 40.0,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(
                color: Color(0xff3D4A5A),
              ),
              color: Color(0xffF3F5F8),
            ),
            child: Center(
              child: Icon(
                Icons.photo_camera,
                size: 20.0,
                color: Color(0xff3D4A5A),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _inputFieldBuilder() {
    final _height = 20.0;
    return Column(
      children: <Widget>[
        _inputFieldItemBuilder('Name', widget.name, _nameController),
        // SizedBox(
        //   height: _height,
        // ),
        // _inputFieldItemBuilder('Email', widget.email, _emailController),
        SizedBox(
          height: _height,
        ),
        _inputFieldItemBuilder('Status', widget.status, _statusController),
      ],
    );
  }

  Widget _inputFieldItemBuilder(final String _label, final String _initValue,
      final TextEditingController _controller) {
    if (_controller.text == '') {
      _controller.text = _initValue;
    }
    _controller.selection = TextSelection.fromPosition(
        TextPosition(offset: _controller.text.length));
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      child: Container(
        child: TextFormField(
          controller: _controller,
          style: TextStyle(
            fontSize: 14.0,
          ),
          decoration: InputDecoration(
            labelText: _label,
            labelStyle: TextStyle(
              fontSize: 14.0,
              color: Color(0xff3D4A5A),
            ),
            border: OutlineInputBorder(),
            focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(
                color: Color(0xff3D4A5A),
                width: 1.0,
              ),
            ),
            contentPadding: const EdgeInsets.symmetric(
              vertical: 3.0,
              horizontal: 10.0,
            ),
          ),
        ),
      ),
    );
  }

  Widget _btnSection(Function updateUserData) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      child: FilledBtn(
        title: 'Save',
        color: Colors.blue[600],
        onPressed: () async {
          final _uid = widget.uid;
          final _name = _nameController.text.trim();
          final _email = _emailController.text.trim();
          final _status = _statusController.text.trim();

          final Map<String, dynamic> _data = {
            'name': _name,
            'email': _email,
            'profile_status': _status,
          };

          _data.removeWhere((key, value) =>
              value == widget.name ||
              value == widget.email ||
              value == widget.status);

          setState(() {
            _isLoading = true;
          });

          final _result = await updateUserData(
            uid: _uid,
            data: _data,
            imgFile: _imgFile,
          );

          if (_result == null) {
            setState(() {
              _isLoading = false;
            });
          } else {
            Navigator.pop(context);
          }
        },
      ),
    );
  }
}
