import 'package:flutter/material.dart';
import 'package:peaman/models/app_models/call_model.dart';
import 'package:provider/provider.dart';

class HomeVm extends ChangeNotifier {
  final BuildContext context;
  HomeVm({@required this.context});

  Call get receivingCall => Provider.of<Call>(context);
}
