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
import 'package:flutter_rss_reader/pages/addRss/addRss.dart';
import 'package:flutter_rss_reader/pages/photo/photo.dart';

abstract class Routes {
  static const indexPageRoute = '/';
  static const welcomePageRoute = '/welcome-page-route';
  static const applicationPage = '/application-page';
  static const mainPage = '/main-page';
  static const settingPage = '/setting-page';
  static const addCatePage = '/add-cate-page';
  static const cateDetail = '/cate-detail';
  static const addRss = '/add-rss';
  static const photoViewScreen = '/photo-view-screen';
  static const all = {
    indexPageRoute,
    welcomePageRoute,
    applicationPage,
    mainPage,
    settingPage,
    addCatePage,
    cateDetail,
    addRss,
    photoViewScreen,
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
              CateDetail(key: typedArgs.key, cateName: typedArgs.cateName),
          settings: settings,
        );
      case Routes.addRss:
        if (hasInvalidArgs<AddRssArguments>(args)) {
          return misTypedArgsRoute<AddRssArguments>(args);
        }
        final typedArgs = args as AddRssArguments ?? AddRssArguments();
        return MaterialPageRoute<dynamic>(
          builder: (context) =>
              AddRss(key: typedArgs.key, cateName: typedArgs.cateName),
          settings: settings,
        );
      case Routes.photoViewScreen:
        if (hasInvalidArgs<PhotoViewScreenArguments>(args)) {
          return misTypedArgsRoute<PhotoViewScreenArguments>(args);
        }
        final typedArgs =
            args as PhotoViewScreenArguments ?? PhotoViewScreenArguments();
        return MaterialPageRoute<dynamic>(
          builder: (context) => PhotoViewScreen(
              imageProvider: typedArgs.imageProvider,
              loadingChild: typedArgs.loadingChild,
              backgroundDecoration: typedArgs.backgroundDecoration,
              minScale: typedArgs.minScale,
              maxScale: typedArgs.maxScale,
              heroTag: typedArgs.heroTag),
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
  final String cateName;
  CateDetailArguments({this.key, this.cateName});
}

//AddRss arguments holder class
class AddRssArguments {
  final Key key;
  final String cateName;
  AddRssArguments({this.key, this.cateName});
}

//PhotoViewScreen arguments holder class
class PhotoViewScreenArguments {
  final ImageProvider<dynamic> imageProvider;
  final Widget loadingChild;
  final Decoration backgroundDecoration;
  final dynamic minScale;
  final dynamic maxScale;
  final String heroTag;
  PhotoViewScreenArguments(
      {this.imageProvider,
      this.loadingChild,
      this.backgroundDecoration,
      this.minScale,
      this.maxScale,
      this.heroTag});
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
    String cateName,
  }) =>
      pushNamed(
        Routes.cateDetail,
        arguments: CateDetailArguments(key: key, cateName: cateName),
      );

  Future pushAddRss({
    Key key,
    String cateName,
  }) =>
      pushNamed(
        Routes.addRss,
        arguments: AddRssArguments(key: key, cateName: cateName),
      );

  Future pushPhotoViewScreen({
    ImageProvider<dynamic> imageProvider,
    Widget loadingChild,
    Decoration backgroundDecoration,
    dynamic minScale,
    dynamic maxScale,
    String heroTag,
  }) =>
      pushNamed(
        Routes.photoViewScreen,
        arguments: PhotoViewScreenArguments(
            imageProvider: imageProvider,
            loadingChild: loadingChild,
            backgroundDecoration: backgroundDecoration,
            minScale: minScale,
            maxScale: maxScale,
            heroTag: heroTag),
      );
}
