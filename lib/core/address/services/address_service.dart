// ignore_for_file: use_build_context_synchronously
import 'dart:convert';
import 'package:amazon_app/constants/api_variables.dart';
import 'package:amazon_app/constants/error_handling.dart';
import 'package:amazon_app/constants/utils.dart';
import 'package:amazon_app/providers/user_provider.dart';
import 'package:flutter/material.dart';
import "package:http/http.dart" as http;
import 'package:provider/provider.dart';

class AddressService {
  //save images in cloudinary instead of saving it in MySQL or MongoDB because not alot of storage space
  Future<void> saveUserAddress(
      {required BuildContext context, required String address}) async {
    //we can use provider in services like this we need to pass the context
    final userProvider = Provider.of<UserNotifier>(context, listen: false);
    try {
      Map<String, String> requestHeaders = {
        'Content-Type': 'application/json; charset=UTF-8',
        'token': userProvider.user.token,
      };

      final response = await http.post(
        Uri.http(ApiVariables.baseURL, ApiVariables.saveUserAddressURL),
        headers: requestHeaders,
        body: jsonEncode({"address": address}),
      );

      httpErrorHandle(
          response: response,
          context: context,
          onSuccess: () {
            //store in userprovider
            final user = userProvider.user
                .copyWith(address: jsonDecode(response.body)["address"]);
            userProvider.setUserFromModel(user);
          });
    } catch (error) {
      // print(error.toString());
      showSnackBar(context, error.toString());
    }
  }

  Future<void> orderProduct(
      {required BuildContext context,
      required String address,
      required double totalSum}) async {
    //we can use provider in services like this we need to pass the context
    final userProvider = Provider.of<UserNotifier>(context, listen: false);
    try {
      Map<String, String> requestHeaders = {
        'Content-Type': 'application/json; charset=UTF-8',
        'token': userProvider.user.token,
      };

      final response = await http.post(
        Uri.http(ApiVariables.baseURL, ApiVariables.placeOrderURL),
        headers: requestHeaders,
        body: jsonEncode({
          "cart": userProvider.user.cart,
          "address": address,
          "totalPrice": totalSum,
        }),
      );

      httpErrorHandle(
          response: response,
          context: context,
          onSuccess: () {
            showSnackBar(context, "Your order has been placed!");
            //empty the cart after making the order
            final user = userProvider.user.copyWith(cart: []);
            userProvider.setUserFromModel(user);
          });
    } catch (error) {
      // print(error.toString());
      showSnackBar(context, error.toString());
    }
  }
}
