import 'package:flutter/material.dart';
import 'package:peaman/models/app_models/user_model.dart';
import 'package:peaman/viewmodels/app_vm.dart';
import 'package:provider/provider.dart';

class ViewmodelProvider<T extends ChangeNotifier> extends StatefulWidget {
  @override
  _ViewmodelProviderState<T> createState() => _ViewmodelProviderState<T>();
  final Function(BuildContext context, T vm, AppVm appVm, AppUser appUser)
      builder;
  final T vm;
  final Function(T vm) onInit;
  final Function(T vm) onDispose;
  ViewmodelProvider(
      {@required this.vm, @required this.builder, this.onInit, this.onDispose});
}

class _ViewmodelProviderState<T extends ChangeNotifier>
    extends State<ViewmodelProvider<T>> {
  @override
  void initState() {
    super.initState();
    if (widget.onInit != null) {
      widget.onInit(widget.vm);
    }
  }

  @override
  void dispose() {
    super.dispose();
    if (widget.onDispose != null) {
      widget.onDispose(widget.vm);
    }
  }

  @override
  Widget build(BuildContext context) {
    final appUser = Provider.of<AppUser>(context);
    final appVm = Provider.of<AppVm>(context);

    return ChangeNotifierProvider<T>(
      create: (_) => widget.vm,
      child: Consumer<T>(
        builder: (BuildContext context, T vm, Widget child) =>
            widget.builder(context, vm, appVm, appUser),
      ),
    );
  }
}
