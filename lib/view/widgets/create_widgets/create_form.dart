import 'package:flutter/material.dart';

class MyTextField extends StatelessWidget {
  const MyTextField({
    super.key,
    required this.hintText,
    required this.controller,
    this.maxLines,
    this.obscure,
    this.keyboardType,
  });

  final String hintText;
  final int? maxLines;
  final TextEditingController controller;
  final bool? obscure;
  final TextInputType? keyboardType;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 10),
      child: TextFormField(
        controller: controller,
        maxLines: maxLines,
        obscureText: obscure ?? false,
        keyboardType: keyboardType,
        validator: (value) {
          if (value!.isEmpty) {
            return 'Please enter a minimum 10 characters';
          }
          return null;
        },
        decoration: InputDecoration(
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(
              color: Theme.of(context).colorScheme.secondary,
            ),
          ),
          focusedBorder: const OutlineInputBorder(
            borderSide: BorderSide(color: Colors.white),
          ),
          fillColor: Theme.of(context).colorScheme.primary,
          filled: true,
          hintStyle: const TextStyle(
            color: Colors.white,
          ),
          hintText: hintText,
          helperText: hintText,
        ),
      ),
    );
  }
}
