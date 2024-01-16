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

class HomeService {
  Future<List<Product>> fetchCategoryProducts({required BuildContext context, required String category}) async {
    final userProvider = Provider.of<UserNotifier>(context, listen: false);
    List<Product> products = [];
    try {
      Map<String, String> requestHeaders = {
        'Content-Type': 'application/json; charset=UTF-8',
        'token': userProvider.user.token,
      };

      final response = await http.get(
        Uri.parse("http://${ApiVariables.baseURL}${ApiVariables.getProductsCategoryURL}?category=$category"),
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

  Future<Product> fetchDealOfDay({required BuildContext context}) async {
    final userProvider = Provider.of<UserNotifier>(context, listen: false);
    //we need to set like this so that in the screen if product is null it will return loader, otherwise it is just empty, if empty display something else
    Product product = Product(name: "", description: "", quantity: 0, imagesUrl: [], category: "", price: 0);
    try {
      Map<String, String> requestHeaders = {
        'Content-Type': 'application/json; charset=UTF-8',
        'token': userProvider.user.token,
      };

      final response = await http.get(Uri.http(ApiVariables.baseURL, ApiVariables.dealOfDayURL), headers: requestHeaders);
      httpErrorHandle(response: response, context: context, onSuccess: () {
        product = Product.fromJson(response.body);
      });

      return product;

    } catch (error) {
      showSnackBar(context, error.toString());
    }

    return product;
  }
}