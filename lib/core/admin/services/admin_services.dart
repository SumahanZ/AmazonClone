// ignore_for_file: use_build_context_synchronously

import 'dart:convert';
import 'dart:io';

import 'package:amazon_app/constants/api_variables.dart';
import 'package:amazon_app/constants/error_handling.dart';
import 'package:amazon_app/constants/utils.dart';
import 'package:amazon_app/core/admin/models/sales_chart.dart';
import 'package:amazon_app/models/order.dart';
import 'package:amazon_app/models/product.dart';
import 'package:amazon_app/providers/user_provider.dart';
import 'package:cloudinary_public/cloudinary_public.dart';
import 'package:flutter/material.dart';
import "package:http/http.dart" as http;
import 'package:provider/provider.dart';

class AdminServices {
  //save images in cloudinary instead of saving it in MySQL or MongoDB because not alot of storage space
  Future<void> sellProduct(
      {required BuildContext context,
      required String name,
      required String description,
      required double price,
      required double quantity,
      required String category,
      required List<File> images}) async {
    //we can use provider in services like this we need to pass the context
    final userProvider = Provider.of<UserNotifier>(context, listen: false);
    try {
      final cloudinary = CloudinaryPublic("dkintlemd", "safj8vdh");
      List<String> imageUrls = [];
      for (var image in images) {
        final response = await cloudinary
            .uploadFile(CloudinaryFile.fromFile(image.path, folder: name));
        //download url
        imageUrls.add(response.secureUrl);
      }

      final product = Product(
          name: name,
          description: description,
          quantity: quantity,
          imagesUrl: imageUrls,
          category: category,
          price: price);

      Map<String, String> requestHeaders = {
        'Content-Type': 'application/json; charset=UTF-8',
        'token': userProvider.user.token,
      };

      final response = await http.post(
        Uri.http(ApiVariables.baseURL, ApiVariables.addProductURL),
        headers: requestHeaders,
        body: product.toJson(),
      );

      httpErrorHandle(
          response: response,
          context: context,
          onSuccess: () {
            showSnackBar(context, "Product Added Successfully!");
          });
    } catch (error) {
      // print(error.toString());
      showSnackBar(context, error.toString());
    }
  }

  Future<List<Product>> getAllProducts({required BuildContext context}) async {
    final userProvider = Provider.of<UserNotifier>(context, listen: false);
    List<Product> products = [];
    try {
      Map<String, String> requestHeaders = {
        'Content-Type': 'application/json; charset=UTF-8',
        'token': userProvider.user.token,
      };

      final response = await http.get(
        Uri.http(ApiVariables.baseURL, ApiVariables.getAllProductURL),
        headers: requestHeaders,
      );

      httpErrorHandle(
          response: response,
          context: context,
          onSuccess: () {
            for (final product in jsonDecode(response.body)) {
              products.add(Product.fromJson(jsonEncode(product)));
            }
          });
    } catch (error) {
      showSnackBar(context, error.toString());
    }

    return products;
  }

  Future<void> deleteProduct(
      {required BuildContext context,
      required String productId,
      required VoidCallback onSuccess}) async {
    final userProvider = Provider.of<UserNotifier>(context, listen: false);
    try {
      Map<String, String> requestHeaders = {
        'Content-Type': 'application/json; charset=UTF-8',
        'token': userProvider.user.token,
      };

      final response = await http.post(
          Uri.http(ApiVariables.baseURL, ApiVariables.deleteProductURL),
          headers: requestHeaders,
          body: jsonEncode({"id": productId}));

      httpErrorHandle(
          response: response,
          context: context,
          onSuccess: () {
            onSuccess();
          });
    } catch (error) {
      showSnackBar(context, error.toString());
    }
  }

  Future<List<Order>> getAllOrders({required BuildContext context}) async {
    final userProvider = Provider.of<UserNotifier>(context, listen: false);
    List<Order> orderList = [];
    try {
      Map<String, String> requestHeaders = {
        'Content-Type': 'application/json; charset=UTF-8',
        'token': userProvider.user.token,
      };

      final response = await http.get(
        Uri.http(ApiVariables.baseURL, ApiVariables.getAdminOrdersURL),
        headers: requestHeaders,
      );

      httpErrorHandle(
          response: response,
          context: context,
          onSuccess: () {
            for (final order in jsonDecode(response.body)) {
              orderList.add(Order.fromJson(jsonEncode(order)));
            }
          });
    } catch (error) {
      showSnackBar(context, error.toString());
    }

    return orderList;
  }

  Future<void> changeOrderStatus(
      {required BuildContext context,
      required int status,
      required Order order,
      required VoidCallback onSuccess}) async {
    final userProvider = Provider.of<UserNotifier>(context, listen: false);
    try {
      Map<String, String> requestHeaders = {
        'Content-Type': 'application/json; charset=UTF-8',
        'token': userProvider.user.token,
      };

      final response = await http.post(
          Uri.http(ApiVariables.baseURL, ApiVariables.changeOrderStatusURL),
          headers: requestHeaders,
          body: jsonEncode({
            "id": order.id,
            "status": status,
          }));

      httpErrorHandle(
          response: response,
          context: context,
          onSuccess: () {
            onSuccess();
          });
    } catch (error) {
      showSnackBar(context, error.toString());
    }
  }

  //we are not using a concrete datatype, we can use Map<String, dynamic>
  //the return doesnt have to be the response type
  //we can set our own return type
  Future<Map<String, dynamic>> getAnalytics(
      {required BuildContext context}) async {
    final userProvider = Provider.of<UserNotifier>(context, listen: false);
    //saleschart model here is for making the chart later not related to the response of the data and changing it into concrete data type
    List<SalesChart> sales = [];
    int totalEarning = 0;

    try {
      Map<String, String> requestHeaders = {
        'Content-Type': 'application/json; charset=UTF-8',
        'token': userProvider.user.token,
      };

      final response = await http.get(
        Uri.http(ApiVariables.baseURL, ApiVariables.getAnalyticsURL),
        headers: requestHeaders,
      );

      httpErrorHandle(
          response: response,
          context: context,
          onSuccess: () {
            var res = jsonDecode(response.body);
            totalEarning = res["totalEarning"];
            sales = [
              SalesChart("Mobiles", res["mobileEarnings"]),
              SalesChart("Essentials", res["essentialEarnings"]),
              SalesChart("Books", res["bookEarnings"]),
              SalesChart("Appliances", res["applianceEarnings"]),
              SalesChart("Fashion", res["fashionEarnings"])
            ];
          });
    } catch (error) {
      showSnackBar(context, error.toString());
    }

    return {"sales": sales, "totalEarnings": totalEarning};
  }
}
