import 'package:audioplayers/audioplayers.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:whatsapp/constant/enums/message_enum.dart';
import 'package:whatsapp/features/chat/widgets/video_player_item.dart';

class DisplayTextImageGIF extends StatelessWidget {
  final String message;
  final MessageEnum type;
  const DisplayTextImageGIF({
    super.key,
    required this.message,
    required this.type,
  });

  @override
  Widget build(BuildContext context) {
    bool isPlay = false;
    final AudioPlayer audioPlayer = AudioPlayer();
    return type == MessageEnum.text
        ? Text(
            message,
            style: const TextStyle(
              fontSize: 16,
            ),
          )
        : type == MessageEnum.image
            ? CachedNetworkImage(
                imageUrl: message,
              )
            : type == MessageEnum.video
                ? VideoPlayerItem(
                    videoUrl: message,
                  )
                : type == MessageEnum.gif
                    ? CachedNetworkImage(
                        imageUrl: message,
                      )
                    : StatefulBuilder(
                        builder: (context, setState) {
                          return IconButton(
                            constraints: const BoxConstraints(
                              minWidth: 100,
                            ),
                            onPressed: () async {
                              if (isPlay) {
                                await audioPlayer.pause();
                                setState(() {
                                  isPlay = false;
                                });
                              } else {
                                await audioPlayer.play(UrlSource(message));
                                setState(() {
                                  isPlay = true;
                                });
                              }
                            },
                            icon: Icon(
                              isPlay ? Icons.pause_circle : Icons.play_circle,
                            ),
                          );
                        },
                      );
  }
}
