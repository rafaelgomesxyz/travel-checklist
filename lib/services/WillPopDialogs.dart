import 'package:flutter/material.dart';

class WillPopDialogs {
  WillPopDialogs._privateConstructor(); // Singleton
  static final WillPopDialogs instance = WillPopDialogs._privateConstructor();

  Future<bool> onWillPopForm(BuildContext context, bool hasModified) {
    if (!hasModified) {
      return Future.value(true);
    }
    return showDialog(
      context: context,
      builder: (BuildContext dialogContext) => AlertDialog(
        actions: <Widget> [
          FlatButton(
            child: Text('Não'),
            onPressed: () {
              Navigator.pop(dialogContext, false);
            },
          ),
          FlatButton(
            child: Text('Sim'),
            onPressed: () {
              Navigator.pop(dialogContext, true);
            },
          ),
        ],
        title: Text('Tem certeza que deseja descartar as alterações?'),
      ),
    ) ?? false;
  }
}