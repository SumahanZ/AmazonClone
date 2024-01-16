import 'package:amazon_app/core/account/widgets/single_product.dart';
import 'package:amazon_app/core/admin/screens/add_product_screen.dart';
import 'package:amazon_app/core/admin/services/admin_services.dart';
import 'package:amazon_app/models/product.dart';
import 'package:flutter/material.dart';

class PostsScreen extends StatefulWidget {
  const PostsScreen({super.key});

  @override
  State<PostsScreen> createState() => _PostsScreenState();
}

class _PostsScreenState extends State<PostsScreen> {
  final adminServices = AdminServices();
  
  late Future<List<Product>>  _myData;

  @override
  void initState() {
    super.initState();
    _myData = adminServices.getAllProducts(context: context);
    setState(() {});
  }
  

  void navigateToAddProduct() {
    Navigator.pushNamed(context, AddProductScreen.routeName);
  }

  void deleteProduct(String productId) async  {
    await adminServices.deleteProduct(context: context, productId: productId, onSuccess: () {
      setState(() {
        _myData = adminServices.getAllProducts(context: context);
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder(
        future: _myData,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator.adaptive());
          } else if (snapshot.hasError) {
            return Center(child: Text(snapshot.error.toString()));
          } else if (snapshot.data!.isEmpty) {
            return const Center(
              child: Text("Products Empty"),
            );
          } else {
            return GridView.builder(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
              ),
              itemCount: snapshot.data!.length,
              itemBuilder: (context, index) {
                final productData = snapshot.data![index];
                return Column(
                  children: [
                    SizedBox(
                      height: 140,
                      child: SingleProduct(image: productData.imagesUrl[0]),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Expanded(
                          child: Text(
                            productData.name,
                            overflow: TextOverflow.ellipsis,
                            maxLines: 2,
                          ),
                        ),
                        IconButton(
                          onPressed: () {
                            deleteProduct(productData.id!);
                          },
                          icon: const Icon(Icons.delete_outline),
                        ),
                      ],
                    ),
                  ],
                );
              },
            );
          }
        },
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: FloatingActionButton(
        onPressed: navigateToAddProduct,
        tooltip: "Add a Product",
        child: const Icon(Icons.add),
      ),
    );
  }
}
