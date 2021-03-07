import 'package:flutter/material.dart';
import 'package:peaman/models/app_models/video_stream_model.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

class VideoCarouselItem extends StatefulWidget {
  final VideoStream videoStream;
  VideoCarouselItem(this.videoStream);

  @override
  _VideoCarouselItemState createState() => _VideoCarouselItemState();
}

class _VideoCarouselItemState extends State<VideoCarouselItem> {
  YoutubePlayerController _controller;
  @override
  void initState() {
    super.initState();
    _controller = YoutubePlayerController(
      initialVideoId: widget.videoStream.link.contains('youtu.be/')
          ? '${widget.videoStream.link.split('.be/').last}'
          : '${widget.videoStream.link.split('v=').last}',
      flags: YoutubePlayerFlags(
        autoPlay: false,
        isLive: widget.videoStream.isLive,
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
