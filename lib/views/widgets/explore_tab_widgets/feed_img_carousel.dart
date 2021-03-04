import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:peaman/models/app_models/user_model.dart';

class FeedImageCarousel extends StatefulWidget {
  @override
  _FeedImageCarouselState createState() => _FeedImageCarouselState();

  final List<String> photos;
  final Function reactToPost;
  final AppUser appUser;
  FeedImageCarousel(
    this.photos,
    this.reactToPost,
    this.appUser,
  );
}

class _FeedImageCarouselState extends State<FeedImageCarousel>
    with SingleTickerProviderStateMixin {
  ScrollController _pageViewController;
  AnimationController _animationController;

  bool _isLiked = false;

  @override
  void initState() {
    super.initState();
    _pageViewController = PageController(
      initialPage: widget.photos.length ~/ 3,
      viewportFraction: widget.photos.length != 1 ? 0.8 : 1.0,
    );
    _animationController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 1300),
    );

    _animationController.addListener(() {
      if (_animationController.isCompleted) {
        setState(() {
          _isLiked = false;
        });
      }
    });
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 250.0,
      child: PageView.builder(
        controller: _pageViewController,
        itemCount: widget.photos.length,
        itemBuilder: (context, index) {
          return GestureDetector(
            onDoubleTap: () {
              widget.reactToPost(widget.appUser);
              setState(() {
                _isLiked = !_isLiked;
              });
              _animationController.reset();
              _animationController.forward();
            },
            child: Stack(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10.0),
                  child: Container(
                    width: MediaQuery.of(context).size.width,
                    decoration: BoxDecoration(
                      color: Color(0xff3D4A5A).withOpacity(0.1),
                      borderRadius: BorderRadius.circular(20.0),
                      image: DecorationImage(
                        image: CachedNetworkImageProvider(widget.photos[index]),
                        fit: BoxFit.cover,
                      ),
                    ),
                    child: Align(
                      alignment: Alignment.topRight,
                      child: _itemCount(index + 1),
                    ),
                  ),
                ),
                _isLiked
                    ? Positioned.fill(
                        child: Lottie.asset(
                          'assets/lottie/love.json',
                          repeat: false,
                          controller: _animationController,
                          onLoaded: (composition) {
                            _animationController
                              ..duration = Duration(
                                milliseconds:
                                    composition.duration.inMilliseconds - 700,
                              )
                              ..forward();
                          },
                        ),
                      )
                    : Container(),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _itemCount(final int count) {
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
            '$count/${widget.photos.length}',
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
