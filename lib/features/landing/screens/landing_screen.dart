import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:whatsapp_ui/colors.dart';
import 'package:whatsapp_ui/common/widgets/custom_button.dart';
import 'package:whatsapp_ui/features/auth/screens/login_screen.dart';

class LandingPage extends StatelessWidget {
  const LandingPage({Key? key}) : super(key: key);
  void navigateToLoginScreen(BuildContext context) {
    Navigator.pushNamed(context, LoginScreen.routeName);
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      body: SafeArea(
          child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(
              height: 50,
            ),
            const Text(
              "Welocome to WhatsApp",
              style: TextStyle(
                fontSize: 33,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(
              height: 50,
            ),
            Image.asset(
              'assets/bg.png',
              height: size.width,
              width: size.width,
              color: tabColor,
            ),
            SizedBox(
              height: size.height / 9,
            ),
            const Text(
              'Read our Privacy Policy. Tap "Agree and continue" to accept the Terms of Service.',
              textAlign: TextAlign.center,
              style: TextStyle(color: greycolor),
            ),
            const SizedBox(
              height: 10,
            ),
            SizedBox(
                width: size.width * .75,
                child: CustomButton(
                    onPressed: () => navigateToLoginScreen(context),
                    text: 'AGREE AND CONTINUE'))
          ],
        ),
      )),
    );
  }
}
