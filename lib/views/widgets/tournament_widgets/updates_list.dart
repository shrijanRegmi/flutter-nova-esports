import 'package:flutter/material.dart';

class UpdatesList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _titleBuilder(),
          _emptyUpdatesBuilder(),
          // ListView.builder(
          //   shrinkWrap: true,
          //   physics: NeverScrollableScrollPhysics(),
          //   itemCount: 4,
          //   itemBuilder: (context, index) {
          //     return UpdatesListItem();
          //   },
          // ),
        ],
      ),
    );
  }

  Widget _titleBuilder() {
    return Row(
      children: [
        Text(
          'UPDATES',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 16.0,
          ),
        ),
      ],
    );
  }

  Widget _emptyUpdatesBuilder() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(
            height: 100.0,
          ),
          Text(
            'No updates to show',
            style: TextStyle(
              fontStyle: FontStyle.italic,
            ),
          ),
        ],
      ),
    );
  }
}
