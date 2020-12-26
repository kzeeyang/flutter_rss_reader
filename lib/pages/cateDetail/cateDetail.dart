import 'dart:async';

import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rss_reader/common/provider/provider.dart';
import 'package:flutter_rss_reader/common/router/router.gr.dart';
import 'package:flutter_rss_reader/common/utils/utils.dart';
import 'package:flutter_rss_reader/common/values/values.dart';
import 'package:flutter_rss_reader/common/widgets/widgets.dart';
import 'package:flutter_rss_reader/global.dart';

class CateDetail extends StatefulWidget {
  final String cateName;

  const CateDetail({Key key, this.cateName}) : super(key: key);

  @override
  _CateDetailState createState() => _CateDetailState();
}

class _CateDetailState extends State<CateDetail> {
  List<RssSetting> _rssSettings;

  AppBar _buildAppBar() {
    return MyAppBar(
      title: widget.cateName,
      leading: IconButton(
        icon: Icon(
          Icons.arrow_back_ios,
          color: AppColors.primaryText,
        ),
        onPressed: () {
          ExtendedNavigator.rootNavigator.pop();
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
                .pushAddRss(cateName: widget.cateName);
          },
        ),
      ],
    );
  }

  Widget _buildBody() {
    _rssSettings = Global.appState.rssList(widget.cateName);
    return _rssSettings.length > 0
        ? _rssListWidgets()
        : Container(
            color: AppColors.primaryGreyBackground,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Text('暂无数据'),
                  ],
                ),
              ],
            ),
          );
  }

  Widget _rssListWidgets() {
    final size = MediaQuery.of(context).size;
    final width = size.width;
    return ListView.builder(
      itemCount: _rssSettings.length,
      itemBuilder: (context, index) {
        RssSetting item = _rssSettings[index];
        return Container(
          padding: EdgeInsets.symmetric(horizontal: 20),
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
              RssIcon(
                item,
                // onTap: () {
                //   Global.appState.changeRssOpen(
                //       widget.cateName, item.url, item.rssName, !item.opened);
                //   Global.saveAppState();
                // },
              ),
              Container(
                width: width * 0.6 - 45,
                padding: EdgeInsets.only(left: 5),
                child: Text(
                  item.rssName,
                  style: TextStyle(
                    fontSize: duSetFontSize(16),
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              Spacer(),
              Switch(
                value: item.opened,
                onChanged: (value) {
                  setState(() {
                    _rssSettings[index].opened = value;
                    Global.appState.changeRssOpen(widget.cateName,
                        _rssSettings[index].url, item.rssName, value);
                    Global.saveAppStateCategory();
                  });
                },
              ),
              IconButton(
                icon: Icon(
                  Icons.delete,
                  color: Colors.red[300],
                ),
                onPressed: () {
                  _rssSettings.removeAt(index);
                  toastInfo(msg: '已删除RSS: ' + item.rssName);
                  setState(() {});
                },
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildBottomTip(double width) {
    return Container(
      height: duSetHeight(50),
      child: Padding(
        padding: EdgeInsets.symmetric(
          vertical: duSetWidth(5),
          horizontal: duSetHeight(60),
        ),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(duSetWidth(25)),
            color: Colors.red[400],
          ),
          child: FlatButton.icon(
            icon: Icon(Icons.delete_outline),
            label: Text('删除分类'),
            onPressed: () {
              toastInfo(msg: '已删除分类: ' + widget.cateName);
              ExtendedNavigator.rootNavigator.pop();
              Global.appState.deleteCategory(widget.cateName);
              Global.saveAppStateCategory();
            },
            splashColor: Colors.blueGrey,
            textColor: AppColors.primaryElementText,
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final width = size.width;
    return Scaffold(
      appBar: _buildAppBar(),
      body: _buildBody(),
      bottomNavigationBar: _buildBottomTip(width),
    );
  }
}
