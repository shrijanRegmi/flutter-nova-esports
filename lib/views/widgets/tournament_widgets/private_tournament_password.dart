import 'package:flutter/material.dart';
import 'package:peaman/viewmodels/tournament_view_vm.dart';

class PrivateTournamentPass extends StatelessWidget {
  final TournamentViewVm vm;
  PrivateTournamentPass(this.vm);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _shareLinkBuilder(),
      ],
    );
  }

  Widget _shareLinkBuilder() {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10.0),
        color: Colors.white,
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Tournament Password'.toUpperCase(),
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 10.0,
                    color: Colors.grey,
                  ),
                ),
                SizedBox(
                  height: 5.0,
                ),
                Text(
                  '${vm.thisTournament.id}',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 12.0,
                  ),
                ),
              ],
            ),
            MaterialButton(
              onPressed: vm.copyPassword,
              color: Colors.blue,
              child: Text(
                vm.isCopied ? 'Copied' : 'Copy',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
