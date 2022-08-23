import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_contacts/contact.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:whatsapp_ui/common/widgets/error.dart';
import 'package:whatsapp_ui/common/widgets/loader.dart';
import 'package:whatsapp_ui/features/select_contacts/controller/select_contact_controller.dart';
import 'package:whatsapp_ui/features/select_contacts/repository/select_contact_repository.dart';

class SelectContactScreen extends ConsumerWidget {
  static const String routeName = '/select-contact';
  const SelectContactScreen({Key? key}) : super(key: key);
  void selectContact(
      WidgetRef ref, Contact selectedContact, BuildContext context) {
    ref.read(selectContactControllProvider).selectContact(
          selectedContact,
          context,
        );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Select contact'),
          actions: [
            IconButton(onPressed: () {}, icon: const Icon(Icons.search)),
            IconButton(onPressed: () {}, icon: const Icon(Icons.more_vert))
          ],
        ),
        body: ref.watch(getContactsProvider).when(
              data: (contactList) => ListView.separated(
                itemCount: contactList.length,
                itemBuilder: (context, index) {
                  final contact = contactList[index];
                  return InkWell(
                    onTap: () => selectContact(ref, contact, context),
                    child: ListTile(
                      leading: contact.photo == null
                          ? null
                          : CircleAvatar(
                              radius: 30,
                              backgroundImage: MemoryImage(contact.photo!),
                            ),
                      title: Text(
                        contact.displayName,
                        style: const TextStyle(fontSize: 18),
                      ),
                    ),
                  );
                },
                separatorBuilder: (context, index) => const Divider(),
              ),
              error: (err, trace) => ErrorScreen(error: err.toString()),
              loading: () => const Loader(),
            ));
  }
}
