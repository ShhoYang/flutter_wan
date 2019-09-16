import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_wan/data/protocol/models.dart';
import 'package:flutter_wan/res/colors.dart';
import 'package:flutter_wan/res/style.dart';
import 'package:flutter_wan/ui/widgets/widgets.dart';
import 'package:flutter_wan/utils/navigator_utils.dart';
import 'package:flutter_wan/utils/utils.dart';

class ReposItem extends StatelessWidget {
  final String labelId;
  final ReposModel model;
  final bool isHome;

  ReposItem(this.model, {Key key, this.labelId, this.isHome}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return new InkWell(
      onTap: () {
        NavigatorUtils.pushWeb(context,
            title: model.title, url: model.link, isHome: isHome);
      },
      child: new Container(
        height: 160.0,
        padding: const EdgeInsets.only(
            left: 16.0, top: 16.0, right: 16.0, bottom: 10.0),
        decoration: new BoxDecoration(
            color: Colors.white,
            border: new Border(
                bottom: new BorderSide(width: 0.33, color: Colours.divider))),
        child: new Row(
          children: <Widget>[
            new Expanded(
                child: new Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                new Text(
                  model.title,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyles.listTitle,
                ),
                Gaps.vGap10,
                new Expanded(
                    flex: 1,
                    child: new Text(
                      model.desc,
                      maxLines: 3,
                      softWrap: true,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyles.listContent,
                    )),
                Gaps.vGap5,
                new Row(
                  children: <Widget>[
                    new LikeBtn(
                      labelId: labelId,
                      id: model.originId ?? model.id,
                      isLike: model.collect,
                    ),
                    Gaps.hGap10,
                    new Text(
                      model.author,
                      style: TextStyles.listExtra,
                    ),
                    Gaps.hGap10,
                    new Text(
                      Utils.getTimeLine(context, model.publishTime),
                      style: TextStyles.listExtra,
                    ),
                  ],
                )
              ],
            )),
            new Container(
              width: 72,
              alignment: Alignment.center,
              margin: EdgeInsets.only(left: 10.0),
              child: new CachedNetworkImage(
                imageUrl: model.envelopePic,
                width: 72,
                height: 128,
                fit: BoxFit.fill,
                placeholder: (context, url) => new ProgressView(),
                errorWidget: (context, url, error) => const Icon(Icons.error),
              ),
            )
          ],
        ),
      ),
    );
  }
}
