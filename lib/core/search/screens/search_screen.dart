import 'package:amazon_app/constants/global_variables.dart';
import 'package:amazon_app/core/home/screens/widgets/searched_product.dart';
import 'package:amazon_app/core/home/widgets/address_box.dart';
import 'package:amazon_app/core/product_details/screens/product_details_screen.dart';
import 'package:amazon_app/core/search/services/search_services.dart';
import 'package:amazon_app/models/product.dart';
import 'package:flutter/material.dart';

class SearchScreen extends StatefulWidget {
  static const routeName = "/searc-screen";
  final String queryString;
  const SearchScreen({super.key, required this.queryString});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  late Future<List<Product>> fetchProduct;
  final searchService = SearchService();

  @override
  void initState() {
    super.initState();
    fetchProduct = searchService.fetchSearchedProducts(
        context: context, searchQuery: widget.queryString);
  }

  void navigateToSearchScreen(String query) {
    Navigator.pushNamed(context, SearchScreen.routeName, arguments: query);
  }

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
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Container(
                  height: 42,
                  margin: const EdgeInsets.only(left: 15),
                  child: Material(
                      borderRadius: BorderRadius.circular(7),
                      elevation: 1,
                      child: TextFormField(
                        onFieldSubmitted: (value) =>
                            navigateToSearchScreen(value),
                        decoration: InputDecoration(
                            prefixIcon: InkWell(
                              onTap: () {},
                              child: const Padding(
                                  padding: EdgeInsets.only(left: 6),
                                  child: Icon(Icons.search,
                                      color: Colors.black, size: 23)),
                            ),
                            filled: true,
                            fillColor: Colors.white,
                            contentPadding: const EdgeInsets.only(top: 10),
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(7),
                                borderSide: BorderSide.none),
                            enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(7),
                                borderSide: const BorderSide(
                                    color: Colors.black38, width: 1)),
                            hintText: "Search Amazon.in",
                            hintStyle: const TextStyle(
                                fontWeight: FontWeight.w500, fontSize: 17)),
                      )),
                ),
              ),
              Container(
                color: Colors.transparent,
                height: 42,
                margin: const EdgeInsets.symmetric(horizontal: 10),
                child: const Icon(Icons.mic, color: Colors.black, size: 25),
              )
            ],
          ),
        ),
      ),
      body: FutureBuilder(
        future: fetchProduct,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator.adaptive());
          } else if (snapshot.hasError) {
            return Text(snapshot.error.toString());
          } else if (snapshot.hasData && snapshot.data!.isEmpty) {
            return const Center(
              child: Text("Not able to search specific products"),
            );
          } else {
            return Column(children: [
              const AddressBox(),
              const SizedBox(height: 10),
              Expanded(
                child: ListView.builder(
                  itemCount: snapshot.data!.length,
                  itemBuilder: (context, index) {
                    return GestureDetector(
                      onTap: () {
                        Navigator.pushNamed(context, ProductDetailScreen.routeName, arguments: snapshot.data![index]);
                      },
                      child: SearchedProduct(product: snapshot.data![index])
                    );
                  },
                ),
              ),
            ]);
          }
        },
      ),
    );
  }
}
