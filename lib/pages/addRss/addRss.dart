import 'package:flutter/material.dart';
import 'package:flutter_rss_reader/common/apis/api.dart';
import 'package:flutter_rss_reader/common/provider/provider.dart';
import 'package:flutter_rss_reader/common/utils/utils.dart';
import 'package:flutter_rss_reader/common/values/values.dart';
import 'package:flutter_rss_reader/common/widgets/widgets.dart';
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
  String _iconUrl = "";

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

    controller.reset();
    _nameController.text = null;
    controller.forward();
    var rssEntity = await Rss.getRss(
      _urlController.value.text,
      context: context,
      cacheDisk: true,
      getRssSetting: true,
    );
    _nameController.text = rssEntity.rssSetting.rssName;
    _iconUrl = rssEntity.rssSetting.iconUrl;
    // debugPrint('iconUrl: $_iconUrl');
    if (Global.appState.rssIndex(
            widget.cateName, _urlController.text, _nameController.text) !=
        -1) {
      toastInfo(msg: 'RSS链接已存在当前分类');
      return;
    }
  }

  _addRss() {
    if (!duIsURL(_urlController.text)) {
      toastInfo(msg: '请输入正确的RSS链接');
      return;
    }
    if (_nameController.text.isEmpty) {
      toastInfo(msg: '请输入RSS名称');
      return;
    }
    _rssSetting = RssSetting(
      url: _urlController.value.text,
      rssName: _nameController.value.text,
      iconUrl: _iconUrl,
      opened: _used,
    );
    Global.appState.addRss(widget.cateName, _rssSetting);
    // Global.saveAppState();
    Navigator.pop(context);
  }

  AppBar _buildAppBar() {
    return MyAppBar(
      title: "添加RSS",
      leading: TransparentIconButton(
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
            height: 10,
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
            height: 3,
          ),
          inputTextEdit(
            controller: _nameController,
            hintText: "名称",
            marginTop: 0,
          ),
          Container(
            height: 3,
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
