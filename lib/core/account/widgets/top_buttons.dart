// ignore_for_file: use_build_context_synchronously
import 'package:amazon_app/core/account/services/account_services.dart';
import 'package:amazon_app/core/account/widgets/account_button.dart';
import 'package:flutter/material.dart';

class TopButtons extends StatelessWidget {
  const TopButtons({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(children: [
      Row(children: [
        //make the buttons a widget
        AccountButton(text: "Your Orders", onTap: () {}),
        AccountButton(text: "Turn Seller", onTap: () {})
      ]),
      const SizedBox(height: 10),
      Row(children: [
        //make the buttons a widget
        AccountButton(
            text: "Log Out",
            onTap: () {
              AccountService().logOut(context);
            }),
        AccountButton(text: "Your Wish List", onTap: () {})
      ])
    ]);
  }
}
