import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:gpt_study_buddy/common/app_scaffold.dart';
import 'package:gpt_study_buddy/features/chat/data/chat.dart';
import 'package:gpt_study_buddy/features/chat/providers/chats_provider.dart';
import 'package:gpt_study_buddy/features/navigation/app_views.dart';
import 'package:gpt_study_buddy/main.dart';
import 'package:provider/provider.dart';

class ChatsView extends StatelessWidget {
  const ChatsView({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<ChatsProvider>(
      builder: (context, chatsProvider, _) {
        return AppScaffold(
          isLoading: chatsProvider.isLoading,
          appBar: AppBar(
            title: const Text('Chats'),
            centerTitle: false,
            elevation: 0,
          ),
          floatingActionButton: FloatingActionButton(
            onPressed: () {
              context.go(AppViews.createBot);
            },
            child: const Icon(Icons.add),
          ),
          body: Container(
            color: primaryColor[100],
            child: ListView(
              children: <Widget>[
                ...chatsProvider.chats.map(
                  (chat) => GestureDetector(
                    behavior: HitTestBehavior.opaque,
                    onTap: () {
                      context.go(AppViews.chatDetails, extra: {
                        'bot': chat.bot,
                      });
                    },
                    child: Column(
                      children: [
                        ChatTile(
                          chat: chat,
                        ),
                        Divider(
                          color: Colors.grey[800],
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class ChatTile extends StatefulWidget {
  const ChatTile({
    super.key,
    required this.chat,
  });

  final Chat chat;

  @override
  State<ChatTile> createState() => _ChatTileState();
}

class _ChatTileState extends State<ChatTile> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(10),
      width: double.infinity,
      child: Row(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          const CircleAvatar(
            radius: 25,
            backgroundImage: NetworkImage(
              'https://picsum.photos/200/300',
            ),
          ),
          const SizedBox(
            width: 10,
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.chat.bot.name,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(
                  height: 5,
                ),
                Text(
                  widget.chat.lastMessage.message,
                  style: const TextStyle(
                    color: Colors.grey,
                    fontSize: 15,
                    fontWeight: FontWeight.w300,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
