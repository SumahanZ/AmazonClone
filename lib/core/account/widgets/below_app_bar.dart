import 'package:amazon_app/constants/global_variables.dart';
import 'package:amazon_app/providers/user_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class BelowAppBar extends StatelessWidget {
  const BelowAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    final user = context.watch<UserNotifier>().user;
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 10).copyWith(
        bottom: 10,
      ),
      decoration: const BoxDecoration(gradient: GlobalVariables.appBarGradient),
      child: RichText(
        text: TextSpan(
          text: "Hello, ",
          style: const TextStyle(fontSize: 22, color: Colors.black),
          children: [
            TextSpan(
              text: user.name,
              style: const TextStyle(
                  fontSize: 22,
                  color: Colors.black,
                  fontWeight: FontWeight.w600),
            )
          ],
        ),
      ),
    );
  }
}
