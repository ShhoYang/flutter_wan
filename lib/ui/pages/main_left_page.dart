import 'package:fluintl/fluintl.dart';
import 'package:flustars/flustars.dart';
import 'package:flutter/material.dart';
import 'package:flutter_wan/blocs/bloc_provider.dart';
import 'package:flutter_wan/blocs/collect_bloc.dart';
import 'package:flutter_wan/common/common.dart';
import 'package:flutter_wan/common/sp_helper.dart';
import 'package:flutter_wan/data/protocol/models.dart';
import 'package:flutter_wan/event/event.dart';
import 'package:flutter_wan/res/strings.dart';
import 'package:flutter_wan/res/style.dart';
import 'package:flutter_wan/ui/pages/about_page.dart';
import 'package:flutter_wan/ui/pages/collection_page.dart';
import 'package:flutter_wan/ui/pages/setting_page.dart';
import 'package:flutter_wan/ui/pages/share_page.dart';
import 'package:flutter_wan/utils/navigator_utils.dart';
import 'package:flutter_wan/utils/utils.dart';

class MainLeftPage extends StatefulWidget {
  @override
  _MainLeftPageState createState() => _MainLeftPageState();
}

class _MainLeftPageState extends State<MainLeftPage> {
  List<PageInfo> _pageInfo = <PageInfo>[];
  PageInfo loginOut =
      PageInfo(Ids.titleSignOut, Icons.power_settings_new, null);
  String _userName;

  @override
  void initState() {
    super.initState();
    _pageInfo.add(PageInfo(
        Ids.titleCollection,
        Icons.collections,
        new CollectionPage(
          labelId: Ids.titleCollection,
        )));
    _pageInfo
        .add(PageInfo(Ids.titleSetting, Icons.settings, new SettingPage()));
    _pageInfo.add(PageInfo(Ids.titleAbout, Icons.info, new AboutPage()));
    _pageInfo.add(PageInfo(Ids.titleShare, Icons.share, new SharePage()));
  }

  void _showLoginOutDialog(BuildContext context) {
    showDialog(
        context: context,
        builder: (ctx) {
          return AlertDialog(
            content: Text('确定退出吗?'),
            actions: <Widget>[
              FlatButton(
                child: new Text(
                  IntlUtil.getString(ctx, Ids.cancel),
                  style: TextStyles.listExtra2,
                ),
                onPressed: () {
                  Navigator.pop(ctx);
                },
              ),
              FlatButton(
                child: Text(
                  IntlUtil.getString(ctx, Ids.confirm),
                  style: TextStyles.listExtra2,
                ),
                onPressed: () {
                  SpUtil.remove(Constant.keyAppToken);
                  Event.sendAppEvent(ctx, Constant.type_sys_update);
                  Navigator.pop(ctx);
                  Navigator.pop(context);
                },
              ),
            ],
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    if (Utils.isLogin()) {
      if (!_pageInfo.contains(loginOut)) {
        _pageInfo.add(loginOut);
        UserModel userModel =
            SpHelper.getObject<UserModel>(Constant.keyUserModel);
        _userName = userModel?.username ?? '';
      }
    } else {
      _userName = 'Sky24n';
      if (_pageInfo.contains(loginOut)) {
        _pageInfo.remove(loginOut);
      }
    }
    return new Scaffold(
      body: new Column(
        children: <Widget>[
          new Container(
            height: 165.0,
            color: Theme.of(context).primaryColor,
            padding: EdgeInsets.only(
              top: ScreenUtil.getInstance().statusBarHeight,
              left: 10.0,
            ),
            child: new Stack(
              children: <Widget>[
                new Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    new Container(
                      width: 64.0,
                      height: 64.0,
                      margin: EdgeInsets.only(left: 10.0, bottom: 10.0),
                      decoration: new BoxDecoration(
                        shape: BoxShape.circle,
                        image: DecorationImage(
                          image: AssetImage(
                            Utils.getImgPath('ali_connors'),
                          ),
                        ),
                      ),
                    ),
                    new Text(
                      _userName,
                      style: new TextStyle(
                          color: Colors.white,
                          fontSize: 16.0,
                          fontWeight: FontWeight.bold),
                    ),
                    Gaps.hGap5,
                    new Text(
                      '个人简介',
                      style: new TextStyle(color: Colors.white, fontSize: 12.0),
                    ),
                  ],
                ),
                new Align(
                  alignment: Alignment.topRight,
                  child: new IconButton(
                      icon: Icon(
                        Icons.edit,
                        color: Colors.white,
                      ),
                      onPressed: () {}),
                )
              ],
            ),
          ),
          new Container(
            height: 50.0,
            child: new Material(
              color: Colors.grey[200],
              child: new InkWell(
                onTap: () {
                  //todo
                },
                child: new Center(
                  child: new Text(
                    'Flutter Demo',
                    style: TextStyle(
                      color: Theme.of(context).primaryColor,
                      fontSize: 16.0,
                    ),
                  ),
                ),
              ),
            ),
          ),
          new Expanded(
              child: new ListView.builder(
                  padding: EdgeInsets.all(0.0),
                  itemCount: _pageInfo.length,
                  itemBuilder: (BuildContext context, int index) {
                    PageInfo pageInfo = _pageInfo[index];
                    return new ListTile(
                      leading: new Icon(pageInfo.iconData),
                      title: Text(
                        IntlUtil.getString(
                          context,
                          pageInfo.titleId,
                        ),
                      ),
                      onTap: () {
                        if (pageInfo.titleId == Ids.titleSignOut) {
                          _showLoginOutDialog(context);
                        } else if (pageInfo.titleId == Ids.titleCollection) {
                          NavigatorUtils.pushPage(
                            context,
                            BlocProvider<CollectBloc>(
                              child: pageInfo.page,
                              bloc: CollectBloc(),
                            ),
                            pageName: pageInfo.titleId,
                            needLogin: Utils.isNeedLogin(pageInfo.titleId),
                          );
                        } else {
                          NavigatorUtils.pushPage(
                            context,
                            pageInfo.page,
                            pageName: pageInfo.titleId,
                            needLogin: Utils.isNeedLogin(pageInfo.titleId),
                          );
                        }
                      },
                    );
                  })),
        ],
      ),
    );
  }
}

class PageInfo {
  String titleId;
  IconData iconData;
  Widget page;
  bool withScaffold;

  PageInfo(this.titleId, this.iconData, this.page, [this.withScaffold = true]);
}
