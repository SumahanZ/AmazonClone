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

class SearchService {
  Future<List<Product>> fetchSearchedProducts({required BuildContext context, required String searchQuery}) async {
    final userProvider = Provider.of<UserNotifier>(context, listen: false);
    List<Product> products = [];
    try {
      Map<String, String> requestHeaders = {
        'Content-Type': 'application/json; charset=UTF-8',
        'token': userProvider.user.token,
      };

      final response = await http.get(
        Uri.http(ApiVariables.baseURL, "${ApiVariables.searchProductsURL}/$searchQuery"),
        headers: requestHeaders,
      );

      httpErrorHandle(response: response, context: context, onSuccess: () {
        for (final product in jsonDecode(response.body)) {
          products.add(Product.fromJson(jsonEncode(product)));
        }
      });

    } catch (error) {
      showSnackBar(context, error.toString());
    }

    return products;
  }
}