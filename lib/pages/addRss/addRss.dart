import 'package:flutter/material.dart';
import 'package:flutter_rss_reader/common/utils/utils.dart';
import 'package:flutter_rss_reader/common/values/values.dart';

class AddRss extends StatefulWidget {
  @override
  _AddRssState createState() => _AddRssState();
}

class _AddRssState extends State<AddRss> {
  AppBar _buildAppBar() {
    return AppBar(
      elevation: 0.0,
      backgroundColor: Colors.transparent,
      title: Text(
        "添加RSS",
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
          Icons.arrow_back_ios,
          color: AppColors.primaryText,
        ),
        onPressed: () {
          Navigator.pop(context);
        },
      ),
      actions: <Widget>[
        FlatButton(
          child: Text(
            '确认',
          ),
          onPressed: () {},
          textColor: AppColors.primaryText,
        ),
      ],
    );
  }

  Widget _buildBody() {
    return Container(
      color: AppColors.primaryGreyBackground,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(),
      body: _buildBody(),
    );
  }
}
