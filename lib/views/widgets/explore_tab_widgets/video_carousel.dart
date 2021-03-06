import 'package:flutter/material.dart';
import 'package:peaman/views/widgets/explore_tab_widgets/video_carousel_item.dart';

class VideoCarousel extends StatefulWidget {
  final List<String> links;
  VideoCarousel(this.links);

  @override
  _VideoCarouselState createState() => _VideoCarouselState();
}

class _VideoCarouselState extends State<VideoCarousel> {
  ScrollController _controller;

  @override
  void initState() {
    super.initState();
    _controller = PageController(
      initialPage: widget.links.length ~/ 2,
      viewportFraction: 0.9,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 200.0,
      child: PageView.builder(
        controller: _controller,
        itemCount: widget.links.length,
        itemBuilder: (context, index) {
          return VideoCarouselItem(widget.links[index]);
        },
      ),
    );
  }
}
