// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// AutoRouteGenerator
// **************************************************************************

import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:auto_route/auto_route.dart';
import 'package:flutter_rss_reader/pages/index/index.dart';
import 'package:flutter_rss_reader/pages/welcome/welcome.dart';
import 'package:flutter_rss_reader/pages/application/application.dart';
import 'package:flutter_rss_reader/pages/main/main.dart';
import 'package:flutter_rss_reader/pages/setting/setting.dart';
import 'package:flutter_rss_reader/pages/addCate/addCate.dart';
import 'package:flutter_rss_reader/pages/cateDetail/cateDetail.dart';
import 'package:flutter_rss_reader/common/provider/app.dart';
import 'package:flutter_rss_reader/pages/addRss/addRss.dart';

abstract class Routes {
  static const indexPageRoute = '/';
  static const welcomePageRoute = '/welcome-page-route';
  static const applicationPage = '/application-page';
  static const mainPage = '/main-page';
  static const settingPage = '/setting-page';
  static const addCatePage = '/add-cate-page';
  static const cateDetail = '/cate-detail';
  static const addRss = '/add-rss';
  static const all = {
    indexPageRoute,
    welcomePageRoute,
    applicationPage,
    mainPage,
    settingPage,
    addCatePage,
    cateDetail,
    addRss,
  };
}

class AppRouter extends RouterBase {
  @override
  Set<String> get allRoutes => Routes.all;

  @Deprecated('call ExtendedNavigator.ofRouter<Router>() directly')
  static ExtendedNavigatorState get navigator =>
      ExtendedNavigator.ofRouter<AppRouter>();

  @override
  Route<dynamic> onGenerateRoute(RouteSettings settings) {
    final args = settings.arguments;
    switch (settings.name) {
      case Routes.indexPageRoute:
        if (hasInvalidArgs<IndexPageArguments>(args)) {
          return misTypedArgsRoute<IndexPageArguments>(args);
        }
        final typedArgs = args as IndexPageArguments ?? IndexPageArguments();
        return MaterialPageRoute<dynamic>(
          builder: (context) => IndexPage(key: typedArgs.key),
          settings: settings,
        );
      case Routes.welcomePageRoute:
        if (hasInvalidArgs<WelcomePageArguments>(args)) {
          return misTypedArgsRoute<WelcomePageArguments>(args);
        }
        final typedArgs =
            args as WelcomePageArguments ?? WelcomePageArguments();
        return MaterialPageRoute<dynamic>(
          builder: (context) => WelcomePage(key: typedArgs.key),
          settings: settings,
        );
      case Routes.applicationPage:
        return MaterialPageRoute<dynamic>(
          builder: (context) => ApplicationPage(),
          settings: settings,
        );
      case Routes.mainPage:
        return MaterialPageRoute<dynamic>(
          builder: (context) => MainPage(),
          settings: settings,
        );
      case Routes.settingPage:
        return MaterialPageRoute<dynamic>(
          builder: (context) => SettingPage(),
          settings: settings,
        );
      case Routes.addCatePage:
        return MaterialPageRoute<dynamic>(
          builder: (context) => AddCatePage(),
          settings: settings,
        );
      case Routes.cateDetail:
        if (hasInvalidArgs<CateDetailArguments>(args)) {
          return misTypedArgsRoute<CateDetailArguments>(args);
        }
        final typedArgs = args as CateDetailArguments ?? CateDetailArguments();
        return MaterialPageRoute<dynamic>(
          builder: (context) =>
              CateDetail(key: typedArgs.key, item: typedArgs.item),
          settings: settings,
        );
      case Routes.addRss:
        return MaterialPageRoute<dynamic>(
          builder: (context) => AddRss(),
          settings: settings,
        );
      default:
        return unknownRoutePage(settings.name);
    }
  }
}

// *************************************************************************
// Arguments holder classes
// **************************************************************************

//IndexPage arguments holder class
class IndexPageArguments {
  final Key key;
  IndexPageArguments({this.key});
}

//WelcomePage arguments holder class
class WelcomePageArguments {
  final Key key;
  WelcomePageArguments({this.key});
}

//CateDetail arguments holder class
class CateDetailArguments {
  final Key key;
  final Category item;
  CateDetailArguments({this.key, this.item});
}

// *************************************************************************
// Navigation helper methods extension
// **************************************************************************

extension AppRouterNavigationHelperMethods on ExtendedNavigatorState {
  Future pushIndexPageRoute({
    Key key,
  }) =>
      pushNamed(
        Routes.indexPageRoute,
        arguments: IndexPageArguments(key: key),
      );

  Future pushWelcomePageRoute({
    Key key,
  }) =>
      pushNamed(
        Routes.welcomePageRoute,
        arguments: WelcomePageArguments(key: key),
      );

  Future pushApplicationPage() => pushNamed(Routes.applicationPage);

  Future pushMainPage() => pushNamed(Routes.mainPage);

  Future pushSettingPage() => pushNamed(Routes.settingPage);

  Future pushAddCatePage() => pushNamed(Routes.addCatePage);

  Future pushCateDetail({
    Key key,
    Category item,
  }) =>
      pushNamed(
        Routes.cateDetail,
        arguments: CateDetailArguments(key: key, item: item),
      );

  Future pushAddRss() => pushNamed(Routes.addRss);
}
