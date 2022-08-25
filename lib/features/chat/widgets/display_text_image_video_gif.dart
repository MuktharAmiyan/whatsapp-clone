import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:whatsapp_ui/common/enums/message_enum.dart';
import 'package:whatsapp_ui/features/chat/widgets/video_player_item.dart';

class DisplayTextImageGif extends StatelessWidget {
  final String message;
  final MessageEnum type;
  const DisplayTextImageGif(
      {Key? key, required this.message, required this.type})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return type == MessageEnum.text
        ? Text(
            message,
            style: const TextStyle(
              fontSize: 16,
            ),
          )
        : type == MessageEnum.video
            ? VideoPlayerItem(videoUrl: message)
            : type == MessageEnum.gif
                ? CachedNetworkImage(imageUrl: message)
                : CachedNetworkImage(imageUrl: message);
  }
}
