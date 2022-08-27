import 'package:flutter/material.dart';
import 'package:swipe_to/swipe_to.dart';
import 'package:whatsapp_ui/colors.dart';
import 'package:whatsapp_ui/common/enums/message_enum.dart';
import 'package:whatsapp_ui/features/chat/widgets/display_text_image_video_gif.dart';

class MyMessageCard extends StatelessWidget {
  final String message;
  final String date;
  final MessageEnum type;
  final VoidCallback onLeftSwipe;
  final String replayText;
  final String replayUserName;
  final MessageEnum replayMessageType;
  final bool isSeen;

  const MyMessageCard({
    Key? key,
    required this.message,
    required this.date,
    required this.type,
    required this.onLeftSwipe,
    required this.replayText,
    required this.replayUserName,
    required this.replayMessageType,
    required this.isSeen,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final isReplaying = replayText.isNotEmpty;
    return SwipeTo(
      onLeftSwipe: onLeftSwipe,
      child: Align(
        alignment: Alignment.centerRight,
        child: ConstrainedBox(
          constraints: BoxConstraints(
              maxWidth: MediaQuery.of(context).size.width - 45, minWidth: 100),
          child: Card(
            elevation: 1,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
            color: messageColor,
            margin: const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
            child: Stack(
              children: [
                Padding(
                    padding: type == MessageEnum.text
                        ? const EdgeInsets.only(
                            left: 5,
                            right: 5,
                            top: 5,
                            bottom: 20,
                          )
                        : const EdgeInsets.only(
                            left: 5,
                            right: 5,
                            top: 5,
                            bottom: 25,
                          ),
                    child: Column(
                      children: [
                        if (isReplaying) ...[
                          Container(
                            constraints: const BoxConstraints(maxWidth: 160),
                            padding: EdgeInsets.only(
                                left: 5,
                                right: replayMessageType == MessageEnum.text
                                    ? 25
                                    : 1,
                                top: 5,
                                bottom: 5),
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(5),
                                color: backgroundColor.withOpacity(0.5)),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                if (replayMessageType == MessageEnum.text) ...[
                                  Text(
                                    replayUserName,
                                    style: const TextStyle(
                                      color: tabColor,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  DisplayTextImageGif(
                                    message: replayText,
                                    type: replayMessageType,
                                  ),
                                ] else ...[
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        replayUserName,
                                        style: const TextStyle(
                                          color: tabColor,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      SizedBox(
                                        height: 50,
                                        width: 50,
                                        child: DisplayTextImageGif(
                                          message: replayText,
                                          type: replayMessageType,
                                        ),
                                      )
                                    ],
                                  )
                                ],
                              ],
                            ),
                          )
                        ],
                        DisplayTextImageGif(
                          message: message,
                          type: type,
                        ),
                      ],
                    )),
                Positioned(
                  bottom: 4,
                  right: 10,
                  child: Row(
                    children: [
                      Text(
                        date,
                        style: const TextStyle(
                          fontSize: 13,
                          color: Colors.white60,
                        ),
                      ),
                      const SizedBox(
                        width: 5,
                      ),
                      Icon(
                        isSeen ? Icons.done_all : Icons.done,
                        size: 20,
                        color: isSeen ? Colors.blue : Colors.white60,
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
