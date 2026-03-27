import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

class AppTextField extends StatefulWidget {
  final TextEditingController controller;
  final String hintText;
  final String iconAsset;
  final TextInputType keyboardType;
  final bool isPassword;

  const AppTextField({
    super.key,
    required this.controller,
    required this.hintText,
    required this.iconAsset,
    this.keyboardType = TextInputType.text,
    this.isPassword = false,
  });

  @override
  State<AppTextField> createState() => _AppTextFieldState();
}

class _AppTextFieldState extends State<AppTextField> {
  late bool _obscure;

  @override
  void initState() {
    super.initState();
    _obscure = widget.isPassword;
  }

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: widget.controller,
      keyboardType: widget.keyboardType,
      obscureText: widget.isPassword ? _obscure : false,
      style: const TextStyle(color: Colors.white),
      cursorColor: Colors.white.withOpacity(0.1),
      decoration: InputDecoration(
        filled: true,
        fillColor: Colors.white.withOpacity(0.1),
        contentPadding: EdgeInsets.symmetric(vertical: 2.5.h),
        hintStyle: const TextStyle(color: Colors.white),
        border: OutlineInputBorder(
          borderSide: const BorderSide(color: Colors.white30, width: 1.5),
          borderRadius: BorderRadius.circular(15),
        ),
        prefixIcon: Image.asset(widget.iconAsset),

        hintText: widget.hintText,

        suffixIcon: widget.isPassword
            ? IconButton(
          icon: Icon(
            _obscure ? Icons.visibility_off : Icons.visibility,
            color: Colors.white70,
          ),
          onPressed: () => setState(() => _obscure = !_obscure),
        )
            : null,
      ),
    );
  }
}
