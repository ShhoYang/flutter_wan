import 'package:flutter/material.dart';
import 'package:flutter_wan/common/common.dart';

class RouteUtil {
  static void goMain(BuildContext context) {
    pushReplacementNamed(context, Constant.routeMain);
  }

  static void goLogin(BuildContext context) {
    pushNamed(context, Constant.routeLogin);
  }

  static void pushNamed(BuildContext context, String pageName) {
    Navigator.of(context).pushNamed(pageName);
  }

  static void pushReplacementNamed(BuildContext context, String pageName) {
    Navigator.of(context).pushReplacementNamed(pageName);
  }
}
