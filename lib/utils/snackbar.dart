import 'package:flutter/material.dart';

class Toastfy {
  BuildContext context;

  Toastfy(this.context);

  void _showMessage(String text, Color? color, SnackBarAction? action) {
    var scaffoldMessenger = ScaffoldMessenger.of(context);
    scaffoldMessenger.hideCurrentSnackBar();
    scaffoldMessenger.showSnackBar(
      SnackBar(
        content: Text(
          text,
          style: const TextStyle(
            color: Colors.white,
          ),
        ),
        duration: const Duration(seconds: 2),
        backgroundColor: color,
        action: action,
      ),
    );
  }

  void show(
    String text,
    SnackBarAction? action,
  ) {
    _showMessage(text, null, action);
  }

  void success(
    String text,
    SnackBarAction? action,
  ) {
    _showMessage(text, Colors.green, action);
  }

  void error(
    String text,
    SnackBarAction? action,
  ) {
    _showMessage(text, Colors.red, action);
  }

  void warning(
    String text,
    SnackBarAction? action,
  ) {
    _showMessage(text, Colors.orange, action);
  }
}
