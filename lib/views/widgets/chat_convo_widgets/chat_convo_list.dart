import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:peaman/models/app_models/message_model.dart';
import 'package:peaman/models/app_models/team_model.dart';
import 'package:peaman/models/app_models/user_model.dart';
import 'package:peaman/services/database_services/message_provider.dart';
import 'package:peaman/views/widgets/chat_convo_widgets/chat_convo_list_item.dart';

class ChatConvoList extends StatelessWidget {
  final Team team;
  final String chatId;
  final AppUser appUser;
  final bool isTypingActive;
  final bool isSeen;
  final bool isTyping;
  ChatConvoList({
    this.team,
    this.chatId,
    this.appUser,
    this.isTypingActive,
    this.isSeen = false,
    this.isTyping = false,
  });

  @override
  Widget build(BuildContext context) {
    final _chatId = chatId ?? 'test';

    return StreamBuilder<List<Message>>(
        stream: MessageProvider(chatId: _chatId).messagesList,
        builder: (context, AsyncSnapshot<List<Message>> messagesSnap) {
          if (messagesSnap.hasData) {
            return ListView.builder(
              itemCount: messagesSnap.data.length,
              physics: BouncingScrollPhysics(),
              reverse: true,
              itemBuilder: (context, index) {
                if (messagesSnap.data[index].senderId == appUser.uid) {
                  if (index == 0) {
                    return Padding(
                      padding: EdgeInsets.only(
                          bottom: isTypingActive ? 20.0 : 130.0),
                      child: Column(
                        children: [
                          Stack(
                            children: [
                              Padding(
                                padding: EdgeInsets.only(
                                  bottom: isTyping ? 25.0 : 0.0,
                                ),
                                child: ChatConvoListItem(
                                  chatId: _chatId,
                                  message: messagesSnap.data[index],
                                  friend: team.users.firstWhere(
                                      (element) =>
                                          element.uid ==
                                          messagesSnap.data[index].senderId,
                                      orElse: () => null),
                                  alignment: Alignment.centerRight,
                                  isLast: true,
                                ),
                              ),
                              if (isTyping)
                                Positioned(
                                  top: 90.0,
                                  right: 0.0,
                                  left: 0.0,
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Lottie.asset(
                                        'assets/lottie/typing_indicator.json',
                                        height: 150.0,
                                      ),
                                    ],
                                  ),
                                )
                            ],
                          ),
                          if (!isTyping && isSeen)
                            Text(
                              'Seen',
                              style: TextStyle(
                                fontSize: 12.0,
                                color: Colors.black26,
                              ),
                            ),
                        ],
                      ),
                    );
                  }
                  return ChatConvoListItem(
                    chatId: _chatId,
                    message: messagesSnap.data[index],
                    friend: team.users.firstWhere(
                        (element) =>
                            element.uid == messagesSnap.data[index].senderId,
                        orElse: () => null),
                    alignment: Alignment.centerRight,
                  );
                } else {
                  if (index == 0) {
                    return Padding(
                      padding: EdgeInsets.only(
                          bottom: isTypingActive ? 20.0 : 120.0),
                      child: Stack(
                        children: [
                          Padding(
                            padding: EdgeInsets.only(
                              bottom: isTyping ? 25.0 : 0.0,
                            ),
                            child: ChatConvoListItem(
                              chatId: _chatId,
                              message: messagesSnap.data[index],
                              friend: team.users.firstWhere(
                                  (element) =>
                                      element.uid ==
                                      messagesSnap.data[index].senderId,
                                  orElse: () => null),
                              alignment: Alignment.centerLeft,
                              isLast: true,
                            ),
                          ),
                          if (isTyping)
                            Positioned(
                              top: 90.0,
                              right: 0.0,
                              left: 0.0,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Lottie.asset(
                                    'assets/lottie/typing_indicator.json',
                                    height: 150.0,
                                  ),
                                ],
                              ),
                            )
                        ],
                      ),
                    );
                  }
                  return ChatConvoListItem(
                    chatId: _chatId,
                    message: messagesSnap.data[index],
                    friend: team.users.firstWhere(
                        (element) =>
                            element.uid == messagesSnap.data[index].senderId,
                        orElse: () => null),
                    alignment: Alignment.centerLeft,
                  );
                }
              },
            );
          }
          return Padding(
            padding: const EdgeInsets.only(bottom: 120.0),
            child: Lottie.asset(
              'assets/lottie/chat_loader.json',
              width: MediaQuery.of(context).size.width - 200.0,
              height: MediaQuery.of(context).size.width - 200.0,
            ),
          );
        });
  }
}
