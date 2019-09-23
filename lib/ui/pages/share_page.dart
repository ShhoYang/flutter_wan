import 'package:fluintl/fluintl.dart';
import 'package:flustars/flustars.dart';
import 'package:flutter/material.dart';
import 'package:flutter_wan/res/strings.dart';
import 'package:flutter_wan/res/style.dart';
import 'package:flutter_wan/utils/utils.dart';

class SharePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      backgroundColor: Theme.of(context).primaryColor,
      appBar: new AppBar(
        title: new Text(IntlUtil.getString(context, Ids.titleShare)),
        centerTitle: true,
        elevation: 0.0,
      ),
      body: new Container(
        alignment: Alignment.center,
        child: new Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            new Text(
              '扫描下载',
              style: TextStyle(color: Colors.white, fontSize: 16.0),
            ),
            Gaps.vGap10,
            new Card(
              child: new Container(
                alignment: Alignment.center,
                width: ScreenUtil.getInstance().getWidth(300),
                height: ScreenUtil.getInstance().getWidth(300),
                child: new Image.asset(
                  Utils.getImgPath('qrcode'),
                  width: ScreenUtil.getInstance().getWidth(200),
                  height: ScreenUtil.getInstance().getWidth(200),
                  fit: BoxFit.fill,
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
