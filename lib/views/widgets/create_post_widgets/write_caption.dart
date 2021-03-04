import 'package:flutter/material.dart';
import 'package:peaman/viewmodels/create_post_vm.dart';

class WriteCaption extends StatelessWidget {
  final CreatePostVm vm;
  WriteCaption(this.vm);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _writeCaptionTextBuilder(),
          SizedBox(
            height: 10.0,
          ),
          _textAreaBuilder(),
        ],
      ),
    );
  }

  Widget _writeCaptionTextBuilder() {
    return Text(
      'Write Caption',
      style: TextStyle(
        fontWeight: FontWeight.w600,
        color: Color(0xff3D4A5A),
        fontSize: 14.0,
      ),
    );
  }

  Widget _textAreaBuilder() {
    return Container(
      child: TextFormField(
        controller: vm.captionController,
        maxLines: 5,
        decoration: InputDecoration(
          border: OutlineInputBorder(
            borderSide: BorderSide(
              width: 0.1,
            ),
          ),
          hintText: 'Type a caption...',
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(
              color: Colors.black,
            ),
          ),
        ),
      ),
    );
  }
}
