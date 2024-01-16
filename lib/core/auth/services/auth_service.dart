// ignore_for_file: use_build_context_synchronously

import 'dart:convert';

import 'package:amazon_app/common/widgets/bottom_bar.dart';
import 'package:amazon_app/constants/api_variables.dart';
import 'package:amazon_app/constants/error_handling.dart';
import 'package:amazon_app/constants/utils.dart';
import 'package:amazon_app/core/home/screens/home_screen.dart';
import 'package:amazon_app/models/requests/signupuser.dart';
import 'package:amazon_app/providers/user_provider.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthService {
  //sign up user function
  Future<void> signUpUser(
      {required SignUpUser userInfo, required BuildContext context}) async {
    Map<String, String> requestHeaders = {
      "Content-Type": "application/json; charset=UTF-8",
    };

    try {
      var url = Uri.http(ApiVariables.baseURL, ApiVariables.signUpURL);
      final response = await http.post(url,
          headers: requestHeaders, body: userInfo.toJson());
      httpErrorHandle(
          response: response,
          context: context,
          onSuccess: () {
            showSnackBar(
                context, "Account created! Login with the same credentials");
          });
    } catch (error) {
      showSnackBar(context, error.toString());
    }
  }

  Future<void> signInUser(
      {required BuildContext context,
      required String email,
      required String password}) async {
    Map<String, String> requestHeaders = {
      "Content-Type": "application/json; charset=UTF-8",
    };

    try {
      var url = Uri.http(ApiVariables.baseURL, ApiVariables.signInURL);
      final response = await http.post(
        url,
        headers: requestHeaders,
        body: jsonEncode(
          {
            "email": email,
            "password": password,
          },
        ),
      );

      httpErrorHandle(
          response: response,
          context: context,
          onSuccess: () async {
            final pref = await SharedPreferences.getInstance();
            context.read<UserNotifier>().setUser = response.body;
            await pref.setString("token", jsonDecode(response.body)["token"]);
            Navigator.pushNamedAndRemoveUntil(
                context, BottomBar.routeName, (route) => false);
          });
    } catch (error) {
      showSnackBar(context, error.toString());
    }
  }

  Future<void> getUserData({required BuildContext context}) async {
    try {
      //get the token from the sharedpref
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? token = prefs.getString("token");

      if (token == null) {
        prefs.setString("token", "");
      }

      //make sure the token that we have in the shared pref is still valid
      //by doing a tokenisvalid request
      var url = Uri.http(ApiVariables.baseURL, ApiVariables.tokenValidURL);
      Map<String, String> requestHeaders = {
        'Content-Type': 'application/json; charset=UTF-8',
        'token': token!,
      };
      var tokenRes = await http.post(url, headers: requestHeaders);
      var response = jsonDecode(tokenRes.body);

      //only get the user if the token is valid
      if (response == true) {
        //get user data
        var url = Uri.http(ApiVariables.baseURL, ApiVariables.getUserURL);
        final userResponse = await http.get(url, headers: requestHeaders);
        context.read<UserNotifier>().setUser = userResponse.body;
      }
    } catch (error) {
      print(error.toString());
      // showSnackBar(context, error.toString());
    }
  }
}
