import 'dart:convert';
import 'package:amazon_app/constants/utils.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';

void httpErrorHandle({
  required Response response,
  required BuildContext context,
  required VoidCallback onSuccess,
}) {
  switch (response.statusCode) {
    case 200:
      onSuccess();
    case 400:
      //decode the response.body which is still in json format and take the "msg"
      showSnackBar(context, jsonDecode(response.body)["msg"]);
    case 500:
      showSnackBar(context, jsonDecode(response.body)["error"]);
    default:
      showSnackBar(context, response.body);
  }
}
