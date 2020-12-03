import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rss_reader/common/router/router.gr.dart';
import 'package:flutter_rss_reader/common/utils/screen.dart';
import 'package:flutter_rss_reader/common/utils/utils.dart';
import 'package:flutter_rss_reader/common/values/colors.dart';
import 'package:flutter_rss_reader/common/widgets/widgets.dart';
import 'package:flutter_rss_reader/global.dart';
import 'package:flutter_rss_reader/pages/application/bodyWidget.dart';
import 'package:flutter_rss_reader/pages/application/floatingActionButton.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';

class ApplicationPage extends StatefulWidget {
  @override
  _ApplicationPageState createState() => _ApplicationPageState();
}

class _ApplicationPageState extends State<ApplicationPage> {
  DateTime _lastTime;

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  // 顶部导航
  Widget _buildAppBar() {
    return MyAppBar(
      title: Global.appState.showCategory == null
          ? "Home".toUpperCase()
          : Global.appState.showCategory.cateName.toUpperCase(),
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(),
      body: WillPopScope(
        onWillPop: () async {
          if (_lastTime == null ||
              DateTime.now().difference(_lastTime) > Duration(seconds: 2)) {
            //两次点击间隔超过2s重新计时
            _lastTime = DateTime.now();
            toastInfo(
              msg: "再按一次退出",
              toastGravity: ToastGravity.BOTTOM,
            );
            return false;
          }
          return true;
        },
        child: Global.appState.showCategory == null
            ? Container(
                color: AppColors.primaryGreyBackground,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Text('尚未添加分类'),
                      ],
                    ),
                  ],
                ),
              )
            : Global.appState.showCategory.rssSettings.length == 0
                ? Container(
                    color: AppColors.primaryGreyBackground,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Text('分类下尚未添加RSS'),
                          ],
                        ),
                      ],
                    ),
                  )
                : BodyWidget(),
      ),
      floatingActionButton: Global.appState.showCategory == null
          ? Container()
          : AnimationFloatingButton(),
      floatingActionButtonAnimator: FloatingActionButtonAnimator.scaling,
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
}
