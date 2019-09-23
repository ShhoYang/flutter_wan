import 'package:fluintl/fluintl.dart';
import 'package:flustars/flustars.dart';
import 'package:flutter/material.dart';
import 'package:flutter_wan/blocs/application_bloc.dart';
import 'package:flutter_wan/blocs/bloc_provider.dart';
import 'package:flutter_wan/common/common.dart';
import 'package:flutter_wan/common/sp_helper.dart';
import 'package:flutter_wan/models/models.dart';
import 'package:flutter_wan/res/colors.dart';
import 'package:flutter_wan/res/strings.dart';
import 'package:flutter_wan/ui/pages/language_page.dart';
import 'package:flutter_wan/utils/navigator_utils.dart';

class SettingPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    ApplicationBloc bloc = BlocProvider.of<ApplicationBloc>(context);
    LanguageModel model =
        SpHelper.getObject<LanguageModel>(Constant.keyLanguage);

    return new Scaffold(
      appBar: new AppBar(
        title: new Text(IntlUtil.getString(context, Ids.titleSetting)),
        centerTitle: true,
      ),
      body: ListView(
        children: <Widget>[
          new ExpansionTile(
            title: new Row(
              children: <Widget>[
                new Icon(
                  Icons.color_lens,
                  color: Colours.gray_66,
                ),
                Padding(
                  padding: EdgeInsets.only(left: 10.0),
                  child: Text(
                    IntlUtil.getString(context, Ids.titleTheme),
                  ),
                ),
              ],
            ),
            children: <Widget>[
              new Wrap(
                children: themeColorMap.keys.map((String key) {
                  Color value = themeColorMap[key];
                  return new InkWell(
                    onTap: () {
                      SpUtil.putString(Constant.key_theme_color, key);
                      bloc.sendAppEvent(Constant.type_sys_update);
                    },
                    child: new Container(
                      margin: EdgeInsets.all(5.0),
                      width: 36.0,
                      height: 36.0,
                      color: value,
                    ),
                  );
                }).toList(),
              ),
            ],
          ),
          new ListTile(
            title: new Row(
              children: <Widget>[
                new Icon(
                  Icons.language,
                  color: Colours.gray_66,
                ),
                new Padding(
                  padding: EdgeInsets.only(left: 10.0),
                  child: new Text(
                    IntlUtil.getString(context, Ids.titleLanguage),
                  ),
                )
              ],
            ),
            trailing: new Row(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                new Text(
                  model == null
                      ? IntlUtil.getString(context, Ids.languageAuto)
                      : IntlUtil.getString(context, model.titleId,
                          languageCode: 'zh', countryCode: 'CH'),
                ),
                new Icon(Icons.keyboard_arrow_right),
              ],
            ),
            onTap: () {
              NavigatorUtils.pushPage(context, new LanguagePage(),
                  pageName: Ids.titleLanguage);
            },
          ),
        ],
      ),
    );
  }
}
