import 'package:flutter/material.dart';
import 'package:flutter_rss_reader/common/utils/utils.dart';
import 'package:flutter_rss_reader/common/values/values.dart';

/// 输入框
Widget inputTextEdit({
  @required TextEditingController controller,
  TextInputType keyboardType = TextInputType.text,
  String hintText,
  bool isPassword = false,
  double marginTop = 15,
  bool autofocus = false,
}) {
  return Container(
    height: 55,
    margin: EdgeInsets.only(top: marginTop),
    decoration: BoxDecoration(
      color: AppColors.primaryWhiteBackground,
      borderRadius: Radii.k6pxRadius,
    ),
    child: TextField(
      autofocus: autofocus,
      controller: controller,
      keyboardType: keyboardType,
      decoration: InputDecoration(
        //hintText: hintText,
        labelText: hintText,
        contentPadding: EdgeInsets.fromLTRB(20, 10, 0, 9),
        border: InputBorder.none,
      ),
      style: TextStyle(
        color: AppColors.primaryText,
        fontFamily: "Avenir",
        fontWeight: FontWeight.w400,
        fontSize: 18,
      ),
      maxLines: 1,
      autocorrect: false, // 自动纠正
      obscureText: isPassword, // 隐藏输入内容, 密码框
    ),
  );
}

/// email 输入框
/// 背景白色，文字黑色，带阴影
Widget inputEmailEdit({
  @required TextEditingController controller,
  TextInputType keyboardType = TextInputType.text,
  String hintText,
  bool isPassword = false,
  double marginTop = 15,
  bool autofocus = false,
}) {
  return Container(
    height: 55,
    margin: EdgeInsets.only(top: marginTop),
    decoration: BoxDecoration(
      color: AppColors.primaryWhiteBackground,
      borderRadius: Radii.k6pxRadius,
      boxShadow: [
        BoxShadow(
          color: Color.fromARGB(41, 0, 0, 0),
          offset: Offset(0, 1),
          blurRadius: 0,
        ),
      ],
    ),
    child: TextField(
      autofocus: autofocus,
      controller: controller,
      keyboardType: keyboardType,
      decoration: InputDecoration(
        hintText: hintText,
        contentPadding: EdgeInsets.fromLTRB(20, 10, 0, 9),
        border: InputBorder.none,
        hintStyle: TextStyle(
          color: AppColors.primaryText,
        ),
      ),
      style: TextStyle(
        color: AppColors.primaryText,
        fontFamily: "Avenir",
        fontWeight: FontWeight.w400,
        fontSize: 18,
      ),
      maxLines: 1,
      autocorrect: false, // 自动纠正
      obscureText: isPassword, // 隐藏输入内容, 密码框
    ),
  );
}

// RssURL
Widget inputRSSURLEdit({
  @required TextEditingController controller,
  TextInputType keyboardType = TextInputType.text,
  String hintText,
  bool isPassword = false,
  double marginTop = 15,
  bool autofocus = false,
  Function onEditingComplete,
  Widget rotationTransition,
}) {
  return Container(
    // height: 55,
    margin: EdgeInsets.only(top: marginTop),
    decoration: BoxDecoration(
      color: AppColors.primaryWhiteBackground,
      borderRadius: Radii.k6pxRadius,
    ),
    child: TextField(
      autofocus: autofocus,
      controller: controller,
      keyboardType: keyboardType,
      decoration: InputDecoration(
        //hintText: hintText,
        labelText: hintText,
        contentPadding: EdgeInsets.fromLTRB(20, 10, 0, 9),
        border: InputBorder.none,
        suffixIcon: rotationTransition,
      ),
      style: TextStyle(
        color: AppColors.primaryText,
        fontFamily: "Avenir",
        fontWeight: FontWeight.w400,
        fontSize: 18,
      ),
      maxLines: 1,
      autocorrect: false, // 自动纠正
      obscureText: isPassword, // 隐藏输入内容, 密码框
      onEditingComplete: onEditingComplete,
    ),
  );
}

/// 输入框
Widget inputTextEditWithIconButton({
  @required TextEditingController controller,
  TextInputType keyboardType = TextInputType.text,
  String hintText,
  bool isPassword = false,
  double marginTop = 15,
  bool autofocus = false,
  Widget iconButton,
  double width,
  Widget rotationTransition,
  Function onChanged,
}) {
  return Container(
    height: 55,
    margin: EdgeInsets.only(top: marginTop),
    decoration: BoxDecoration(
      color: AppColors.primaryWhiteBackground,
      borderRadius: Radii.k6pxRadius,
    ),
    child: Row(
      children: <Widget>[
        Container(
          width: 55,
          alignment: Alignment.center,
          child: iconButton,
        ),
        Spacer(),
        Container(
          width: width - 100,
          child: TextField(
            autofocus: autofocus,
            controller: controller,
            keyboardType: keyboardType,
            decoration: InputDecoration(
              //hintText: hintText,
              labelText: hintText,
              contentPadding: EdgeInsets.fromLTRB(0, 10, 0, 9),
              border: InputBorder.none,
              suffixIcon: rotationTransition,
            ),
            style: TextStyle(
              color: AppColors.primaryText,
              fontFamily: "Avenir",
              fontWeight: FontWeight.w400,
              fontSize: 18,
            ),
            maxLines: 1,
            autocorrect: false, // 自动纠正
            obscureText: isPassword, // 隐藏输入内容, 密码框
            onChanged: onChanged,
          ),
        ),
      ],
    ),
  );
}
