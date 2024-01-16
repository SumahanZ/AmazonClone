// ignore_for_file: use_build_context_synchronously

import 'dart:convert';
import 'package:amazon_app/constants/api_variables.dart';
import 'package:amazon_app/constants/error_handling.dart';
import 'package:amazon_app/constants/utils.dart';
import 'package:amazon_app/core/auth/screens/auth_screen.dart';
import 'package:amazon_app/models/order.dart';
import 'package:amazon_app/providers/user_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class AccountService {
  Future<List<Order>> fetchMyOrders({required BuildContext context}) async {
    final userProvider = Provider.of<UserNotifier>(context, listen: false);
    List<Order> orderList = [];
    try {
      Map<String, String> requestHeaders = {
        'Content-Type': 'application/json; charset=UTF-8',
        'token': userProvider.user.token,
      };

      final response = await http.get(
        Uri.http(ApiVariables.baseURL, ApiVariables.getUserOrdersURL),
        headers: requestHeaders,
      );

      httpErrorHandle(response: response, context: context, onSuccess: () {
        for (final order in jsonDecode(response.body)) {
          orderList.add(Order.fromJson(jsonEncode(order)));
        }
      });

    } catch (error) {
      showSnackBar(context, error.toString());
    }

    return orderList;
  }


  Future<void> logOut(BuildContext context) async {
    try {
      final pref = await SharedPreferences.getInstance();
      await pref.setString("token", "");
      Navigator.pushNamedAndRemoveUntil(context, AuthScreen.routeName, (route) => false);
    } catch (error) {
      showSnackBar(context, error.toString());
    }
  }
}