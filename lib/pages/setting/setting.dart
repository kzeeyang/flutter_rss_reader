import 'dart:io';

import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_rss_reader/common/provider/provider.dart';
import 'package:flutter_rss_reader/common/router/router.gr.dart';
import 'package:flutter_rss_reader/common/utils/utils.dart';
import 'package:flutter_rss_reader/common/values/values.dart';
import 'package:flutter_rss_reader/common/widgets/reward.dart';
import 'package:flutter_rss_reader/global.dart';
import 'package:flutter_rss_reader/pages/setting/paddingSpace.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';

import 'cateList.dart';
import '../../common/widgets/inputDialog.dart';

class SettingPage extends StatefulWidget {
  @override
  _SettingPageState createState() => _SettingPageState();
}

class _SettingPageState extends State<SettingPage> {
  ScrollController _scrollController = new ScrollController();
  String _choice = 'Nothing';

  final Duration paddindDuration = Duration(milliseconds: 1000);

  @override
  initState() {
    super.initState();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  SliverAppBar _buildSliverAppBar() {
    return SliverAppBar(
      title: Text('配置'),
      pinned: true, //保持在顶部
      backgroundColor: AppColors.primaryWhiteBackground,
      floating: true, //向下滚动时会显示回来
      flexibleSpace: FlexibleSpaceBar(
        title: Text(
          '配置',
          style: TextStyle(
            color: AppColors.primaryText,
            fontFamily: AppColors.fontMontserrat,
            fontSize: duSetFontSize(18.0),
            fontWeight: FontWeight.w600,
            letterSpacing: 3.0, //字间距
          ),
        ),
        centerTitle: true,
      ),
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

  // 导入导出JSON
  Widget _buildBottomTip() {
    final size = MediaQuery.of(context).size;
    final width = size.width;
    return Container(
      height: duSetHeight(50),
      alignment: Alignment.center,
      child: Padding(
        padding: EdgeInsets.symmetric(
          vertical: 7,
          horizontal: 50,
        ),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(25),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Container(
                width: width / 2 - 75,
                decoration: BoxDecoration(
                  color: Colors.green[400],
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(20),
                    bottomLeft: Radius.circular(20),
                  ),
                ),
                child: FlatButton(
                  child: Text(
                    "导入分类",
                    style: TextStyle(color: AppColors.primaryElementText),
                  ),
                  onPressed: () {
                    inputDialog(context);
                  },
                ),
              ),
              Container(
                width: width / 2 - 75,
                decoration: BoxDecoration(
                  color: Colors.blueAccent,
                  borderRadius: BorderRadius.only(
                    topRight: Radius.circular(20),
                    bottomRight: Radius.circular(20),
                  ),
                ),
                child: FlatButton(
                  child: Text(
                    "导出分类",
                    style: TextStyle(color: AppColors.primaryElementText),
                  ),
                  onPressed: () {
                    final jsonDate = Global.appState.categoryToJson();
                    print('${jsonDate.toString()}');
                    requestPermission(Permission.storage).then((state) async {
                      print('state: $state');
                      if (state) {
                        saveFile(jsonDate.toString());
                      }
                    });
                  },
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
    return Scaffold(
      body: Listener(
        onPointerUp: (event) {
          final length = Global.appState.category.keys.toList().length;
          if (length <= 12) {
            _scrollController.animateTo(
              0,
              duration: paddindDuration,
              curve: Curves.ease,
            );
          } else {
            final size = MediaQuery.of(context).size;
            final height = size.height;
            double padding = length * 50 + duSetHeight(190) - height;
            var offset = _scrollController.offset;
            if (offset > padding) {
              _scrollController.animateTo(
                padding,
                duration: paddindDuration,
                curve: Curves.ease,
              );
            }
          }
        },
        child: CustomScrollView(
          slivers: [
            _buildSliverAppBar(),
            cateList(context),
            paddingSpace(context),
            rewardWidget(),
          ],
          controller: _scrollController,
        ),
      ),
      bottomNavigationBar: _buildBottomTip(),
    );
  }
}
