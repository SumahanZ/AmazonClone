import 'package:flutter/material.dart';

class CustomTextField extends StatelessWidget {
  final String hintText;
  final TextEditingController _controller;
  final int maxLines;
  //we can pass in the maxLines if we dont we get the default 1
  const CustomTextField({super.key, required TextEditingController controller, required this.hintText, this.maxLines = 1}) : _controller = controller;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: _controller,
      decoration: InputDecoration(
        hintText: hintText,
        border: const OutlineInputBorder(
          borderSide: BorderSide(
            color: Colors.black38,
          )
        ),
        enabledBorder: const OutlineInputBorder(
          borderSide: BorderSide(
            color: Colors.black38
          )
        )
      ),
      validator: (value) {
        if (value == null || value.isEmpty ) {
          return "Enter your $hintText";
        }
        return null;
      },
      maxLines: maxLines,
    );
  }
}