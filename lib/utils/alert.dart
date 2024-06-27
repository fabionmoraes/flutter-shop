import 'package:flutter/material.dart';

class AlertMessage {
  BuildContext context;

  AlertMessage(this.context);

  Future<bool?> confirmed(String description) {
    return showDialog<bool>(
        context: context,
        builder: (ctx) => AlertDialog(
              title: const Text('Tem certeza?'),
              content: Text(description),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.of(ctx).pop(false);
                  },
                  child: const Text('Não'),
                ),
                TextButton(
                  onPressed: () {
                    Navigator.of(ctx).pop(true);
                  },
                  child: const Text('Sim'),
                ),
              ],
            ));
  }
}
