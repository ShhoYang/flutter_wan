import 'package:dio/dio.dart';
import 'package:auto_size/auto_size.dart';
import 'package:fluintl/fluintl.dart';
import 'package:flustars/flustars.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

import 'blocs/application_bloc.dart';
import 'blocs/bloc_provider.dart';
import 'blocs/main_bloc.dart';
import 'common/common.dart';
import 'common/sp_helper.dart';
import 'data/net/dio_util.dart';
import 'models/models.dart';
import 'res/colors.dart';
import 'res/strings.dart';
import 'ui/pages/main_page.dart';
import 'ui/pages/splash_page.dart';

void main() => runAutoSizeApp(new BlocProvider<ApplicationBloc>(
    bloc: new ApplicationBloc(),
    child: new BlocProvider(
      child: new MyApp(),
      bloc: new MainBloc(),
    )));

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  Locale _locale;
  Color _themeColor = Colours.app_main;

  @override
  void initState() {
    super.initState();
    setLocalizedValues(localizedValues);
    _initAsync();
    _initListener();
  }

  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      routes: {
        Constant.routeMain: (ctx) => new MainPage(),
      },
      home: new SplashPage(),
      theme: ThemeData.light().copyWith(
        primaryColor: _themeColor,
        accentColor: _themeColor,
        indicatorColor: Colors.white,
      ),
      locale: _locale,
      localizationsDelegates: [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        CustomLocalizations.delegate,
      ],
      supportedLocales: CustomLocalizations.supportedLocales,
    );
  }

  void _init() {
    Options options = DioUtil.getDefOptions();
    options.baseUrl = Constant.server_address;
    String cookie = SpUtil.getString(Constant.keyAppToken);
    if (ObjectUtil.isNotEmpty(cookie)) {
      Map<String, dynamic> _headers = <String, dynamic>{
        'Cookie': cookie,
      };
      options.headers = _headers;
    }

    HttpConfig config = new HttpConfig(options: options);
    new DioUtil().setConfig(config);
  }

  void _loadLocal() {
    setState(() {
      LanguageModel model =
          SpHelper.getObject<LanguageModel>(Constant.keyLanguage);
      if (model != null) {
        _locale = new Locale(model.languageCode, model.countryCode);
      } else {
        _locale = null;
      }

      String _colorKey = SpHelper.getThemeColor();
      if (themeColorMap[_colorKey] != null) {
        _themeColor = themeColorMap[_colorKey];
      }
    });
  }

  void _initAsync() async {
    await SpUtil.getInstance();
    if (!mounted) {
      return;
    }

    _init();
    _loadLocal();
  }

  _initListener() {
    final ApplicationBloc bloc = BlocProvider.of<ApplicationBloc>(context);
    bloc.appEventStream.listen((value) {
      _loadLocal();
    });
  }
}
