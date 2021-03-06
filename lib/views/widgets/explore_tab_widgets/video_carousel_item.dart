import 'package:flutter/material.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

class VideoCarouselItem extends StatefulWidget {
  final String link;
  VideoCarouselItem(this.link);

  @override
  _VideoCarouselItemState createState() => _VideoCarouselItemState();
}

class _VideoCarouselItemState extends State<VideoCarouselItem> {
  YoutubePlayerController _controller;
  @override
  void initState() {
    super.initState();
    _controller = YoutubePlayerController(
      initialVideoId: '${widget.link}',
      flags: YoutubePlayerFlags(
        autoPlay: false,
        isLive: true,
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 6.0),
      child: Container(
        child: YoutubePlayer(
          controller: _controller,
        ),
      ),
    );
  }
}
