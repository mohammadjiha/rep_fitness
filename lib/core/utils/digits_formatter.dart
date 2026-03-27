import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sizer/sizer.dart';

class DigitsOnlyWithSnackBarFormatter extends TextInputFormatter {
  final BuildContext context;
  bool _isShowing = false;

  DigitsOnlyWithSnackBarFormatter(this.context);

  void _showError() {
    if (_isShowing) return;
    _isShowing = true;

    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          behavior: SnackBarBehavior.floating,
          elevation: 0,
          backgroundColor: Colors.transparent,
          content: Container(
            alignment: Alignment.center,
            height: 6.h,
            width: 100.w,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(15),
              color: const Color.fromRGBO(148, 246, 8, 1),
            ),
            child:  Text('Number Only',
              style: TextStyle(
                fontSize: 16.sp,
                color: Colors.black,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
      );

    Future.delayed(const Duration(milliseconds: 700), () {
      _isShowing = false;
    });
  }

  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue,
      TextEditingValue newValue,
      ) {
    final isValid = RegExp(r'^\d*$').hasMatch(newValue.text);

    if (!isValid) {
      _showError();
      return oldValue;
    }

    return newValue;
  }
}