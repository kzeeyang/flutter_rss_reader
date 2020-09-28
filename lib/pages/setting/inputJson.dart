import 'package:flutter/material.dart';

Future openSimpleDialog(BuildContext context) async {
  final option = await showDialog(
    context: context,
    builder: (BuildContext context) {
      return SimpleDialog(
        title: Text('SimpleDialog'),
        children: <Widget>[
          SimpleDialogOption(
            child: Text('Option A'),
            onPressed: () {},
          ),
          SimpleDialogOption(
            child: Text('Option B'),
            onPressed: () {},
          ),
          SimpleDialogOption(
            child: Text('Option C'),
            onPressed: () {},
          ),
        ],
      );
    },
  );
}
