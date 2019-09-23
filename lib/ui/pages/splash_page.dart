import 'package:cached_network_image/cached_network_image.dart';
import 'package:fluintl/fluintl.dart';
import 'package:flukit/flukit.dart';
import 'package:flustars/flustars.dart';
import 'package:flutter/material.dart';
import 'package:flutter_wan/common/common.dart';
import 'package:flutter_wan/common/sp_helper.dart';
import 'package:flutter_wan/models/models.dart';
import 'package:flutter_wan/res/colors.dart';
import 'package:flutter_wan/res/strings.dart';
import 'package:flutter_wan/utils/http_utils.dart';
import 'package:flutter_wan/utils/navigator_utils.dart';
import 'package:flutter_wan/utils/route_util.dart';
import 'package:flutter_wan/utils/utils.dart';
import 'package:rxdart/rxdart.dart';

class SplashPage extends StatefulWidget {
  @override
  _SplashPageState createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  TimerUtil _timerUtil;

  List<String> _guideList = [
    Utils.getImgPath('guide1'),
    Utils.getImgPath('guide2'),
    Utils.getImgPath('guide3'),
    Utils.getImgPath('guide4'),
  ];

  List<Widget> _bannerList = <Widget>[];

  int _status = 0;
  int _count = 3;

  SplashModel _splashModel;

  @override
  void initState() {
    super.initState();
    _initAsync();
  }

  @override
  void dispose() {
    super.dispose();
    _timerUtil?.cancel();
  }

  @override
  Widget build(BuildContext context) {
    return new Material(
      child: new Stack(
        children: <Widget>[
          new Offstage(
            offstage: !(_status == 0),
            child: _buildSplashBg(),
          ),
          new Offstage(
            offstage: !(_status == 2),
            child: ObjectUtil.isEmpty(_bannerList)
                ? new Container()
                : new Swiper(
                    autoStart: false,
                    circular: false,
                    indicator: new CircleSwiperIndicator(
                      radius: 4.0,
                      padding: const EdgeInsets.only(bottom: 30.0),
                      itemColor: Colors.black26,
                    ),
                    children: _bannerList,
                  ),
          ),
          _buildAdWidget(),
          new Offstage(
            offstage: !(_status == 1),
            child: new Container(
              alignment: Alignment.bottomRight,
              margin: const EdgeInsets.all(20.0),
              child: InkWell(
                onTap: () {
                  _goMain();
                },
                child: new Container(
                  padding: const EdgeInsets.all(12.0),
                  child: new Text(
                    IntlUtil.getString(context, Ids.jump_count,
                        params: ['$_count']),
                    style: new TextStyle(fontSize: 14.0, color: Colors.white),
                  ),
                  decoration: new BoxDecoration(
                    color: Color(0x66000000),
                    borderRadius: BorderRadius.all(Radius.circular(4.0)),
                    border: new Border.all(width: 0.33, color: Colours.divider),
                  ),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }

  void _initAsync() async {
    await SpUtil.getInstance();
    _loadSplashData();
    Observable.just(1).delay(new Duration(milliseconds: 1)).listen((_) {
//      SpUtil.putBool(Constant.key_guide, false);
      if (SpUtil.getBool(Constant.key_guide, defValue: true) &&
          ObjectUtil.isNotEmpty(_guideList)) {
        SpUtil.putBool(Constant.key_guide, false);
        _initBanner();
      } else {
        _initSplash();
      }
    });
  }

  void _loadSplashData() {
    _splashModel = SpHelper.getObject<SplashModel>(Constant.key_splash_model);
    if (_splashModel != null) {
      setState(() {});
    }

    HttpUtils httpUtils = new HttpUtils();
    httpUtils.getSplash().then((model) {
      if (ObjectUtil.isNotEmpty(model?.imgUrl)) {
        if (_splashModel == null || _splashModel.imgUrl != model.imgUrl) {
          SpHelper.putObject(Constant.key_splash_model, model);
          setState(() {
            _splashModel = model;
          });
        } else {
          SpHelper.putObject(Constant.key_splash_model, null);
        }
      }
    });
  }

  void _initBanner() {
    _initBannerData();
    setState(() {
      _status = 2;
    });
  }

  void _initBannerData() {
    for (int i = 0, length = _guideList.length; i < length; i++) {
      if (i == length - 1) {
        _bannerList.add(new Stack(
          children: <Widget>[
            new Image.asset(
              _guideList[i],
              fit: BoxFit.fill,
              width: double.infinity,
              height: double.infinity,
            ),
            new Align(
              alignment: Alignment.bottomCenter,
              child: new Container(
                margin: const EdgeInsets.only(bottom: 16.0),
                child: new InkWell(
                  onTap: () {
                    _goMain();
                  },
                  child: new CircleAvatar(
                    radius: 48.0,
                    backgroundColor: Colors.indigoAccent,
                    child: new Padding(
                      padding: const EdgeInsets.all(2.0),
                      child: new Text(
                        '立即体验',
                        textAlign: TextAlign.center,
                        style: new TextStyle(
                          color: Colors.white,
                          fontSize: 16.0,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            )
          ],
        ));
      } else {
        _bannerList.add(
          new Image.asset(
            _guideList[i],
            fit: BoxFit.fill,
            width: double.infinity,
            height: double.infinity,
          ),
        );
      }
    }
  }

  void _initSplash() {
    if (_splashModel == null) {
      _goMain();
    } else {
      _doCountDown();
    }
  }

  void _doCountDown() {
    setState(() {
      _status = 1;
    });
    _timerUtil = new TimerUtil(mTotalTime: 3000);
    _timerUtil.setOnTimerTickCallback((int tick) {
      double _tick = tick / 1000;
      setState(() {
        _count = _tick.toInt();
      });
      if (_tick == 0) {
        _goMain();
      }
    });
    _timerUtil.startCountDown();
  }

  void _goMain() {
    RouteUtil.goMain(context);
  }

  Widget _buildSplashBg() {
    return new Image.asset(
      Utils.getImgPath('splash_bg'),
      fit: BoxFit.fill,
      width: double.infinity,
      height: double.infinity,
    );
  }

  Widget _buildAdWidget() {
    if (_splashModel == null) {
      return new Container(
        height: 0.0,
      );
    }

    return new Offstage(
      offstage: !(_status == 1),
      child: new InkWell(
        onTap: () {
          if (ObjectUtil.isEmpty(_splashModel.url)) {
            return;
          }
          _goMain();
          NavigatorUtils.pushWeb(context,
              title: _splashModel.title, url: _splashModel.url);
        },
        child: new Container(
          alignment: Alignment.center,
          child: new CachedNetworkImage(
            imageUrl: _splashModel.imgUrl,
            fit: BoxFit.fill,
            width: double.infinity,
            height: double.infinity,

            errorWidget: (context, url, error) => _buildSplashBg(),
          ),
        ),
      ),
    );
  }
}
