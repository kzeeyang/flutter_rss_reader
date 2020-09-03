import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rss_reader/common/provider/provider.dart';
import 'package:flutter_rss_reader/common/router/router.gr.dart';
import 'package:flutter_rss_reader/common/utils/utils.dart';
import 'package:flutter_rss_reader/common/values/values.dart';

class CateDetail extends StatefulWidget {
  final Category item;

  const CateDetail({Key key, this.item}) : super(key: key);

  @override
  _CateDetailState createState() => _CateDetailState();
}

class _CateDetailState extends State<CateDetail> {
  AppBar _buildAppBar() {
    return AppBar(
      elevation: 0.0,
      backgroundColor: Colors.transparent,
      title: Text(
        widget.item.cateName,
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
        IconButton(
          icon: Icon(
            Icons.add,
            color: AppColors.primaryText,
          ),
          onPressed: () {
            ExtendedNavigator.rootNavigator
                .pushAddRss(cateName: widget.item.cateName);
          },
        ),
      ],
    );
  }

  Widget _buildBody() {
    return widget.item.rssSettings.length > 0
        ? Container(
            color: AppColors.primaryGreyBackground,
            child: Column(
              children: <Widget>[
                Container(
                  height: duSetHeight(10),
                ),
                _rssListWidgets(widget.item.rssSettings),
              ],
            ),
          )
        : Container(
            color: AppColors.primaryGreyBackground,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Text('暂无分类'),
                  ],
                ),
              ],
            ),
          );
  }

  Widget _rssListWidgets(List<RssSetting> rssSetting) {
    return Container(
        height: duSetHeight(45),
        color: AppColors.primaryWhiteBackground,
        child: Column(
          children: rssSetting.map((item) {
            return Container(
              alignment: Alignment.center,
              padding:
                  EdgeInsets.only(left: duSetWidth(20), right: duSetWidth(10)),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  Text(
                    item.rssName,
                    style: TextStyle(
                      fontSize: duSetFontSize(20),
                    ),
                  ),
                ],
              ),
            );
          }).toList(),
        ));
  }

  @override
  Widget build(BuildContext context) {
    if (widget.item.rssSettings != null) {
      print('rssLength: ${widget.item.rssSettings.length}');
    }
    return Scaffold(
      appBar: _buildAppBar(),
      body: _buildBody(),
    );
  }
}
