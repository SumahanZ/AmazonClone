import 'package:flutter/material.dart';

class SingleProduct extends StatelessWidget {
  final String image;
  const SingleProduct({super.key, required this.image});

  @override
  Widget build(BuildContext context) {
    return Container(
        padding: const EdgeInsets.symmetric(horizontal: 5),
        //fast syntax to give decoration to a box, instead of making a container
        //like SizedBox
        child: DecoratedBox(
            decoration: BoxDecoration(
                border: Border.all(color: Colors.black12, width: 1.5),
                borderRadius: BorderRadius.circular(5),
                color: Colors.white),
            child: Container(
                decoration: BoxDecoration(
                    border: Border.all(color: Colors.black12, width: 1.5),
                    borderRadius: BorderRadius.circular(5),
                    color: Colors.white),
                width: 180,
                padding: const EdgeInsets.all(10),
                //fit the image based on teh maximum height that it can take
                child:
                    Image.network(image, fit: BoxFit.fitHeight, width: 180))));
  }
}
