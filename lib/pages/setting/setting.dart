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

import 'cateList.dart';

class SettingPage extends StatefulWidget {
  @override
  _SettingPageState createState() => _SettingPageState();
}

class _SettingPageState extends State<SettingPage> {
  ScrollController _scrollController = new ScrollController();

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
                child: FlatButton(
                  child: Text(
                    "导入JSON",
                    style: TextStyle(color: AppColors.primaryElementText),
                  ),
                  onPressed: () {},
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
                child: FlatButton(
                  child: Text(
                    "导出JSON",
                    style: TextStyle(color: AppColors.primaryElementText),
                  ),
                  onPressed: () {
                    final jsonDate = Global.appState.categoryToJson();
                    print('${jsonDate.toString()}');
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
              duration: Duration(milliseconds: 1500),
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
                duration: Duration(milliseconds: 1500),
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
