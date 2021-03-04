import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:photo_view/photo_view.dart';

class PhotoViewerScreen extends StatelessWidget {
  final String photo;
  PhotoViewerScreen(this.photo);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          PhotoView(
            imageProvider: CachedNetworkImageProvider(photo),
            maxScale: PhotoViewComputedScale.contained,
          ),
          Positioned(
            top: 50.0,
            left: 10.0,
            child: FloatingActionButton(
              child: Padding(
                padding: const EdgeInsets.only(left: 8.0),
                child: Icon(Icons.arrow_back_ios),
              ),
              onPressed: () => Navigator.pop(context),
            ),
          ),
        ],
      ),
    );
  }
}
