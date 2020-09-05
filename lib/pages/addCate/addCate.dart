import 'package:flutter/material.dart';
import 'package:flutter_rss_reader/common/provider/provider.dart';
import 'package:flutter_rss_reader/common/utils/utils.dart';
import 'package:flutter_rss_reader/common/values/values.dart';
import 'package:flutter_rss_reader/common/widgets/widgets.dart';
import 'package:flutter_rss_reader/global.dart';

class AddCatePage extends StatefulWidget {
  @override
  _AddCatePageState createState() => _AddCatePageState();
}

class _AddCatePageState extends State<AddCatePage> {
  // 控制器
  final TextEditingController _cateController = TextEditingController();

  _addHandler() {
    if (!duCheckStringEmpty(_cateController.value.text)) {
      toastInfo(msg: '请输入分类名称');
      return;
    }
    String category = _cateController.value.text;
    Global.appState.categories[category] = [];
    Global.saveAppState();
    Navigator.pop(context);
  }

  AppBar _buildAppBar() {
    return AppBar(
      elevation: 0.0,
      backgroundColor: Colors.transparent,
      title: Text(
        '添加分类',
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
          onPressed: _addHandler,
          textColor: AppColors.primaryText,
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
          inputTextEdit(
            controller: _cateController,
            hintText: "名称",
            marginTop: 0,
            // autofocus: true,
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
