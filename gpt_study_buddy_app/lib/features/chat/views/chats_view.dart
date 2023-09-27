import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:gpt_study_buddy/common/app_scaffold.dart';
import 'package:gpt_study_buddy/common/image_assets.dart';
import 'package:gpt_study_buddy/features/chat/data/chat.dart';
import 'package:gpt_study_buddy/features/chat/providers/chats_provider.dart';
import 'package:gpt_study_buddy/features/navigation/app_views.dart';
import 'package:provider/provider.dart';

import '../../../common/colors.dart';
import '../../../common/retry_widget.dart';

class ChatsView extends StatelessWidget {
  const ChatsView({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<ChatsProvider>(
      builder: (context, chatsProvider, _) {
        return AppScaffold(
          isLoading: chatsProvider.isLoading,
          body: Container(
            color: AppColors.primaryColor[100],
            child: chatsProvider.failedFetch
                ? Column(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      RetryWidget(
                        onRetry: () {
                          chatsProvider.fetchChats();
                        },
                      )
                    ],
                  )
                : Builder(builder: (context) {
                    if (chatsProvider.chats.isEmpty) {
                      return SizedBox(
                        height: double.infinity,
                        width: double.infinity,
                        child: Column(
                          mainAxisSize: MainAxisSize.max,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Image.asset(
                              'assets/robot1.png',
                            ),
                            Text(
                              'Create a new bot \nto get started',
                              style: TextStyle(
                                color: Colors.grey[800],
                                fontSize: 15,
                                fontWeight: FontWeight.w300,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ],
                        ),
                      );
                    }

                    return ListView(
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
                    );
                  }),
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
          CircleAvatar(
              radius: 25,
              backgroundImage: AssetImage(ImageAssets.randomRobot())),
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
