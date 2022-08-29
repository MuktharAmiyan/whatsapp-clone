import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:whatsapp_ui/common/widgets/loader.dart';
import 'package:whatsapp_ui/features/status/controller/status_controller.dart';
import 'package:whatsapp_ui/models/status_model.dart';

class StatusContactScreen extends ConsumerWidget {
  const StatusContactScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return FutureBuilder<List<Status>>(
      future: ref.read(statusControllerProvider).getStatus(context),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: Loader());
        }
        if (snapshot.data!.isEmpty) {
          return const Center(
            child: Text("No Status"),
          );
        } else {
          return ListView.separated(
            itemCount: snapshot.data!.length,
            itemBuilder: (context, index) {
              var statusData = snapshot.data![index];
              return ListTile(
                leading: CircleAvatar(
                  backgroundImage: NetworkImage(statusData.profilePic),
                ),
                title: Text(statusData.userName),
                onTap: () {},
              );
            },
            separatorBuilder: (context, index) => const Divider(),
          );
        }
      },
    );
  }
}
