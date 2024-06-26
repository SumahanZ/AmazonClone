import 'package:amazon_app/core/account/widgets/single_product.dart';
import 'package:amazon_app/core/admin/services/admin_services.dart';
import 'package:amazon_app/core/order_details/screens/order_details_screen.dart';
import 'package:amazon_app/models/order.dart';
import 'package:flutter/material.dart';

class OrderScreen extends StatefulWidget {
  const OrderScreen({super.key});

  @override
  State<OrderScreen> createState() => _OrderScreenState();
}

class _OrderScreenState extends State<OrderScreen> {
  List<Order>? orders;
  final adminServices = AdminServices();

  @override
  void initState() {
    super.initState();
    fetchOrders();
  }

  void fetchOrders() async {
    orders = await adminServices.getAllOrders(context: context);
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return orders == null
        ? const Center(child: CircularProgressIndicator.adaptive())
        : GridView.builder(
            itemCount: orders!.length,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
            ),
            itemBuilder: (context, index) {
              final orderData = orders![index];
              return GestureDetector(
                onTap: () {
                  Navigator.pushNamed(context, OrderDetailScreen.routeName, arguments: orderData);
                },
                child: SizedBox(
                    height: 140,
                    child:
                        SingleProduct(image: orderData.products[0].imagesUrl[0])),
              );
            });
  }
}
