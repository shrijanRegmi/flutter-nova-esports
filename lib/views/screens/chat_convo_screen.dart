import 'package:flutter/material.dart';
import 'package:peaman/models/app_models/chat_model.dart';
import 'package:peaman/models/app_models/team_model.dart';
import 'package:peaman/models/app_models/user_model.dart';
import 'package:peaman/viewmodels/chat_convo_vm.dart';
import 'package:peaman/viewmodels/viewmodel_builder.dart';
import 'package:peaman/views/widgets/chat_convo_widgets/chat_compose_area.dart';
import 'package:peaman/views/widgets/chat_convo_widgets/chat_convo_list.dart';
import 'package:peaman/views/widgets/common_widgets/appbar.dart';

class ChatConvoScreen extends StatefulWidget {
  final AppUser friend;
  final bool fromSearch;
  final Chat chat;
  final Team team;
  ChatConvoScreen({
    this.friend,
    this.fromSearch = false,
    this.chat,
    this.team,
  });

  @override
  _ChatConvoScreenState createState() => _ChatConvoScreenState();
}

class _ChatConvoScreenState extends State<ChatConvoScreen> {
  final FocusNode _focusNode = FocusNode();

  final _scaffolKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return ViewmodelProvider<ChatConvoVm>(
      vm: ChatConvoVm(
        context: context,
      ),
      builder: (context, vm, appVm, appUser) {
        return Scaffold(
          backgroundColor: Color(0xffF3F5F8),
          key: _scaffolKey,
          appBar: PreferredSize(
            preferredSize: Size.fromHeight(60.0),
            child: SafeArea(
              child: CommonAppbar(
                leading: widget.fromSearch
                    ? IconButton(
                        icon: Icon(Icons.arrow_back_ios),
                        color: Color(0xff3D4A5A),
                        onPressed: () {
                          Navigator.pop(context);
                          Navigator.pop(context);
                          Navigator.pop(context);
                        },
                      )
                    : null,
                title: Row(
                  children: <Widget>[
                    Text(
                      'My Team - ${widget.team.teamName}',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 20.0,
                        color: Color(0xff3D4A5A),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          bottomNavigationBar: vm.isTyping
              ? Padding(
                  padding: MediaQuery.of(context).viewInsets,
                  child: ChatComposeArea(
                    chatId: widget.team.id,
                    sendMessage: vm.sendMessage,
                    appUser: vm.appUser,
                    friend: widget.friend,
                    updateIsTyping: vm.updateTypingValue,
                    isTypingActive: vm.isTyping,
                    focusNode: _focusNode,
                    scaffoldKey: _scaffolKey,
                  ),
                )
              : null,
          floatingActionButton: !vm.isTyping
              ? ChatComposeArea(
                  chatId: widget.team.id,
                  sendMessage: vm.sendMessage,
                  appUser: vm.appUser,
                  friend: widget.friend,
                  updateIsTyping: vm.updateTypingValue,
                  isTypingActive: vm.isTyping,
                  focusNode: _focusNode,
                  scaffoldKey: _scaffolKey,
                )
              : null,
          floatingActionButtonLocation:
              FloatingActionButtonLocation.centerDocked,
          body: SafeArea(
            child: GestureDetector(
              onTap: () {
                _focusNode.unfocus();
                vm.updateTypingValue(false);
              },
              child: Container(
                color: Color(0xffF3F5F8),
                child: Center(
                  child: Column(
                    children: <Widget>[
                      Expanded(
                        child: ChatConvoList(
                          isTypingActive: vm.isTyping,
                          appUser: vm.appUser,
                          chatId: widget.team.id,
                          team: widget.team,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
