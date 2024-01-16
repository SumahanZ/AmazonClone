import 'package:amazon_app/common/widgets/bottom_bar.dart';
import 'package:amazon_app/core/address/screens/address_screen.dart';
import 'package:amazon_app/core/admin/screens/add_product_screen.dart';
import 'package:amazon_app/core/auth/screens/auth_screen.dart';
import 'package:amazon_app/core/home/screens/category_deals_screen.dart';
import 'package:amazon_app/core/home/screens/home_screen.dart';
import 'package:amazon_app/core/order_details/screens/order_details_screen.dart';
import 'package:amazon_app/core/product_details/screens/product_details_screen.dart';
import 'package:amazon_app/core/search/screens/search_screen.dart';
import 'package:amazon_app/models/order.dart';
import 'package:amazon_app/models/product.dart';
import 'package:flutter/material.dart';

//instead of wrting Navigator.of(context)... everytime
//or defining the named route in the main
//we can use onGenerateRoute and write a function and define our routes here
Route<dynamic> generateRoute(RouteSettings routeSettings) {
  switch (routeSettings.name) {
    case AuthScreen.routeName:
      return MaterialPageRoute(
          settings: routeSettings, builder: (_) => const AuthScreen());
    case HomeScreen.routeName:
      return MaterialPageRoute(
          settings: routeSettings, builder: (_) => const HomeScreen());
    case BottomBar.routeName:
      return MaterialPageRoute(
          settings: routeSettings, builder: (_) => const BottomBar());
    case AddProductScreen.routeName:
      return MaterialPageRoute(
          settings: routeSettings, builder: (_) => const AddProductScreen());
    case ProductDetailScreen.routeName:
      var product = routeSettings.arguments as Product;
      return MaterialPageRoute(
          settings: routeSettings,
          builder: (_) => ProductDetailScreen(product: product));
    case OrderDetailScreen.routeName:
      var order = routeSettings.arguments as Order;
      return MaterialPageRoute(
          settings: routeSettings,
          builder: (_) => OrderDetailScreen(order: order));
    case SearchScreen.routeName:
      var queryString = routeSettings.arguments as String;
      return MaterialPageRoute(
          settings: routeSettings,
          builder: (_) => SearchScreen(queryString: queryString));
    case CategoryDealsScreen.routeName:
      //how to pass into the parameter
      var category = routeSettings.arguments as String;
      return MaterialPageRoute(
          settings: routeSettings,
          builder: (_) => CategoryDealsScreen(category: category));
    case AddressScreen.routeName:
      //how to pass into the parameter
      var totalAmount = routeSettings.arguments as String;
      return MaterialPageRoute(
          settings: routeSettings,
          builder: (_) => AddressScreen(
                totalAmount: totalAmount,
              ));
    default:
      return MaterialPageRoute(
          settings: routeSettings,
          builder: (_) => const Center(child: Text("Screen does not exist")));
  }
}
