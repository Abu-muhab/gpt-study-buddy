import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:gpt_study_buddy/features/calendar/data/event.dart';
import 'package:gpt_study_buddy/features/chat/data/message.dart';
import 'package:intl/intl.dart';
import 'dart:ui' as ui;

import '../../../../common/colors.dart';

class MessageTile extends StatelessWidget {
  const MessageTile({
    super.key,
    required this.message,
    this.previousMessage,
    this.nextMessage,
    required this.incoming,
    this.selected = true,
    required this.onTap,
    required this.onLongPress,
  });

  final Message message;
  final Message? previousMessage;
  final Message? nextMessage;
  final bool incoming;
  final bool selected;
  final Function(bool selected) onTap;
  final Function(bool selected) onLongPress;

  @override
  Widget build(BuildContext context) {
    const messageTextStyle = TextStyle(
      color: Colors.white,
      fontSize: 15,
      fontWeight: FontWeight.w300,
    );
    return LayoutBuilder(builder: (context, constraints) {
      const avatarRadius = 15.0;
      const messagePadding = 9.0;

      Widget avatar = Container(
        margin: const EdgeInsets.only(left: 8, right: 8),
        child: CircleAvatar(
          radius: avatarRadius,
          backgroundColor: Colors.transparent,
          foregroundColor: Colors.transparent,
          backgroundImage: previousMessage?.senderId != message.senderId
              ? NetworkImage(
                  'https://picsum.photos/200/${incoming ? 300 : 400}',
                )
              : null,
        ),
      );
      return Column(
        children: [
          Row(
            mainAxisAlignment:
                !incoming ? MainAxisAlignment.end : MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              if (incoming) avatar,
              GestureDetector(
                onTap: () {
                  onTap(selected);
                },
                onLongPress: () {
                  onLongPress(selected);
                },
                child: Stack(
                  children: [
                    Container(
                      width: max(
                          getTextWithFromTextAndTextStyle(
                                text: message.message,
                                textStyle: messageTextStyle,
                                context: context,
                                maxWidth: constraints.maxWidth -
                                    avatarRadius * 2 -
                                    messagePadding * 2 -
                                    30,
                              ) +
                              messagePadding * 2,
                          80),
                      padding: const EdgeInsets.all(messagePadding),
                      decoration: BoxDecoration(
                        color: AppColors.primaryColor[900],
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          MarkdownBody(
                            data: message.message,
                            styleSheetTheme:
                                MarkdownStyleSheetBaseTheme.platform,
                            styleSheet: MarkdownStyleSheet(
                              p: messageTextStyle,
                              h1: messageTextStyle.copyWith(
                                fontSize: 20,
                                fontWeight: FontWeight.w500,
                              ),
                              h2: messageTextStyle.copyWith(
                                fontSize: 18,
                                fontWeight: FontWeight.w500,
                              ),
                              h3: messageTextStyle.copyWith(
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                              ),
                              h4: messageTextStyle.copyWith(
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                              ),
                              h5: messageTextStyle.copyWith(
                                fontSize: 12,
                                fontWeight: FontWeight.w500,
                              ),
                              h6: messageTextStyle.copyWith(
                                fontSize: 10,
                                fontWeight: FontWeight.w500,
                              ),
                              em: messageTextStyle.copyWith(
                                fontStyle: FontStyle.italic,
                              ),
                              strong: messageTextStyle.copyWith(
                                fontWeight: FontWeight.bold,
                              ),
                              tableHead: messageTextStyle.copyWith(
                                fontWeight: FontWeight.bold,
                              ),
                              tableBody: messageTextStyle,
                              tableCellsDecoration: const BoxDecoration(
                                color: Colors.transparent,
                                border: Border(
                                  top: BorderSide(
                                    color: Colors.grey,
                                    width: 0.5,
                                  ),
                                  bottom: BorderSide(
                                    color: Colors.grey,
                                    width: 0.5,
                                  ),
                                ),
                              ),
                              listBullet: messageTextStyle,
                            ),
                          ),
                          if (nextMessage?.senderId == null ||
                              nextMessage?.senderId != message.senderId)
                            Column(
                              children: [
                                const SizedBox(
                                  height: 2,
                                ),
                                Align(
                                  alignment: Alignment.centerRight,
                                  child: Text(
                                    _getStringTimeStamp(),
                                    style: const TextStyle(
                                      color: Colors.grey,
                                      fontSize: 8,
                                    ),
                                  ),
                                )
                              ],
                            ),
                        ],
                      ),
                    ),
                    if (selected)
                      Positioned(
                        top: 0,
                        bottom: 0,
                        left: 0,
                        right: 0,
                        child: Container(
                          decoration: BoxDecoration(
                            color: Colors.black.withOpacity(0.8),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: const Icon(
                            Icons.check,
                            color: Colors.white,
                            size: 30,
                          ),
                        ),
                      ),
                  ],
                ),
              ),
              if (!incoming) avatar,
            ],
          ),
          if (message.createdResources.isNotEmpty)
            const SizedBox(
              height: 15,
            ),
          ...message.createdResources.map(
            (e) {
              final resourseObject = e.toResourceObject();
              if (resourseObject == null) {
                return const SizedBox.shrink();
              }

              if (resourseObject is Event) {
                return Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                  child: ConstrainedBox(
                    constraints: BoxConstraints(
                      maxWidth: constraints.maxWidth * 0.7,
                    ),
                    child: Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(Icons.calendar_month),
                          const SizedBox(
                            width: 4,
                          ),
                          Expanded(
                            child: Text(
                              "${resourseObject.name} added to calendar\nFrom ${DateFormat('dd MMMM, yyyy hh:mm a').format(resourseObject.startTime)} to ${DateFormat('dd MMMM, yyyy hh:mm a').format(resourseObject.endTime)}",
                              maxLines: 2,
                              style: TextStyle(
                                decoration: TextDecoration.underline,
                                fontSize: 8.5,
                                color: Colors.blue[800],
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              }

              return const SizedBox.shrink();
            },
          ),
          SizedBox(
            height: nextMessage?.senderId != message.senderId ? 20 : 5,
          )
        ],
      );
    });
  }
}

String _getStringTimeStamp() {
  var now = DateTime.now();
  var formatter = DateFormat('hh:mm a');
  String formatted = formatter.format(now);
  return formatted;
}

double getTextWithFromTextAndTextStyle({
  required String text,
  required TextStyle textStyle,
  required BuildContext context,
  required double maxWidth,
}) {
  final textPainter = TextPainter(
    text: TextSpan(
      text: text,
      style: textStyle,
    ),
    maxLines: 1,
    textDirection: ui.TextDirection.ltr,
  )..layout(minWidth: 0, maxWidth: maxWidth);
  return textPainter.size.width;
}

class MessageTileAnimation extends StatefulWidget {
  const MessageTileAnimation({
    super.key,
    required this.child,
  });

  final MessageTile child;

  @override
  State<MessageTileAnimation> createState() => _MessageTileAnimationState();
}

class _MessageTileAnimationState extends State<MessageTileAnimation>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 200),
    );
    _animation = Tween<double>(begin: 0, end: 1).animate(_controller);
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.child.nextMessage != null) {
      return widget.child;
    }

    return SlideTransition(
      position: Tween<Offset>(
        begin: const Offset(0, 1),
        end: Offset.zero,
      ).animate(_animation),
      child: widget.child,
    );
  }
}
