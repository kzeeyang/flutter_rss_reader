import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rss_reader/common/apis/api.dart';
import 'package:flutter_rss_reader/common/provider/app.dart';
import 'package:flutter_rss_reader/common/router/router.gr.dart';
import 'package:flutter_rss_reader/common/utils/utils.dart';
import 'package:flutter_rss_reader/common/values/values.dart';
import 'package:flutter_rss_reader/common/widgets/widgets.dart';
import 'package:dart_rss/dart_rss.dart';
import 'package:flutter_rss_reader/global.dart';

class AddRss extends StatefulWidget {
  final String cateName;

  const AddRss({Key key, this.cateName}) : super(key: key);

  @override
  _AddRssState createState() => _AddRssState();
}

class _AddRssState extends State<AddRss> with TickerProviderStateMixin {
  // 控制器
  final TextEditingController _urlController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();
  bool _used = true;

  AnimationController controller;
  RssSetting _rssSetting;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    controller = AnimationController(
      duration: Duration(milliseconds: 1000),
      vsync: this, //防止消耗动画外不必要的资源
    );

    controller.addStatusListener((status) {
      if (_nameController.text.isEmpty && status == AnimationStatus.completed) {
        controller.reset();
        //开启
        controller.forward();
      }
      // else if (status == AnimationStatus.dismissed) {
      //   //动画从 controller.reverse() 反向执行 结束时会回调此方法
      //   print("status is dismissed");
      // } else if (status == AnimationStatus.forward) {
      //   print("status is forward");
      //   //执行 controller.forward() 会回调此状态
      // } else if (status == AnimationStatus.reverse) {
      //   //执行 controller.reverse() 会回调此状态
      //   print("status is reverse");
      // }
    });
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();

    controller.dispose();
  }

  _checkRssUrl() async {
    if (!duIsURL(_urlController.text)) {
      toastInfo(msg: '请输入正确的RSS链接');
      return;
    }

    if (checkHadUrl(
        Global.appState.categories[widget.cateName], _urlController.text)) {
      toastInfo(msg: 'RSS链接已存在当前分类');
      return;
    }
    controller.reset();
    _nameController.text = null;
    controller.forward();
    RssFeed channel = await Rss.testConn(
      _urlController.value.text,
      context: context,
      cacheDisk: true,
    );
    _nameController.text = channel.title;
    //controller.stop();
  }

  _addRss() {
    _rssSetting = RssSetting(
      url: _urlController.value.text,
      rssName: _nameController.value.text,
      opened: _used,
    );
    Global.addRssByCategoryName(widget.cateName, _rssSetting);
    Global.saveAppState();
    Navigator.pop(context);
  }

  AppBar _buildAppBar() {
    return AppBar(
      elevation: 0.0,
      backgroundColor: Colors.transparent,
      title: Text(
        "添加RSS",
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
        FlatButton(
          child: Text(
            '确认',
          ),
          textColor: AppColors.primaryText,
          onPressed: _addRss,
        ),
      ],
    );
  }

  Widget _buildBody() {
    return Container(
      color: AppColors.primaryGreyBackground,
      child: Column(
        children: <Widget>[
          Container(
            height: duSetHeight(10),
          ),
          inputRSSURLEdit(
            controller: _urlController,
            hintText: "URL",
            marginTop: 0,
            onEditingComplete: _checkRssUrl,
            rotationTransition: RotationTransition(
              alignment: Alignment.center,
              turns: controller,
              child: IconButton(
                icon: Icon(
                  Icons.rotate_right,
                ),
                onPressed: _checkRssUrl,
              ),
            ),
          ),
          Container(
            height: duSetHeight(3),
          ),
          inputTextEdit(
            controller: _nameController,
            hintText: "名称",
            marginTop: 0,
          ),
          Container(
            height: duSetHeight(3),
          ),
          Container(
            color: AppColors.primaryWhiteBackground,
            child: SwitchListTile(
              value: _used,
              onChanged: (value) {
                setState(() {
                  _used = value;
                });
              },
              title: Text('是否启用'),
              secondary: Icon(_used ? Icons.link : Icons.link_off),
              selected: _used,
            ),
          ),
        ],
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
