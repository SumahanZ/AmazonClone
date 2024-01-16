// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:amazon_app/models/rating.dart';

List<Product> getProductsFromJson(String str) => List<Product>.from(json.decode(str).map((x) => Product.fromJson(x)));

class Product {
  final String name;
  final String description;
  final double quantity;
  final List<String> imagesUrl;
  final String category;
  final double price;
  //we will set this later when we get data from server
  final String? id;
  final List<Rating>? rating;

  Product({required this.name, required this.description, required this.quantity, required this.imagesUrl, required this.category, required this.price, this.id, this.rating,});


  //rating

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'name': name,
      'description': description,
      'quantity': quantity,
      'imagesUrl': imagesUrl,
      'category': category,
      'price': price,
      '_id': id,
      'rating': rating,
    };
  }

  factory Product.fromMap(Map<String, dynamic> map) {
    return Product(
      rating: map["ratings"] != null ? List<Rating>.from(map['ratings']?.map((x) => Rating.fromMap(x))) : null,
      name: map['name'] as String,
      description: map['description'] as String,
      quantity: map['quantity']?.toDouble() ?? 0.0,
      imagesUrl: List<String>.from(map['imagesUrl']),
      category: map['category'] as String,
      price: map['price'].toDouble() ?? 0.0,
      id: map['_id'],
      
    );
  }

  String toJson() => json.encode(toMap());

  factory Product.fromJson(String source) => Product.fromMap(json.decode(source) as Map<String, dynamic>);
}
