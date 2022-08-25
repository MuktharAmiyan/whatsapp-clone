import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:whatsapp_ui/common/enums/message_enum.dart';
import 'package:whatsapp_ui/common/widgets/loader.dart';
import 'package:whatsapp_ui/features/chat/controller/chat_controller.dart';
import 'package:whatsapp_ui/features/chat/widgets/sender_message_card.dart';
import 'package:whatsapp_ui/info.dart';
import 'package:whatsapp_ui/models/message.dart';

import 'my_message_card.dart';

class ChatList extends ConsumerStatefulWidget {
  final String reciverUid;
  const ChatList({required this.reciverUid, Key? key}) : super(key: key);

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _ChatListState();
}

class _ChatListState extends ConsumerState<ChatList> {
  final ScrollController messageScrollController = ScrollController();
  @override
  void dispose() {
    super.dispose();
    messageScrollController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<List<Message>>(
        stream: ref.read(chatControllerprovider).chatStream(widget.reciverUid),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Loader();
          }
          SchedulerBinding.instance.addPostFrameCallback((_) {
            messageScrollController
                .jumpTo(messageScrollController.position.maxScrollExtent);
          });
          return ListView.builder(
            controller: messageScrollController,
            itemCount: snapshot.data!.length,
            itemBuilder: (context, index) {
              final messageData = snapshot.data![index];
              var timeSent = DateFormat.Hm().format(messageData.timeSent);
              if (messageData.senderId ==
                  FirebaseAuth.instance.currentUser!.uid) {
                return MyMessageCard(
                  message: messageData.text,
                  date: timeSent,
                  type: messageData.type,
                );
              }
              return SenderMessageCard(
                message: messageData.text,
                date: timeSent,
                type: messageData.type,
              );
            },
          );
        });
  }
}
