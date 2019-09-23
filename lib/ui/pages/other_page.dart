import 'package:flutter/material.dart';
import 'package:flutter_wan/models/models.dart';
import 'package:flutter_wan/ui/widgets/com_item.dart';

class OtherPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    List<ComModel> list = <ComModel>[
      new ComModel(
          title: "WanAndroid Api",
          url: "http://www.wanandroid.com/blog/show/2"),
      new ComModel(
          title: "界面参考Gitme", url: "https://flutterchina.club/app/gm.html"),
      new ComModel(
          title: "Github Trending Api",
          url: "https://github.com/huchenme/github-trending-api")
    ];
    return new Scaffold(
      appBar: new AppBar(
        title: new Text('其它'),
        centerTitle: true,
      ),
      body: new ListView.builder(
          itemCount: list.length,
          itemBuilder: (BuildContext context, int index) {
            return new ComArrowItem(list[index]);
          }),
    );
  }
}
