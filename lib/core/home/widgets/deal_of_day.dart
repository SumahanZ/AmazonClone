import 'package:amazon_app/core/home/services/home_service.dart';
import 'package:amazon_app/core/product_details/screens/product_details_screen.dart';
import 'package:amazon_app/models/product.dart';
import 'package:flutter/material.dart';

class DealOfDay extends StatefulWidget {
  const DealOfDay({super.key});

  @override
  State<DealOfDay> createState() => _DealOfDayState();
}

class _DealOfDayState extends State<DealOfDay> {
  Product? product;
  final homeService = HomeService();

  void fetchDealOfDay() async {
    product = await homeService.fetchDealOfDay(context: context);
  }

  void navigateToDetailScreen() {
    Navigator.pushNamed(context, ProductDetailScreen.routeName, arguments: product!);
  }

  @override
  void initState() {
    super.initState();
    fetchDealOfDay();
  }

  @override
  Widget build(BuildContext context) {
    return product == null
        ? const Center(child: CircularProgressIndicator.adaptive())
        : product!.name.isEmpty
            ? const SizedBox()
            : GestureDetector(
              onTap: () {
                navigateToDetailScreen();
              },
              child: Column(
                  children: [
                    Container(
                      alignment: Alignment.topLeft,
                      padding: const EdgeInsets.only(left: 10, top: 15),
                      child: const Text(
                        "Deal of the day",
                        style: TextStyle(
                          fontSize: 20,
                        ),
                      ),
                    ),
                    Image.network(product!.imagesUrl[0],
                        height: 235,
                        fit: BoxFit.fitHeight),
                    Container(
                      alignment: Alignment.topLeft,
                      padding: const EdgeInsets.only(left: 15, top: 5, right: 40),
                      child: const Text(
                        "\$100",
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(fontSize: 18),
                      ),
                    ),
                    Container(
                      alignment: Alignment.topLeft,
                      padding: const EdgeInsets.only(left: 15, top: 5, right: 40),
                      child: const Text(
                        "Rivaan",
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: product!.imagesUrl.map((e) => Image.network(e, fit: BoxFit.fitWidth, width: 100, height: 100 )).toList()
                      ),
                    ),
                    Container(
                        padding:
                            const EdgeInsets.symmetric(vertical: 15).copyWith(
                          left: 15,
                        ),
                        alignment: Alignment.topLeft,
                        child: Text("See all deals",
                            style: TextStyle(color: Colors.cyan.shade800)))
                  ],
                ),
            );
  }
}
