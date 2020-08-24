import 'package:auto_route/auto_route_annotations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rss_reader/pages/application/application.dart';
import 'package:flutter_rss_reader/pages/index/index.dart';
import 'package:flutter_rss_reader/pages/main/main.dart';
import 'package:flutter_rss_reader/pages/setting/setting.dart';
import 'package:flutter_rss_reader/pages/welcome/welcome.dart';

Widget zoomInTransition(BuildContext context, Animation<double> animation,
    Animation<double> secondaryAnimation, Widget child) {
  // you get an animation object and a widget
  // make your own transition
  return ScaleTransition(scale: animation, child: child);
}

@MaterialAutoRouter(generateNavigationHelperExtension: true)
class $AppRouter {
  @initial
  IndexPage indexPageRoute;

  WelcomePage welcomePageRoute;

  ApplicationPage applicationPage;

  MainPage mainPage;

  SettingPage settingPage;

  // @CustomRoute(transitionsBuilder: zoomInTransition)
  // DetailsPage detailsPageRoute;
}
