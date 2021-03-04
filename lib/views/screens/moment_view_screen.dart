import 'package:flutter/material.dart';
import 'package:peaman/models/moment_model.dart';
import 'package:peaman/views/widgets/explore_tab_widgets/moment_view_item.dart';

class MomentViewScreen extends StatefulWidget {
  final List<Moment> moments;
  final int initIndex;
  MomentViewScreen(this.moments, this.initIndex);

  @override
  _MomentViewScreenState createState() => _MomentViewScreenState();
}

class _MomentViewScreenState extends State<MomentViewScreen>
    with SingleTickerProviderStateMixin {
  ScrollController _scrollController;
  int _index = 0;

  @override
  void initState() {
    super.initState();
    setState(() {
      _index = widget.initIndex;
    });
    _scrollController = PageController(
      initialPage: widget.initIndex,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black87,
      body: SafeArea(
        child: Container(
          child: Column(
            children: [
              Expanded(
                child: PageView.builder(
                  physics: BouncingScrollPhysics(),
                  controller: _scrollController,
                  itemCount: widget.moments.length,
                  itemBuilder: (context, index) {
                    return MomentViewItem(
                      changePage: (val) => _changePage(val),
                      moment: widget.moments[index],
                    );
                  },
                  onPageChanged: (val) {
                    setState(() {
                      _index = val;
                    });
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // change page when animation is completed
  _changePage(final bool val) {
    if (val) {
      _scrollController.animateTo(
        MediaQuery.of(context).size.width * (_index + 1),
        duration: Duration(milliseconds: 500),
        curve: Curves.ease,
      );

      if (_index >= (widget.moments.length - 1) ||
          widget.initIndex >= (widget.moments.length - 1)) {
        Navigator.pop(context);
      }
    } else {
      if (_index >= 1) {
        _scrollController.animateTo(
          MediaQuery.of(context).size.width * (_index - 1),
          duration: Duration(milliseconds: 500),
          curve: Curves.ease,
        );
      }
    }
  }
}
