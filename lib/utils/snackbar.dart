import 'package:flutter/material.dart';

class Toastfy {
  final BuildContext _context;

  Toastfy(this._context);

  void _showMessage(
      String text, Color? color, SnackBarAction? action, int? seconds) {
    var scaffoldMessenger = ScaffoldMessenger.of(_context);
    scaffoldMessenger.hideCurrentSnackBar();
    scaffoldMessenger.showSnackBar(
      SnackBar(
        content: Text(
          text,
          style: const TextStyle(
            color: Colors.white,
          ),
        ),
        duration: Duration(seconds: seconds ?? 2),
        backgroundColor: color,
        action: action,
      ),
    );
  }

  void show(
    String text,
    SnackBarAction? action,
    int? seconds,
  ) {
    _showMessage(text, null, action, seconds);
  }

  void success(
    String text,
    SnackBarAction? action,
    int? seconds,
  ) {
    _showMessage(text, Colors.green, action, seconds);
  }

  void error(
    String text,
    SnackBarAction? action,
    int? seconds,
  ) {
    _showMessage(text, Colors.red, action, seconds);
  }

  void warning(
    String text,
    SnackBarAction? action,
    int? seconds,
  ) {
    _showMessage(text, Colors.orange, action, seconds);
  }
}
