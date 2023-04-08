import 'dart:async';

import 'package:diffutil_sliverlist/diffutil_sliverlist.dart';
import 'package:flutter/material.dart';
import 'package:gpt_study_buddy/chat/data/message.dart';
import 'package:gpt_study_buddy/chat/data/message_repo.dart';
import 'package:gpt_study_buddy/chat/message_tile.dart';
import 'package:gpt_study_buddy/main.dart';

class ChatView extends StatefulWidget {
  const ChatView({super.key});

  @override
  State<ChatView> createState() => _ChatViewState();
}

class _ChatViewState extends State<ChatView> {
  late ValueNotifier<List<Message>> messagesVN = ValueNotifier([]);
  StreamSubscription<Message>? messageSubscription;
  late String userId;
  final MessageRepository messageRepository = MessageRepository();

  TextEditingController messageController = TextEditingController();
  ScrollController scrollController = ScrollController();
  Timer? scrollDebounceTimer;

  @override
  void initState() {
    userId = 'userid';
    messageSubscription = messageRepository.messages.listen((message) async {
      messagesVN.value = [...messagesVN.value, message];
      _scrollToBottomDebounced();
    });
    super.initState();
  }

  void _scrollToBottomDebounced() {
    scrollDebounceTimer?.cancel();
    scrollDebounceTimer = Timer(const Duration(milliseconds: 100), () {
      scrollController.jumpTo(scrollController.position.maxScrollExtent);
    });
  }

  @override
  void dispose() {
    messageSubscription?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Chat'),
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.more_horiz),
            onPressed: () {},
          ),
        ],
      ),
      body: Container(
        color: primaryColor[100],
        child: SafeArea(
          child: Container(
            color: primaryColor,
            child: Column(
              children: [
                Expanded(
                  child: CustomScrollView(
                    controller: scrollController,
                    slivers: [
                      ValueListenableBuilder<List<Message>>(
                        valueListenable: messagesVN,
                        builder: (context, messages, _) {
                          return DiffUtilSliverList<Message>(
                            equalityChecker: (Message item1, Message item2) =>
                                item1.messageId == item2.messageId,
                            items: messages,
                            builder: (BuildContext context, Message message) {
                              int index = messages.indexOf(message);
                              Message? previousMessage;
                              Message? nextMessage;

                              if (index > 0) {
                                previousMessage = messages[index - 1];
                              }

                              if (index < messages.length - 1) {
                                nextMessage = messages[index + 1];
                              }

                              return MessageTileAnimation(
                                child: MessageTile(
                                  message: message,
                                  previousMessage: previousMessage,
                                  nextMessage: nextMessage,
                                  incoming: message.senderId != userId,
                                ),
                              );
                            },
                            insertAnimationBuilder: (BuildContext context,
                                Animation<double> animation, Widget child) {
                              return child;
                            },
                            removeAnimationBuilder: (BuildContext context,
                                Animation<double> animation, Widget child) {
                              return child;
                            },
                          );
                        },
                      )
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  height: 60,
                  color: primaryColor[100],
                  child: Row(
                    children: [
                      Expanded(
                        child: TextField(
                          controller: messageController,
                          style: const TextStyle(
                            color: Colors.white,
                          ),
                          decoration: InputDecoration(
                            hintText: 'Type a message',
                            hintStyle: TextStyle(
                              color: Colors.grey[600],
                            ),
                            border: InputBorder.none,
                          ),
                        ),
                      ),
                      IconButton(
                        icon: const Icon(
                          Icons.send,
                          color: Colors.white,
                        ),
                        onPressed: () {
                          if (messageController.text.isNotEmpty) {
                            messageRepository.sendTextMessage(
                              senderId: userId,
                              receiverId: 'ai',
                              text: messageController.text,
                            );
                            messageController.clear();
                          }
                        },
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
