import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class PhotosItem extends StatelessWidget {
  final String img;
  PhotosItem(this.img);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 100.0,
      height: 100.0,
      decoration: BoxDecoration(
        color: Color(0xff3D4A5A).withOpacity(0.1),
        borderRadius: BorderRadius.circular(10.0),
        image: DecorationImage(
          image: CachedNetworkImageProvider(img),
          fit: BoxFit.cover,
        ),
      ),
    );
  }
}
