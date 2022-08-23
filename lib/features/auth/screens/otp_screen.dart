import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:whatsapp_ui/features/auth/controller/auth_controller.dart';

import '../../../colors.dart';

class OTPScreen extends ConsumerWidget {
  static const routeName = '/otp-screen';
  final String verificationId;
  const OTPScreen({Key? key, required this.verificationId}) : super(key: key);

  void verifyOTP(WidgetRef ref, BuildContext context, String userOTP) {
    ref
        .read(authControllerProvider)
        .verifyOTP(context, verificationId, userOTP);
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        title: const Text("Verify your number"),
        backgroundColor: backgroundColor,
      ),
      body: Center(
        child: Column(
          children: [
            const SizedBox(
              height: 20,
            ),
            const Text('We have sent an SMS with a code'),
            SizedBox(
              width: size.width * .5,
              child: TextField(
                textAlign: TextAlign.center,
                decoration: const InputDecoration(
                    hintText: ' - - - - - - ',
                    hintStyle: TextStyle(fontSize: 30)),
                keyboardType: TextInputType.number,
                onChanged: (value) {
                  if (value.length == 6) {
                    print('otpp verifyy');
                    verifyOTP(ref, context, value.trim());
                  }
                  print('FUnction run');
                },
              ),
            )
          ],
        ),
      ),
    );
  }
}
