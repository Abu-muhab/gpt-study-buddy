import 'package:faker/faker.dart';
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
  late List<Message> messages;
  late String userId;

  @override
  void initState() {
    var faker = Faker();
    userId = faker.guid.guid();
    messages = MessageRepository.getMockMessages(userId);
    super.initState();
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
                  child: ListView.builder(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 10, vertical: 20),
                    itemCount: messages.length,
                    itemBuilder: (context, index) {
                      Message message = messages[index];
                      Message? previousMessage;
                      Message? nextMessage;

                      if (index > 0) {
                        previousMessage = messages[index - 1];
                      }

                      if (index < messages.length - 1) {
                        nextMessage = messages[index + 1];
                      }

                      return MessageTile(
                        message: message,
                        previousMessage: previousMessage,
                        nextMessage: nextMessage,
                        incoming: message.senderId != userId,
                      );
                    },
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
                        icon: const Icon(Icons.send),
                        onPressed: () {},
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
