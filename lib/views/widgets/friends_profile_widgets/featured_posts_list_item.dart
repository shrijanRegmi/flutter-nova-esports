import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class FeaturedPostListItem extends StatelessWidget {
  final String img;
  final int count;
  FeaturedPostListItem(this.img, this.count);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10.0),
      child: Container(
        height: 200.0,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10.0),
          image: DecorationImage(
            image: CachedNetworkImageProvider(img),
            fit: BoxFit.cover,
          ),
        ),
        child: Align(
          alignment: Alignment.topRight,
          child: _itemCount(),
        ),
      ),
    );
  }

  Widget _itemCount() {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: Container(
        width: 50.0,
        height: 30.0,
        decoration: BoxDecoration(
          color: Colors.black54,
          borderRadius: BorderRadius.circular(10.0),
        ),
        child: Center(
          child: Text(
            '$count',
            style: TextStyle(
              color: Colors.white,
              fontSize: 12.0,
            ),
          ),
        ),
      ),
    );
  }
}
