import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:whatsapp_ui/common/providers/message_replay_provider.dart';

class MessageReplayPreview extends ConsumerWidget {
  const MessageReplayPreview({Key? key}) : super(key: key);

  void cancelReplay(WidgetRef ref) {
    ref.read(messageReplayprovider.state).update((state) => null);
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final messagereplay = ref.watch(messageReplayprovider);
    return Container(
      width: 350,
      padding: const EdgeInsets.all(8),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  messagereplay!.isMe ? 'Me' : "Other",
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
              IconButton(
                onPressed: () => cancelReplay(ref),
                icon: const Icon(Icons.close),
              ),
            ],
          ),
          const SizedBox(
            height: 8,
          ),
          Text(
            messagereplay.message,
          ),
        ],
      ),
    );
  }
}
