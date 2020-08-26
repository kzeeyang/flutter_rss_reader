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
            height: duSetHeight(50),
            padding:
                EdgeInsets.only(left: duSetWidth(20), right: duSetWidth(10)),
            color: AppColors.primaryWhiteBackground,
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
                        .pushNamed(Routes.addCatePage);
                  },
                ),
              ],
            ),
          );
        }).toList(),
      ),
    );
  }

  // 打赏
  Widget _buildBottomTip() {
    return BottomNavigationBar(
        // items: _bottomTabs,
        // currentIndex: _page,
        // // fixedColor: AppColors.primaryElement,
        // type: BottomNavigationBarType.fixed,
        // onTap: _handleNavBarTap,
        // showSelectedLabels: false,
        // showUnselectedLabels: false,
        );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(),
      body: _buildCateView(),
      // bottomNavigationBar: _buildBottomTip(),
    );
  }
}
