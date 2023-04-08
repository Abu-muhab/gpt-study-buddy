import 'dart:math';

import 'package:flutter/material.dart';
import 'package:gpt_study_buddy/chat/data/message.dart';
import 'package:gpt_study_buddy/main.dart';
import 'package:intl/intl.dart';
import 'dart:ui' as ui;

class MessageTile extends StatelessWidget {
  const MessageTile({
    super.key,
    required this.message,
    this.previousMessage,
    this.nextMessage,
    required this.incoming,
  });

  final Message message;
  final Message? previousMessage;
  final Message? nextMessage;
  final bool incoming;

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
            children: [
              if (incoming) avatar,
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
                  color: primaryColor[900],
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      message.message,
                      style: messageTextStyle,
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
              if (!incoming) avatar,
            ],
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

//slider transition
//handle the animation object internally
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
