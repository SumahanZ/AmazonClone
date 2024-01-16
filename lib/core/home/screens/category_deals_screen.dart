import 'package:amazon_app/constants/global_variables.dart';
import 'package:amazon_app/core/home/services/home_service.dart';
import 'package:amazon_app/core/product_details/screens/product_details_screen.dart';
import 'package:amazon_app/models/product.dart';
import 'package:flutter/material.dart';

class CategoryDealsScreen extends StatefulWidget {
  final String category;
  static const routeName = "/category-deal";
  const CategoryDealsScreen({super.key, required this.category});

  @override
  State<CategoryDealsScreen> createState() => _CategoryDealsScreenState();
}

class _CategoryDealsScreenState extends State<CategoryDealsScreen> {
  final homeService = HomeService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(60),
        child: AppBar(
          flexibleSpace: Container(
            decoration:
                const BoxDecoration(gradient: GlobalVariables.appBarGradient),
          ),
          title: Text(
            widget.category,
            style: const TextStyle(
              color: Colors.black,
            ),
          ),
        ),
      ),
      body: FutureBuilder<List<Product>>(
          future: homeService.fetchCategoryProducts(
              context: context, category: widget.category),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator.adaptive());
            } else if (snapshot.hasError) {
              return Text(snapshot.error.toString());
            } else if (snapshot.hasData && snapshot.data!.isEmpty) {
              return const Center(
                  child: Text("Product of this category is empty"));
            } else {
              return Column(
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 15, vertical: 10),
                    alignment: Alignment.topLeft,
                    child: Text("Keep shopping for ${widget.category}",
                        style: const TextStyle(
                          fontSize: 20,
                        )),
                  ),
                  SizedBox(
                    height: 170,
                    child: GridView.builder(
                      itemCount: snapshot.data!.length,
                      scrollDirection: Axis.horizontal,
                      padding: const EdgeInsets.only(left: 15),
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 1,
                              childAspectRatio: 1.4,
                              mainAxisSpacing: 10),
                      itemBuilder: (context, index) {
                        final product = snapshot.data![index];
                        return GestureDetector(
                          onTap: () {
                            Navigator.pushNamed(context, ProductDetailScreen.routeName, arguments: product);
                          },
                          child: Column(
                            children: [
                              SizedBox(
                                height: 130,
                                child: DecoratedBox(
                                  decoration: BoxDecoration(
                                      border: Border.all(
                                          color: Colors.black12, width: 0.5)),
                                  child: Padding(
                                      padding: const EdgeInsets.all(10),
                                      child: Image.network(product.imagesUrl[0])),
                                ),
                              ),
                          
                              Container(
                                alignment: Alignment.topLeft,
                                padding: const EdgeInsets.only(left: 0, top: 5, right: 15),
                                child: Text(product.name, maxLines: 1, overflow: TextOverflow.ellipsis)
                              )
                            ],
                          ),
                        );
                      },
                    ),
                  ),
                ],
              );
            }
          }),
    );
  }
}
