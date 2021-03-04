import 'package:flutter/material.dart';
// import 'package:flutter_svg/svg.dart';
import 'package:peaman/models/app_models/comment_model.dart';
import 'package:peaman/views/widgets/common_widgets/avatar_builder.dart';
import 'package:timeago/timeago.dart' as timeago;

class FeedCommentItem extends StatelessWidget {
  final Comment comment;
  FeedCommentItem(this.comment);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                AvatarBuilder(
                  imgUrl: comment.user.photoUrl,
                  radius: 16.0,
                ),
                SizedBox(
                  width: 10.0,
                ),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: RichText(
                              text: TextSpan(
                                style: TextStyle(
                                  fontFamily: 'Nunito',
                                  fontSize: 12.0,
                                  color: Colors.grey,
                                ),
                                children: [
                                  TextSpan(
                                    text: '${comment.user.name} ',
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: Color(0xff3D4A5A),
                                    ),
                                  ),
                                  TextSpan(
                                    text: '${comment.comment}',
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                      Text(
                        timeago.format(DateTime.fromMillisecondsSinceEpoch(
                            comment.updatedAt)),
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 10.0,
                          color: Colors.grey,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          SizedBox(
            width: 10.0,
          ),
          // GestureDetector(
          //   onTap: () {},
          //   child: Container(
          //     color: Colors.transparent,
          //     child: SvgPicture.asset(
          //       'assets/images/svgs/heart_blank.svg',
          //       width: 16.0,
          //       height: 16.0,
          //       color: Color(0xff3D4A5A),
          //     ),
          //   ),
          // ),
        ],
      ),
    );
  }
}
