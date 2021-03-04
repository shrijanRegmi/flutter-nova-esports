import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:lottie/lottie.dart';
import 'package:peaman/models/app_models/feed_model.dart';
import 'package:peaman/models/app_models/user_model.dart';
import 'package:peaman/viewmodels/comment_vm.dart';
import 'package:peaman/viewmodels/viewmodel_builder.dart';
import 'package:peaman/views/widgets/common_widgets/appbar.dart';
import 'package:peaman/views/widgets/explore_tab_widgets/feed_comment_item.dart';
import 'package:provider/provider.dart';

class FeedCommentScreen extends StatelessWidget {
  final Feed feed;
  final String feedId;
  FeedCommentScreen(this.feed, {this.feedId});

  @override
  Widget build(BuildContext context) {
    final _appUser = Provider.of<AppUser>(context);

    return ViewmodelProvider<CommentVm>(
      vm: CommentVm(),
      onInit: (vm) => vm.onInit(_appUser, feed, feedId),
      builder: (context, vm, appVm, appUser) {
        return Scaffold(
          backgroundColor: Color(0xffF3F5F8),
          bottomNavigationBar: Padding(
            padding: MediaQuery.of(context).viewInsets,
            child: _typingInputBuilder(vm, appUser),
          ),
          appBar: PreferredSize(
            preferredSize: Size.fromHeight(60.0),
            child: CommonAppbar(
              title: Text(
                'Comments',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 20.0,
                  color: Color(0xff3D4A5A),
                ),
              ),
            ),
          ),
          body: SafeArea(
            child: vm.comments == null
                ? Center(
                    child: Padding(
                      padding: const EdgeInsets.only(bottom: 120.0),
                      child: Lottie.asset(
                        'assets/lottie/chat_loader.json',
                        width: MediaQuery.of(context).size.width - 200.0,
                        height: MediaQuery.of(context).size.width - 200.0,
                      ),
                    ),
                  )
                : ListView.separated(
                    // reverse: true,
                    itemCount: vm.comments.length,
                    itemBuilder: (context, index) {
                      return FeedCommentItem(vm.comments[index]);
                    },
                    separatorBuilder: (context, index) {
                      return Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 10.0),
                        child: Divider(),
                      );
                    },
                  ),
          ),
        );
      },
    );
  }

  Widget _typingInputBuilder(CommentVm vm, AppUser appUser) {
    return Container(
      color: Colors.white,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Row(
            children: <Widget>[
              Expanded(
                child: TextFormField(
                  autofocus: true,
                  controller: vm.commentController,
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    hintText: 'Type comment...',
                    contentPadding: const EdgeInsets.only(
                      left: 20.0,
                      top: 5.0,
                      bottom: 5.0,
                    ),
                  ),
                  maxLines: 3,
                  minLines: 1,
                ),
              ),
              GestureDetector(
                onTap: () => vm.commentPost(feed, appUser),
                child: ClipOval(
                  child: Container(
                    width: 35.0,
                    height: 35.0,
                    color: Colors.green,
                    padding: const EdgeInsets.all(8.0),
                    child: Center(
                      child: SvgPicture.asset(
                        'assets/images/svgs/send_btn.svg',
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(
                width: 10.0,
              ),
            ],
          ),
          // Padding(
          //   padding:
          //       const EdgeInsets.only(left: 20.0, right: 20.0, bottom: 10.0),
          //   child: Row(
          //     children: <Widget>[
          //       Icon(
          //         Icons.add_circle_outline,
          //         color: Color(0xff3D4A5A),
          //       ),
          //       SizedBox(
          //         width: 10.0,
          //       ),
          //       Icon(
          //         Icons.tag_faces,
          //         color: Color(0xff3D4A5A),
          //       ),
          //     ],
          //   ),
          // ),
        ],
      ),
    );
  }
}
