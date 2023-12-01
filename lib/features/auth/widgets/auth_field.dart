import 'package:flutter/material.dart';
import 'package:twitter_klone_clone/theme/pallete.dart';

class AuthField extends StatelessWidget {
  final TextEditingController controller;
  final String hintText;

  const AuthField({
    super.key,
    required this.controller,
    required this.hintText,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(
        hintText: hintText,
        hintStyle: const TextStyle(fontSize: 18,),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(5),
          borderSide: const BorderSide(color: Pallete.greyColor, width: 2),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(5),
          borderSide: const BorderSide(color: Pallete.blueColor, width: 2),
        ),
        contentPadding: const EdgeInsets.all(22)
      ),
    );
  }
}
