import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_wan/models/models.dart';
import 'package:flutter_wan/res/style.dart';
import 'package:flutter_wan/utils/navigator_utils.dart';

class ComArrowItem extends StatelessWidget {
  final ComModel model;

  const ComArrowItem(this.model, {Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: new Material(
        color: Colors.white,
        child: new ListTile(
          onTap: () {
            if (model.page == null) {
              NavigatorUtils.pushWeb(context,
                  title: model.title, url: model.url, isHome: true);
            } else {
              NavigatorUtils.pushPage(context, model.page,
                  pageName: model.title);
            }
          },
          title: new Text(model.title == null ? '' : model.title),
          trailing: new Row(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              new Text(
                model.extra == null ? '' : model.extra,
                style: TextStyle(color: Colors.grey, fontSize: 14.0),
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
  }
}
