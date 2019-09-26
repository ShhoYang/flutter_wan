import 'package:flustars/flustars.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_wan/blocs/bloc_provider.dart';
import 'package:flutter_wan/blocs/tab_bloc.dart';
import 'package:flutter_wan/data/protocol/models.dart';
import 'package:flutter_wan/ui/pages/tab_page.dart';
import 'package:flutter_wan/ui/pages/user/user_login_page.dart';
import 'package:flutter_wan/ui/widgets/web_scaffold.dart';
import 'package:url_launcher/url_launcher.dart';

import 'utils.dart';

class NavigatorUtils {
  static void pushPage(
    BuildContext context,
    Widget page, {
    String pageName,
    bool needLogin = false,
  }) {
    if (context == null || page == null) {
      return;
    }

    if (needLogin && !Utils.isLogin()) {
      pushPage(context, new UserLoginPage());
      return;
    }

    Navigator.push(
        context, new CupertinoPageRoute<void>(builder: (context) => page));
  }

  static void pushWeb(BuildContext context,
      {String title, String titleId, String url, bool isHome: false}) {
    if (context == null || ObjectUtil.isEmpty(url)) {
      return;
    }
    if (url.endsWith('.apk')) {
      launchInBrowser(url, title: title ?? titleId);
    } else {
      Navigator.push(
        context,
        new CupertinoPageRoute(
          builder: (ctx) => new WebScaffold(
            title: title,
            titleId: titleId,
            url: url,
          ),
        ),
      );
    }
  }

  static void pushTabPage(BuildContext context,
      {String labelId, String title, String titleId, TreeModel treeModel}) {
    if (context == null) {
      return;
    }
    Navigator.push(
      context,
      new CupertinoPageRoute<void>(
        builder: (ctx) => new BlocProvider<TabBloc>(
          bloc: new TabBloc(),
          child: new TabPage(
            labelId: labelId,
            title: title,
            titleId: titleId,
            treeModel: treeModel,
          ),
        ),
      ),
    );
  }

  static Future<Null> launchInBrowser(String url, {String title}) async {
    if (await canLaunch(url)) {
      await launch(url, forceSafariVC: false, forceWebView: false);
    } else {
      throw 'Could not launch $url';
    }
  }
}
