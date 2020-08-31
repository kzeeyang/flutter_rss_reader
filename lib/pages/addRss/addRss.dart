import 'package:flutter/material.dart';
import 'package:flutter_rss_reader/common/apis/api.dart';
import 'package:flutter_rss_reader/common/utils/utils.dart';
import 'package:flutter_rss_reader/common/values/values.dart';
import 'package:flutter_rss_reader/common/widgets/widgets.dart';
import 'package:dart_rss/dart_rss.dart';
import 'package:http/http.dart' as http;

class AddRss extends StatefulWidget {
  @override
  _AddRssState createState() => _AddRssState();
}

class _AddRssState extends State<AddRss> {
  // 控制器
  final TextEditingController _urlController = TextEditingController();
  TextEditingController _nameController = TextEditingController();
  bool _used = true;

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
          onPressed: () {},
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
            onEditingComplete: () async {
              print(_urlController.value.text);
              RssFeed channel = await Rss.testConn(
                _urlController.value.text,
                context: context,
                cacheDisk: true,
              );
              _nameController = TextEditingController(text: channel.title);
            },
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
