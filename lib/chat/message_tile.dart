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
      fontSize: 13,
      fontWeight: FontWeight.w200,
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
                width: getTextWithFromTextAndTextStyle(
                  message.message,
                  messageTextStyle,
                  context,
                  constraints.maxWidth -
                      avatarRadius * 2 -
                      messagePadding * 2 -
                      30,
                ),
                padding: const EdgeInsets.all(messagePadding),
                decoration: BoxDecoration(
                  color: primaryColor[900],
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Column(
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

double getTextWithFromTextAndTextStyle(
  String text,
  TextStyle textStyle,
  BuildContext context,
  double maxWidth,
) {
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
