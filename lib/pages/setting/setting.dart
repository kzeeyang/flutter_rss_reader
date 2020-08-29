import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_rss_reader/common/provider/provider.dart';
import 'package:flutter_rss_reader/common/router/router.gr.dart';
import 'package:flutter_rss_reader/common/utils/utils.dart';
import 'package:flutter_rss_reader/common/values/values.dart';
import 'package:flutter_rss_reader/global.dart';

class SettingPage extends StatefulWidget {
  @override
  _SettingPageState createState() => _SettingPageState();
}

class _SettingPageState extends State<SettingPage> {
  List<Category> _categories = Global.appState.categories;

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
            ExtendedNavigator.rootNavigator.pushNamed(Routes.addCatePage);
          },
        ),
      ],
    );
  }

  // 内容页
  Widget _buildCateView() {
    return _categories.length > 0
        ? Container(
            color: AppColors.primaryGreyBackground,
            child: Column(
              children: <Widget>[
                Container(
                  height: duSetHeight(10),
                ),
                cateListWidget(_categories),
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

  Widget cateListWidget(List<Category> categories) {
    return Container(
      color: AppColors.primaryGreyBackground,
      child: Column(
        children: categories.map((item) {
          return Container(
            height: duSetHeight(55),
            color: AppColors.primaryWhiteBackground,
            child: Column(
              children: <Widget>[
                InkWell(
                  child: Container(
                    padding: EdgeInsets.only(
                        left: duSetWidth(20), right: duSetWidth(10)),
                    alignment: Alignment.center,
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        Text(
                          item.cateName,
                          style: TextStyle(
                            fontSize: duSetFontSize(20),
                          ),
                        ),
                        Spacer(),
                        IconButton(
                          icon: Icon(
                            Icons.chevron_right,
                            color: AppColors.primaryText,
                          ),
                          onPressed: () {
                            ExtendedNavigator.rootNavigator
                                .pushCateDetail(item: item);
                          },
                        ),
                      ],
                    ),
                  ),
                  onTap: () {
                    ExtendedNavigator.rootNavigator.pushCateDetail(item: item);
                  },
                ),
                Spacer(),
                Container(
                  height: 5,
                  color: AppColors.primaryGreyBackground,
                ),
              ],
            ),
          );
        }).toList(),
      ),
    );
  }

  // 导入导出JSON
  Widget _buildBottomTip(double width) {
    return Container(
      height: duSetHeight(50),
      color: AppColors.primaryGreyBackground,
      child: Padding(
        padding: EdgeInsets.symmetric(
          vertical: duSetWidth(5),
          horizontal: duSetHeight(50),
        ),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(duSetWidth(25)),
          ),
          child: Row(
            children: <Widget>[
              Container(
                width: duSetWidth(width / 2) - 75,
                decoration: BoxDecoration(
                  color: Colors.green[400],
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(20),
                    bottomLeft: Radius.circular(20),
                  ),
                ),
                child: Center(
                  child: Text(
                    "导入JSON",
                    style: TextStyle(color: AppColors.primaryElementText),
                  ),
                ),
              ),
              Container(
                width: duSetWidth(width / 2) - 75,
                decoration: BoxDecoration(
                  color: Colors.blueAccent,
                  borderRadius: BorderRadius.only(
                    topRight: Radius.circular(20),
                    bottomRight: Radius.circular(20),
                  ),
                ),
                child: Center(
                  child: Text(
                    "导出JSON",
                    style: TextStyle(color: AppColors.primaryElementText),
                  ),
                ),
              ),
            ],
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
      body: _buildCateView(),
      bottomNavigationBar: _buildBottomTip(width),
    );
  }
}
