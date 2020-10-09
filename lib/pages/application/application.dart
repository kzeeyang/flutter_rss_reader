import 'dart:math';

import 'package:auto_route/auto_route.dart';
import 'package:circle_list/circle_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter_custom_clippers/flutter_custom_clippers.dart';
import 'package:flutter_rss_reader/common/router/router.gr.dart';
import 'package:flutter_rss_reader/common/utils/full_screen_dialog_util.dart';
import 'package:flutter_rss_reader/common/utils/screen.dart';
import 'package:flutter_rss_reader/common/utils/utils.dart';
import 'package:flutter_rss_reader/common/values/colors.dart';
import 'package:flutter_rss_reader/common/widgets/app.dart';
import 'package:flutter_rss_reader/global.dart';
import 'package:flutter_rss_reader/pages/drawer/drawerPage.dart';

class ApplicationPage extends StatefulWidget {
  @override
  _ApplicationPageState createState() => _ApplicationPageState();
}

class _ApplicationPageState extends State<ApplicationPage>
    with SingleTickerProviderStateMixin {
  List<String> cateList;
  int cateLength;
  IconUtil _iconUtil;

  AnimationController _controller;
  Animation _animation;

  @override
  void initState() {
    _controller =
        AnimationController(vsync: this, duration: Duration(milliseconds: 500));
    _animation = new Tween(begin: 0.0, end: 1.0)
        .animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));
    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  // 顶部导航
  Widget _buildAppBar() {
    return AppBar(
      // context: context,
      backgroundColor: Colors.transparent,
      elevation: 0,
      title: Text(
        'Home',
        style: TextStyle(
          color: AppColors.primaryText,
          fontFamily: AppColors.fontMontserrat,
          fontSize: duSetFontSize(18.0),
          fontWeight: FontWeight.w600,
        ),
      ),
      centerTitle: true,
      actions: <Widget>[
        IconButton(
          icon: Icon(
            Icons.settings,
            color: AppColors.primaryText,
          ),
          onPressed: () {
            ExtendedNavigator.rootNavigator.pushNamed(Routes.settingPage);
          },
        ),
      ],
    );
  }

  // // 底部导航
  // Widget _buildBottomNavigationBar() {
  //   return BottomNavigationBar(
  //     items: _bottomTabs,
  //     currentIndex: _page,
  //     // fixedColor: AppColors.primaryElement,
  //     type: BottomNavigationBarType.fixed,
  //     onTap: _handleNavBarTap,
  //     showSelectedLabels: false,
  //     showUnselectedLabels: false,
  //   );
  // }

  @override
  Widget build(BuildContext context) {
    cateList = Global.appState.category.keys.toList();
    cateLength = cateList.length;
    _iconUtil = IconUtil.getInstance();
    return Scaffold(
      appBar: _buildAppBar(),
      body: Center(
        child: CircleList(
          outerCircleColor: Colors.blue[600],
          innerCircleColor: Colors.white24,
          origin: Offset(0, 0),
          children: List.generate(cateLength, (index) {
            return Icon(
              _iconUtil.getIconDataForCategory(
                Global.appState.categoryIconName(cateList[index]),
              ),
              color: Colors.white,
              size: duSetFontSize(30),
            );
          }),
        ),
      ),
      // drawer: DrawerPage(),
      // bottomNavigationBar: _buildBottomNavigationBar(),
      floatingActionButton: GestureDetector(
        onLongPress: () {},
        child: AnimatedBuilder(
          animation: _animation,
          builder: (ctx, child) {
            return Transform.translate(
              offset: Offset(0, (_animation.value) * 56),
              child: Transform.scale(scale: 1 - _animation.value, child: child),
            );
          },
          child: Transform.rotate(
            angle: -pi / 2,
            child: FloatingActionButton(
              onPressed: () async {
                FullScreenDialog.getInstance().showDialog(
                    context,
                    Container(
                      child: Text('test'),
                    ));
                _controller.forward();
              },
              child: Transform.rotate(
                angle: pi / 2,
                child: Icon(
                  Icons.add,
                  size: 25,
                  color: Colors.white,
                ),
              ),
              // backgroundColor: Theme.of(context).primaryColor,
              shape: FloatingBorder(),
            ),
          ),
        ),
      ),
      floatingActionButtonAnimator: FloatingActionButtonAnimator.scaling,
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
}
