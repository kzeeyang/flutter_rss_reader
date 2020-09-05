import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rss_reader/common/provider/provider.dart';
import 'package:flutter_rss_reader/common/router/router.gr.dart';
import 'package:flutter_rss_reader/common/utils/utils.dart';
import 'package:flutter_rss_reader/common/values/values.dart';
import 'package:flutter_rss_reader/global.dart';

class CateDetail extends StatefulWidget {
  final String cateKey;

  const CateDetail({Key key, this.cateKey}) : super(key: key);

  @override
  _CateDetailState createState() => _CateDetailState();
}

class _CateDetailState extends State<CateDetail> {
  List<RssSetting> _rssSettings;

  AppBar _buildAppBar() {
    return AppBar(
      elevation: 0.0,
      backgroundColor: Colors.transparent,
      title: Text(
        widget.cateKey,
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
          ExtendedNavigator.rootNavigator.pushNamed(Routes.settingPage);
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
                .pushAddRss(cateName: widget.cateKey);
          },
        ),
      ],
    );
  }

  Widget _buildBody() {
    _rssSettings = Global.getRssSettings(widget.cateKey);
    return _rssSettings.length > 0
        ? Container(
            color: AppColors.primaryGreyBackground,
            child: Column(
              children: <Widget>[
                Container(
                  height: duSetHeight(10),
                ),
                _rssListWidgets(_rssSettings),
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

  Widget _rssListWidgets(List<RssSetting> rssSettings) {
    return Container(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: rssSettings.map((item) {
          return Container(
            padding: EdgeInsets.symmetric(horizontal: duSetWidth(20)),
            height: duSetHeight(45),
            decoration: BoxDecoration(
              color: AppColors.primaryWhiteBackground,
              border: Border(
                bottom: BorderSide(
                  width: 1,
                  color: AppColors.primaryGreyBackground,
                ),
              ),
            ),
            child: Row(
              children: <Widget>[
                Text(
                  item.rssName,
                  style: TextStyle(
                    fontSize: duSetFontSize(16),
                  ),
                ),
                Spacer(),
                Switch(
                  value: item.opened,
                  onChanged: (value) {
                    setState(() {
                      item.opened = value;
                      Global.setRssOpend(widget.cateKey, item.url, value);
                    });
                  },
                ),
                IconButton(
                  icon: Icon(
                    Icons.delete,
                    color: Colors.red[300],
                  ),
                  onPressed: () {
                    Global.deleteRss(widget.cateKey, item.url);
                    _rssSettings = Global.getRssSettings(widget.cateKey);
                    print('delete done.');
                  },
                ),
              ],
            ),
          );
        }).toList(),
      ),
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
