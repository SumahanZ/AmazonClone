// ignore_for_file: use_build_context_synchronously
import 'dart:convert';

import 'package:amazon_app/constants/api_variables.dart';
import 'package:amazon_app/constants/error_handling.dart';
import 'package:amazon_app/constants/utils.dart';
import 'package:amazon_app/models/product.dart';
import 'package:amazon_app/providers/user_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;

class CartService {
  Future<void> removeFromCart({
    required BuildContext context,
    required Product product,
  }) async {
    //we can use provider in services like this we need to pass the context
    final userProvider = Provider.of<UserNotifier>(context, listen: false);
    try {
      Map<String, String> requestHeaders = {
        'Content-Type': 'application/json; charset=UTF-8',
        'token': userProvider.user.token,
      };

      final response = await http.delete(
        Uri.http(ApiVariables.baseURL, "${ApiVariables.removeFromCartURL}/${product.id}"),
        headers: requestHeaders,
      );

      httpErrorHandle(
          response: response,
          context: context,
          onSuccess: () {
            //instead of creating User("","",) and fill in the properties again, we can just do this instead
            final user = userProvider.user
                .copyWith(cart: jsonDecode(response.body)["cart"]);
            userProvider.setUserFromModel(user);
          });
    } catch (error) {
      // print(error.toString());
      showSnackBar(context, error.toString());
    }
  }
}
