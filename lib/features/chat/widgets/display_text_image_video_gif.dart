import 'package:audioplayers/audioplayers.dart';
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
    bool ispalying = false;
    final AudioPlayer audioPlayer = AudioPlayer();
    return type == MessageEnum.text
        ? Text(
            message,
            style: const TextStyle(
              fontSize: 16,
            ),
          )
        : type == MessageEnum.video
            ? VideoPlayerItem(videoUrl: message)
            : type == MessageEnum.audio
                ? StatefulBuilder(builder: (context, setState) {
                    return IconButton(
                        onPressed: () async {
                          !ispalying
                              ? {
                                  await audioPlayer.play(UrlSource(message)),
                                  setState(() {
                                    ispalying = true;
                                  })
                                }
                              : {
                                  await audioPlayer.pause(),
                                  setState(() {
                                    ispalying = false;
                                  })
                                };
                        },
                        icon: Icon(ispalying
                            ? Icons.pause_circle
                            : Icons.play_circle));
                  })
                : CachedNetworkImage(imageUrl: message);
  }
}
