import 'package:amazon_app/common/widgets/custom_button.dart';
import 'package:amazon_app/common/widgets/stars.dart';
import 'package:amazon_app/constants/global_variables.dart';
import 'package:amazon_app/core/product_details/services/product_details_service.dart';
import 'package:amazon_app/core/search/screens/search_screen.dart';
import 'package:amazon_app/models/product.dart';
import 'package:amazon_app/providers/user_provider.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:provider/provider.dart';

class ProductDetailScreen extends StatefulWidget {
  static const routeName = "/product-details";
  final Product product;
  const ProductDetailScreen({super.key, required this.product});

  @override
  State<ProductDetailScreen> createState() => _ProductDetailScreenState();
}

class _ProductDetailScreenState extends State<ProductDetailScreen> {
  final productDetailService = ProductDetailsService();
  double avgRating = 0;
  double myRating = 0;

  void addToCart() async {
    await productDetailService.addToCart(
        context: context, product: widget.product);
  }

  void navigateToSearchScreen(String query) {
    Navigator.pushNamed(context, SearchScreen.routeName, arguments: query);
  }

  @override
  void initState() {
    super.initState();
    double totalRating = 0;
    for (int i = 0; i < widget.product.rating!.length; i++) {
      totalRating += widget.product.rating![i].rating;

      if (widget.product.rating![i].userId ==
          Provider.of<UserNotifier>(context, listen: false).user.id) {
        myRating = widget.product.rating![i].rating;
      }
    }
    if (totalRating != 0) {
      avgRating = totalRating / widget.product.rating!.length;
    }
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
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [Text(widget.product.id!), const Stars(rating: 4)]),
            ),
            Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 20, horizontal: 10),
                child: Text(widget.product.name,
                    style: const TextStyle(fontSize: 15))),
            CarouselSlider(
              items: widget.product.imagesUrl.map((url) {
                return Image.network(url, fit: BoxFit.contain, height: 200);
              }).toList(),
              options: CarouselOptions(
                viewportFraction: 1,
                height: 300,
              ),
            ),
            Container(
              color: Colors.black12,
              height: 5,
            ),
            Padding(
              padding: const EdgeInsets.all(8),
              child: RichText(
                text: TextSpan(
                  text: "Deal Price",
                  style: const TextStyle(
                      fontSize: 16,
                      color: Colors.black,
                      fontWeight: FontWeight.bold),
                  children: [
                    TextSpan(
                        text: "\$${widget.product.price}",
                        style: const TextStyle(
                            fontSize: 22,
                            color: Colors.red,
                            fontWeight: FontWeight.w500))
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(widget.product.description),
            ),
            Container(
              color: Colors.black12,
              height: 5,
            ),
            Padding(
              padding: const EdgeInsets.all(10),
              child: CustomButton(text: "Buy Now", onTap: () {}),
            ),
            const SizedBox(height: 10),
            Padding(
              padding: const EdgeInsets.all(10),
              child: CustomButton(
                text: "Add to Cart",
                onTap: () {
                  addToCart();
                },
                color: const Color.fromRGBO(254, 216, 19, 1),
              ),
            ),
            const SizedBox(height: 10),
            Container(
              color: Colors.black12,
              height: 5,
            ),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 10.0),
              child: Text(
                "Rate The Product",
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
              ),
            ),
            RatingBar.builder(
                initialRating: myRating,
                itemCount: 5,
                itemPadding: const EdgeInsets.symmetric(horizontal: 4),
                minRating: 1,
                allowHalfRating: true,
                itemBuilder: (context, index) {
                  return const Icon(Icons.star,
                      color: GlobalVariables.secondaryColor);
                },
                onRatingUpdate: (rating) async {
                  await productDetailService.rateProduct(
                      context: context,
                      product: widget.product,
                      rating: rating);
                })
          ],
        ),
      ),
    );
  }
}
