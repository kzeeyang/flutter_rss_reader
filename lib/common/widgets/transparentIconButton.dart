import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

Widget TransparentIconButton({
  Icon icon,
  Function onPressed,
}) {
  return IconButton(
    highlightColor: Colors.transparent,
    splashColor: Colors.transparent,
    icon: icon,
    onPressed: onPressed,
  );
}

Widget TransparentFlatButton({
  Widget child,
  Function onPressed,
}) {
  return FlatButton(
    highlightColor: Colors.transparent,
    splashColor: Colors.transparent,
    child: child,
    onPressed: onPressed,
  );
}
