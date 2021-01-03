import 'package:flip_card/flip_card.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rss_reader/common/utils/utils.dart';
import 'package:flutter_rss_reader/common/values/values.dart';

Widget flipBtnCard({
  GlobalKey<FlipCardState> key,
  double width,
  Widget iconBtn,
  Widget textWgt,
}) {
  return FlipCard(
    key: key,
    // flipOnTouch: false,
    front: Container(
      height: width / 5,
      width: width / 5,
      color: AppColors.primaryGreyBackground,
    ),
    back: Container(
      height: width / 5,
      width: width / 5,
      decoration: BoxDecoration(
        color: AppColors.primaryWhiteBackground,
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          iconBtn,
          textWgt,
        ],
      ),
    ),
  );
}
