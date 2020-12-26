import 'dart:io';

import 'package:auto_route/auto_route.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_rss_reader/common/provider/provider.dart';
import 'package:flutter_rss_reader/common/router/router.gr.dart';
import 'package:flutter_rss_reader/common/utils/utils.dart';
import 'package:flutter_rss_reader/common/values/values.dart';
import 'package:flutter_rss_reader/common/widgets/reward.dart';
import 'package:flutter_rss_reader/common/widgets/widgets.dart';
import 'package:flutter_rss_reader/global.dart';
import 'package:flutter_rss_reader/pages/setting/paddingSpace.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';

import 'cateList.dart';
import '../../common/widgets/inputDialog.dart';

class SettingPage extends StatefulWidget {
  @override
  _SettingPageState createState() => _SettingPageState();
}

class _SettingPageState extends State<SettingPage> {
  ScrollController _scrollController = new ScrollController(
    initialScrollOffset: 0,
  );
  // String _choice = 'Nothing';

  final Duration paddindDuration = Duration(milliseconds: 400);

  TapGestureRecognizer _tapGestureRecognizer = new TapGestureRecognizer();

  int _pointerDownNum = 0;

  @override
  initState() {
    // _hideReward();
    super.initState();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  // _hideReward() {
  //   // final height = MediaQuery.of(context).size.height;
  //   _scrollController.addListener(() {
  //     print(_scrollController.offset); //打印滚动位置
  //     var offset = _scrollController.offset;
  //     // if (offset > height) {
  //     _scrollController.animateTo(
  //       _scrollController.position.maxScrollExtent - rewardHeight,
  //       duration: paddindDuration,
  //       curve: Curves.ease,
  //     );
  //     // }
  //   });
  // }

  Widget _buildAppBar() {
    return MyAppBar(
      title: '配置',
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
                    // final jsonDate = Global.appState.categoryToJson();
                    // // debugPrint('${jsonDate.toString()}');
                    // requestPermission(Permission.storage).then((state) async {
                    //   if (state) {
                    //     saveFile(jsonDate.toString());
                    //   }
                    // });
                    Global.saveAppStateCategory();
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
    final cateLength = Global.appState.category.length;
    final pageWidth = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;
    final itemHeight = 50.0;
    final paddingHeight = height - itemHeight * cateLength;
    final rewardHeight = 300.0;

    return Scaffold(
      appBar: _buildAppBar(),
      body: Listener(
        onPointerDown: (event) {
          // print("point down");
          _pointerDownNum++;
        },
        onPointerUp: (event) {
          // print("point up");
          print("pageHeight: $height");
          print("${event.position}");
          _pointerDownNum--;
          double imgWidth = 200;
          var scrollOffset = _scrollController.offset;
          var pointOffset = event.position;
          double padding = 0;
          var itemLength = itemHeight * cateLength;

          if (_pointerDownNum == 0) {
            if (itemLength > height) {
              padding = itemLength - height;
            }
            if (scrollOffset > 0) {
              _scrollController.animateTo(
                padding,
                duration: paddindDuration,
                curve: Curves.ease,
              );
            }
          } else if (_pointerDownNum > 0) {
            if (scrollOffset - imgWidth > 0 &&
                height <= imgWidth + pointOffset.dy &&
                (pageWidth - imgWidth) / 2 < pointOffset.dx &&
                pointOffset.dx < pageWidth - imgWidth / 2) {
              _pointerDownNum = 0;
              _scrollController.animateTo(
                padding,
                duration: paddindDuration,
                curve: Curves.ease,
              );
              final rewardPic = "assets/images/微信图片_20200602112022.jpg";
              ExtendedNavigator.rootNavigator.pushPhotoViewScreen(
                imageProvider: AssetImage(rewardPic),
                heroTag: 'simple',
              );
            }
          }
        },
        child: ListView(
          physics: ClampingScrollPhysics(),
          controller: _scrollController,
          children: [
            cateLength > 0
                ? cateList(context, itemHeight)
                : Container(
                    height: height,
                    child: Center(child: Text("暂无分类")),
                  ),
            cateLength == 0
                ? Container()
                : paddingHeight > 0
                    ? Container(
                        height: paddingHeight,
                        child: null,
                      )
                    : Container(),
            rewardWidget(rewardHeight),
          ],
        ),
      ),
      bottomNavigationBar: _buildBottomTip(),
    );
  }
}
