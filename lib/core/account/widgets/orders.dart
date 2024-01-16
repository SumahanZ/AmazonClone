import 'package:amazon_app/constants/global_variables.dart';
import 'package:amazon_app/core/account/services/account_services.dart';
import 'package:amazon_app/core/account/widgets/single_product.dart';
import 'package:amazon_app/core/order_details/screens/order_details_screen.dart';
import 'package:amazon_app/models/order.dart';
import 'package:flutter/material.dart';

class Orders extends StatefulWidget {
  const Orders({super.key});

  @override
  State<Orders> createState() => _OrdersState();
}

class _OrdersState extends State<Orders> {
  List<Order>? orders;
  final accountService = AccountService();

  @override
  void initState() {
    super.initState();
    fetchOrders();
  }

  void fetchOrders() async {
    orders = await accountService.fetchMyOrders(context: context);
    setState(() {
      
    });
  }
  
  @override
  Widget build(BuildContext context) {
    return orders == null ? const Center(child: CircularProgressIndicator.adaptive()) : Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Container(
              padding: const EdgeInsets.only(
                left: 15,
              ),
              child: const Text(
                "Your Orders",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),

            Container(
              padding: const EdgeInsets.only(
                right: 15,
              ),
              child: Text(
                "See All",
                style: TextStyle(
                  color: GlobalVariables.selectedNavBarColor,
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),

        //display orders
            Container(
              height: 170,
              padding: const EdgeInsets.only(left: 10, top: 20, right: 0),
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: orders!.length,
                itemBuilder: (context, index) {
                return GestureDetector(
                  onTap: () {
                    Navigator.pushNamed(context, OrderDetailScreen.routeName, arguments: orders![index]);
                  },
                  child: SingleProduct(image: orders![index].products[0].imagesUrl[0])
                );
              }),
            ),
      ],
    );
  }
}
