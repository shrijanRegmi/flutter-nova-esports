import 'package:flutter/material.dart';
import 'package:peaman/models/app_models/video_stream_model.dart';
import 'package:peaman/views/screens/create_video_stream_screen.dart';
import 'package:peaman/views/widgets/explore_tab_widgets/video_carousel_item.dart';

class VideoCarousel extends StatefulWidget {
  final List<VideoStream> videoStreams;
  VideoCarousel(this.videoStreams);

  @override
  _VideoCarouselState createState() => _VideoCarouselState();
}

class _VideoCarouselState extends State<VideoCarousel> {
  ScrollController _controller;

  @override
  void initState() {
    super.initState();
    _controller = PageController(
      initialPage: widget.videoStreams.length ~/ 2,
      viewportFraction: 0.9,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _titleBuilder(),
        Container(
          height: 200.0,
          child: PageView.builder(
            controller: _controller,
            itemCount: widget.videoStreams.length,
            itemBuilder: (context, index) {
              return VideoCarouselItem(widget.videoStreams[index]);
            },
          ),
        ),
      ],
    );
  }

  Widget _titleBuilder() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            'Video Streams',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 18.0,
              color: Color(0xff3D4A5A),
            ),
          ),
          IconButton(
            icon: Icon(Icons.add),
            splashRadius: 20.0,
            color: Color(0xff3D4A5A),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => CreateVideoStreamScreen(
                      videoStreams: widget.videoStreams),
                ),
              );
            },
          )
        ],
      ),
    );
  }
}