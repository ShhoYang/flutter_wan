import 'package:flutter/material.dart';
import 'package:flutter_wan/blocs/bloc_provider.dart';
import 'package:flutter_wan/blocs/main_bloc.dart';
import 'package:flutter_wan/common/common.dart';
import 'package:flutter_wan/res/colors.dart';
import 'package:flutter_wan/res/style.dart';
import 'package:flutter_wan/utils/utils.dart';

class ProgressView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new Center(
      child: new SizedBox(
        width: 24.0,
        height: 24.0,
        child: new CircularProgressIndicator(
          strokeWidth: 2.0,
        ),
      ),
    );
  }
}

class LikeBtn extends StatelessWidget {
  final String labelId;
  final int id;
  final bool isLike;

  const LikeBtn({Key key, this.labelId, this.id, this.isLike})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final MainBloc bloc = BlocProvider.of<MainBloc>(context);
    return new InkWell(
      onTap: () {
        if (Utils.isLogin()) {
          bloc.doCollection(labelId, id, !isLike);
        } else {
          // todo
        }
      },
      child: new Icon(
        Icons.favorite,
        color: (isLike == true && Utils.isLogin())
            ? Colors.redAccent
            : Colours.gray_99,
      ),
    );
  }
}

class StatusViews extends StatelessWidget {
  final int status;
  final GestureTapCallback onTap;

  const StatusViews(this.status, {Key key, this.onTap}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    switch (status) {
      case LoadStatus.fail:
        return new Container(
          width: double.infinity,
          child: new Material(
            color: Colors.white,
            child: new InkWell(
              onTap: () {
                onTap();
              },
              child: new Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  new Image.asset(
                    Utils.getImgPath('ic_network_error'),
                    width: 100,
                    height: 100,
                  ),
                  Gaps.vGap10,
                  new Text('网络出问题了~', style: TextStyles.listContent),
                  Gaps.vGap5,
                  new Text(
                    '重新加载',
                    style: TextStyles.listContent,
                  ),
                ],
              ),
            ),
          ),
        );
        break;
      case LoadStatus.loading:
        return new Container(
          alignment: Alignment.center,
          color: Colours.gray_f0,
          child: new ProgressView(),
        );
        break;
      case LoadStatus.empty:
        return new Container(
          color: Colors.white,
          width: double.infinity,
          child: new Center(
            child: new Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                new Image.asset(
                  Utils.getImgPath('ic_data_empty'),
                  width: 60,
                  height: 60,
                ),
                Gaps.vGap10,
                new Text(
                  '空空如也~',
                  style: TextStyles.listContent2,
                ),
              ],
            ),
          ),
        );
        break;
      default:
        return new Container();
        break;
    }
  }
}
