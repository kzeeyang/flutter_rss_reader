import 'package:flutter/material.dart';
import 'package:flutter_rss_reader/common/entitys/entitys.dart';
import 'package:flutter_rss_reader/common/utils/utils.dart';
import 'package:flutter_rss_reader/common/values/values.dart';
import 'package:flutter_rss_reader/common/widgets/widgets.dart';

class SettingPage extends StatefulWidget {
  @override
  _SettingPageState createState() => _SettingPageState();
}

class _SettingPageState extends State<SettingPage> {
  final TextEditingController _addCateController = TextEditingController();
  AppBar _buildAppBar() {
    return AppBar(
      elevation: 0.0,
      backgroundColor: Colors.transparent,
      title: Text(
        '配置',
        style: TextStyle(
          color: AppColors.primaryText,
          fontFamily: AppColors.fontMontserrat,
          fontSize: duSetFontSize(18.0),
          fontWeight: FontWeight.w600,
        ),
      ),
      centerTitle: true,
      leading: IconButton(
        icon: Icon(
          Icons.arrow_back,
          color: AppColors.primaryText,
        ),
        onPressed: () {
          Navigator.pop(context);
        },
      ),
      actions: <Widget>[
        IconButton(
          icon: Icon(
            Icons.add,
            color: AppColors.primaryText,
          ),
          onPressed: _openSimpleDialog,
        ),
      ],
    );
  }

  Future _openSimpleDialog() async {
    final option = await showDialog(
      context: context,
      builder: (BuildContext context) {
        return SimpleDialog(
          title: Text('添加分类'),
          children: <Widget>[
            inputTextEdit(
              controller: _addCateController,
              // keyboardType: TextInputType.emailAddress,
              hintText: "名称",
              marginTop: 0,
              // autofocus: true,
            ),
            Container(
              padding: EdgeInsets.symmetric(horizontal: duSetWidth(100)),
              width: double.infinity,
              child: Theme(
                data: Theme.of(context).copyWith(
                  buttonColor: Theme.of(context).accentColor,
                  buttonTheme: ButtonThemeData(
                    textTheme: ButtonTextTheme.primary,
                    shape: StadiumBorder(),
                  ),
                ),
                child: RaisedButton(
                  child: Text('添加'),
                  onPressed: () {
                    Category cate;
                    cate.cateName = _addCateController.value.text;
                    print(cate.cateName);
                    Navigator.pop(context);
                  },
                  splashColor: Colors.grey,
                  elevation: 0.0,
                  color: Theme.of(context).accentColor,
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(),
    );
  }
}
