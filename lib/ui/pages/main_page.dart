import 'package:fluintl/fluintl.dart';
import 'package:flustars/flustars.dart';
import 'package:flutter/material.dart';
import 'package:flutter_wan/res/strings.dart';
import 'package:flutter_wan/ui/pages/repos_page.dart';
import 'package:flutter_wan/ui/pages/search_page.dart';
import 'package:flutter_wan/ui/pages/system_page.dart';
import 'package:flutter_wan/utils/navigator_utils.dart';
import 'package:flutter_wan/utils/utils.dart';

import 'events_page.dart';
import 'home_page.dart';
import 'main_left_page.dart';

class MainPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new DefaultTabController(
        length: _allPage.length,
        child: new Scaffold(
          appBar: new MyAppBar(
            leading: new Container(
              decoration: new BoxDecoration(
                shape: BoxShape.circle,
                image: DecorationImage(
                  image: AssetImage(
                    Utils.getImgPath('ali_connors'),
                  ),
                ),
              ),
            ),
            centerTitle: true,
            title: new TabLayout(),
            actions: <Widget>[
              new IconButton(
                  icon: new Icon(Icons.search),
                  onPressed: () {
                    NavigatorUtils.pushPage(context, new SearchPage());
                  })
            ],
          ),
          body: new TabBarViewLayout(),
          drawer: new Drawer(
            child: new MainLeftPage(),
          ),
        ));
  }
}

class TabLayout extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new TabBar(
      isScrollable: true,
      labelPadding: const EdgeInsets.all(12.0),
      indicatorSize: TabBarIndicatorSize.label,
      tabs: _allPage.map((page) {
        return new Tab(text: IntlUtil.getString(context, page.labelId));
      }).toList(),
    );
  }
}

class TabBarViewLayout extends StatelessWidget {
  Widget _buildTabView(BuildContext context, _Page page) {
    String labelId = page.labelId;
    switch (labelId) {
      case Ids.titleHome:
        return HomePage(labelId: labelId);
        break;
      case Ids.titleRepos:
        return ReposPage(labelId: labelId);
        break;
      case Ids.titleEvents:
        return EventsPage(labelId: labelId);
        break;
      case Ids.titleSystem:
        return SystemPage(labelId: labelId);
        break;
      default:
        return Container();
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return new TabBarView(
        children: _allPage.map((page) {
      return _buildTabView(context, page);
    }).toList());
  }
}

class _Page {
  final String labelId;

  _Page(this.labelId);
}

final List<_Page> _allPage = <_Page>[
  new _Page(Ids.titleHome),
  new _Page(Ids.titleRepos),
  new _Page(Ids.titleEvents),
  new _Page(Ids.titleSystem),
];
