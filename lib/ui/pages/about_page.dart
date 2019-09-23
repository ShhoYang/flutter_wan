import 'package:fluintl/fluintl.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_wan/blocs/bloc_provider.dart';
import 'package:flutter_wan/blocs/main_bloc.dart';
import 'package:flutter_wan/common/common.dart';
import 'package:flutter_wan/models/models.dart';
import 'package:flutter_wan/res/colors.dart';
import 'package:flutter_wan/res/strings.dart';
import 'package:flutter_wan/res/style.dart';
import 'package:flutter_wan/ui/pages/author_page.dart';
import 'package:flutter_wan/ui/pages/other_page.dart';
import 'package:flutter_wan/ui/widgets/com_item.dart';
import 'package:flutter_wan/utils/navigator_utils.dart';
import 'package:flutter_wan/utils/utils.dart';

class AboutPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    MainBloc bloc = BlocProvider.of<MainBloc>(context);
    ComModel github = new ComModel(
        title: 'Github',
        url: 'https://github.com/Sky24n/flutter_wanandroid',
        extra: 'Go Star');
    ComModel author = new ComModel(title: '作者', page: new AuthorPage());
    ComModel other = new ComModel(title: 'Big Thanks', page: new OtherPage());
    return new Scaffold(
      appBar: new AppBar(
        title: new Text(IntlUtil.getString(context, Ids.titleAbout)),
        centerTitle: true,
      ),
      body: new ListView(
        children: <Widget>[
          new Container(
            height: 160.0,
            alignment: Alignment.center,
            child: new Column(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                new Card(
                  color: Theme.of(context).primaryColor,
                  elevation: 0.0,
                  shape: new RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(6.0)),
                  ),
                  child: new Image.asset(
                    Utils.getImgPath('ic_launcher_news'),
                    fit: BoxFit.fill,
                    width: 72.0,
                    height: 72.0,
                  ),
                ),
                Gaps.vGap5,
                new Text(
                  '版本号' + AppConfig.version,
                  style: new TextStyle(color: Colours.gray_99, fontSize: 14.0),
                )
              ],
            ),
            decoration: new BoxDecoration(
              color: Colors.white,
              border: new Border.all(width: 0.33, color: Colours.divider),
            ),
          ),
          new ComArrowItem(github),
          new ComArrowItem(author),
          new StreamBuilder(
              stream: bloc.versionStream,
              builder:
                  (BuildContext context, AsyncSnapshot<VersionModel> snapshot) {
                VersionModel model = snapshot.data;
                return new Container(
                  child: new Material(
                    color: Colors.white,
                    child: new ListTile(
                      onTap: () {
                        if (model == null) {
                          bloc.getVersion();
                        } else {
                          if (Utils.getUpdateStatus(model.version) != 0) {
                            NavigatorUtils.launchInBrowser(model.url,
                                title: model.title);
                          }
                        }
                      },
                      title: new Text('版本'),
                      trailing: new Row(
                        mainAxisSize: MainAxisSize.min,
                        children: <Widget>[
                          new Text(
                            model == null
                                ? ''
                                : (Utils.getUpdateStatus(model.version) == 0
                                    ? '已是最新版'
                                    : '有新版本，去更新'),
                            style: new TextStyle(
                              color: (model != null &&
                                      Utils.getUpdateStatus(model.version) != 0)
                                  ? Colors.red
                                  : Colors.grey,
                              fontSize: 14.0,
                            ),
                          ),
                          new Icon(
                            Icons.navigate_next,
                            color: Colors.grey,
                          )
                        ],
                      ),
                    ),
                  ),
                  decoration: Decorations.bottom,
                );
              }),
          new ComArrowItem(other),
        ],
      ),
    );
  }
}
