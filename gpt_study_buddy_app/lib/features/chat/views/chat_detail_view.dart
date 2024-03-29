import 'dart:async';

import 'package:diffutil_sliverlist/diffutil_sliverlist.dart';
import 'package:flutter/material.dart';
import 'package:gpt_study_buddy/common/colors.dart';
import 'package:gpt_study_buddy/features/auth/providers/auth_service_provider.dart';
import 'package:gpt_study_buddy/features/bot/data/bot.dart';
import 'package:gpt_study_buddy/features/chat/data/message.dart';
import 'package:gpt_study_buddy/features/chat/providers/chat_details_viewmodel.dart';
import 'package:gpt_study_buddy/features/chat/views/widgets/message_tile.dart';
import 'package:provider/provider.dart';

class ChatDetailView extends StatefulWidget {
  const ChatDetailView({
    super.key,
    required this.bot,
  });

  final Bot bot;

  @override
  State<ChatDetailView> createState() => _ChatDetailViewState();
}

class _ChatDetailViewState extends State<ChatDetailView> {
  TextEditingController messageController = TextEditingController();
  ScrollController scrollController = ScrollController();
  Timer? scrollDebounceTimer;

  void _scrollToTop() {
    try {
      scrollDebounceTimer?.cancel();
      scrollDebounceTimer = Timer(const Duration(milliseconds: 100), () {
        if (scrollController.hasClients) {
          scrollController.jumpTo(0);
        }
      });
    } catch (_) {}
  }

  @override
  void initState() {
    init();
    super.initState();
  }

  void init() {
    final ChatDetailsViewModel chatDetailsViewModel =
        context.read<ChatDetailsViewModel>();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      chatDetailsViewModel.init(bot: widget.bot);
      chatDetailsViewModel.addListener(() {
        _scrollToTop();
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<ChatDetailsViewModel>(builder: (context, viewmodel, _) {
      return Scaffold(
        appBar: AppBar(
          title: Text(viewmodel.bot?.name ?? ""),
          elevation: 0,
          actions: [
            if (!viewmodel.selectionMode)
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: PopupMenuButton(
                  itemBuilder: (BuildContext context) {
                    return [
                      const PopupMenuItem(
                        value: 'clear',
                        child: Text('Clear chat'),
                      ),
                    ];
                  },
                  onSelected: (String value) {
                    if (value == 'clear') {
                      viewmodel.clearChat();
                    }
                  },
                  child: const Icon(Icons.more_horiz),
                ),
              ),
            if (viewmodel.selectionMode)
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: IconButton(
                  icon: const Icon(Icons.delete),
                  onPressed: () {
                    viewmodel.deleteSelectedMessages();
                  },
                ),
              ),
          ],
        ),
        body: Container(
          color: AppColors.primaryColor,
          child: SafeArea(
            child: Container(
              color: AppColors.primaryColor,
              child: Column(
                children: [
                  Expanded(
                    child: CustomScrollView(
                      reverse: true,
                      controller: scrollController,
                      restorationId: 'chat_detail_scroll_view',
                      slivers: [
                        DiffUtilSliverList<Message>(
                          equalityChecker: (Message item1, Message item2) =>
                              item1.messageId == item2.messageId,
                          items: viewmodel.messages.reversed.toList(),
                          builder: (BuildContext context, Message message) {
                            int index = viewmodel.messages.indexOf(message);
                            Message? previousMessage;
                            Message? nextMessage;

                            if (index > 0) {
                              previousMessage = viewmodel.messages[index - 1];
                            }

                            if (index < viewmodel.messages.length - 1) {
                              nextMessage = viewmodel.messages[index + 1];
                            }

                            return MessageTileAnimation(
                              child: MessageTile(
                                message: message,
                                previousMessage: previousMessage,
                                nextMessage: nextMessage,
                                selected: viewmodel.selectedMessages
                                    .contains(message.messageId),
                                incoming: message.senderId !=
                                    context
                                        .read<AuthServiceProvider>()
                                        .authToken!
                                        .user!
                                        .id,
                                onTap: (selected) {
                                  if (viewmodel.selectionMode) {
                                    viewmodel.toggleMessageSelection(
                                        messageId: message.messageId);
                                  }
                                },
                                onLongPress: (selected) {
                                  if (!viewmodel.selectionMode) {
                                    viewmodel.selectionMode = true;
                                    viewmodel.toggleMessageSelection(
                                        messageId: message.messageId);
                                  }
                                },
                              ),
                            );
                          },
                          insertAnimationBuilder: (BuildContext context,
                              Animation<double> animation, Widget child) {
                            return SlideTransition(
                                position: Tween<Offset>(
                                  begin: const Offset(0, 1),
                                  end: const Offset(0, 0),
                                ).animate(animation),
                                child: child);
                          },
                          removeAnimationBuilder: (BuildContext context,
                              Animation<double> animation, Widget child) {
                            return child;
                          },
                        )
                      ],
                    ),
                  ),
                  AnimatedSwitcher(
                    duration: const Duration(milliseconds: 500),
                    child: viewmodel.selectionMode
                        ? const SizedBox.shrink()
                        : Container(
                            padding: const EdgeInsets.symmetric(horizontal: 10),
                            height: 60,
                            color: AppColors.primaryColor,
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
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
                                    maxLines: null,
                                    minLines: null,
                                    expands: true,
                                  ),
                                ),
                                IconButton(
                                  icon: const Icon(
                                    Icons.send,
                                    color: Colors.white,
                                  ),
                                  onPressed: () {
                                    if (messageController.text.isNotEmpty) {
                                      viewmodel.sendTextMessage(
                                          text: messageController.text);
                                      messageController.clear();
                                      FocusScope.of(context).unfocus();
                                    }
                                  },
                                ),
                              ],
                            ),
                          ),
                  ),
                ],
              ),
            ),
          ),
        ),
      );
    });
  }
}
