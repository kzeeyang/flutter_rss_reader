import 'package:flutter/material.dart';
import 'package:flutter_rss_reader/common/provider/provider.dart';
import 'package:flutter_rss_reader/common/utils/utils.dart';
import 'package:flutter_rss_reader/common/values/values.dart';
import 'package:flutter_rss_reader/common/widgets/widgets.dart';
import 'package:flutter_rss_reader/global.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';

class AddCatePage extends StatefulWidget {
  @override
  _AddCatePageState createState() => _AddCatePageState();
}

class _AddCatePageState extends State<AddCatePage> {
  // 控制器
  final TextEditingController _cateController = TextEditingController();
  final TextEditingController _iconController = TextEditingController();

  bool _searchIconController = false;
  final IconUtil iconUtil = IconUtil.getInstance();
  List<String> iconNameList;

  IconData iconDataController = Icons.home;
  String iconName = "home";

  @override
  initState() {
    super.initState();
    iconNameList = iconUtil.iconNames;
  }

  _addHandler() {
    if (!duCheckStringEmpty(_cateController.value.text)) {
      toastInfo(msg: '请输入分类名称');
      return;
    }

    String catename = _cateController.value.text;
    if (Global.appState.hadCategory(catename)) {
      toastInfo(msg: '已存在相同名称');
      return;
    }
    Global.appState.addCategory(catename, iconName);
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
    final size = MediaQuery.of(context).size;
    final width = size.width;
    return Column(
      children: [
        inputTextEditWithIconButton(
          controller: _searchIconController ? _iconController : _cateController,
          hintText: _searchIconController ? "搜索图标名称" : "输入分类名称",
          marginTop: 0,
          width: width,
          iconButton: IconButton(
            icon: Icon(
              iconDataController,
              size: duSetFontSize(26),
            ),
            onPressed: () {},
          ),
          rotationTransition: IconButton(
            icon: _searchIconController
                ? Icon(Icons.keyboard_arrow_right)
                : Icon(Icons.search),
            onPressed: () {
              setState(() {
                _searchIconController = !_searchIconController;
              });
            },
          ),
          onChanged: (value) {
            if (_searchIconController) {
              setState(() {
                iconNameList = iconUtil.searchIcons(value);
              });
            }
          },
          // autofocus: true,
        ),
        Divider(
          height: 1,
          color: AppColors.primaryGreyBackground,
        ),
        Expanded(
          child: Container(
            alignment: Alignment.center,
            child: _iconListWidget(),
          ),
        ),
      ],
    );
  }

  Widget _iconListWidget() {
    final size = MediaQuery.of(context).size;
    final width = size.width;
    return AnimationLimiter(
      child: GridView.builder(
        itemCount: iconNameList.length,
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          //横轴元素个数
          crossAxisCount: 5,
          //纵轴间距
          mainAxisSpacing: 1,
          //横轴间距
          crossAxisSpacing: 1,
          //子组件宽高长度比例
          childAspectRatio: 1,
        ),
        itemBuilder: (context, index) {
          String name = iconNameList[index];
          IconData iconData = iconUtil.getIconDataForList(name);
          return AnimationConfiguration.staggeredGrid(
            columnCount: iconNameList.length,
            position: index,
            duration: const Duration(milliseconds: 375),
            child: SlideAnimation(
              verticalOffset: 50.0,
              child: FadeInAnimation(
                child: IconContainer(
                  width: width / 5,
                  iconBtn: IconButton(
                    icon: Icon(
                      iconData,
                      size: duSetFontSize(20),
                    ),
                    onPressed: () {
                      setState(() {
                        iconName = name;
                        iconDataController = iconData;
                      });
                    },
                  ),
                  textWgt: Text(
                    iconNameList[index],
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ),
            ),
          );
        },
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
