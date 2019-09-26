import 'package:fluintl/fluintl.dart';
import 'package:flustars/flustars.dart';
import 'package:flutter/material.dart';
import 'package:flutter_wan/common/common.dart';
import 'package:flutter_wan/data/protocol/models.dart';
import 'package:flutter_wan/data/repository/user_repository.dart';
import 'package:flutter_wan/event/event.dart';
import 'package:flutter_wan/res/strings.dart';
import 'package:flutter_wan/res/style.dart';
import 'package:flutter_wan/ui/widgets/login_item.dart';
import 'package:flutter_wan/ui/widgets/round_button.dart';
import 'package:flutter_wan/utils/route_util.dart';
import 'package:flutter_wan/utils/utils.dart';
import 'package:rxdart/rxdart.dart';

class UserRegisterPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      resizeToAvoidBottomInset: false,
      body: new Stack(
        children: <Widget>[
          new Image.asset(
            Utils.getImgPath('ic_login_bg'),
            width: double.infinity,
            height: double.infinity,
            fit: BoxFit.cover,
          ),
          new UserRegisterBody(),
        ],
      ),
    );
  }
}

class UserRegisterBody extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    TextEditingController _controllerName = new TextEditingController();
    TextEditingController _controllerPwd = new TextEditingController();
    TextEditingController _controllerRePwd = new TextEditingController();

    UserRepository repository = new UserRepository();

    void _register() {
      String username = _controllerName.text;
      String pwd = _controllerPwd.text;
      String rePwd = _controllerRePwd.text;

      if (username.isEmpty) {
        Utils.showSnackBar(context, '请输入用户名');
        return;
      }
      if (username.length < 6) {
        Utils.showSnackBar(context, '用户名至少六位');
        return;
      }
      if (pwd.isEmpty) {
        Utils.showSnackBar(context, '请输入密码');
        return;
      }
      if (pwd.length < 6) {
        Utils.showSnackBar(context, '密码至少六位');
        return;
      }
      if (rePwd.isEmpty) {
        Utils.showSnackBar(context, '请输入确认密码');
        return;
      }
      if (rePwd.length < 6) {
        Utils.showSnackBar(context, '确认密码至少六位');
        return;
      }

      if (pwd != rePwd) {
        Utils.showSnackBar(context, '密码不一致');
        return;
      }

      RegisterReq req = new RegisterReq(username, pwd, rePwd);
      repository.register(req).then(((UserModel model) {
        LogUtil.e('register: ${model.toString()}');
        Utils.showSnackBar(context, '注册成功');
        Observable.just(1).delay(new Duration(milliseconds: 500)).listen((_) {
          Event.sendAppEvent(context, Constant.type_refresh_all);
          RouteUtil.goMain(context);
        });
      })).catchError((error) {
        LogUtil.e('register error: ${error.toString()}');
        Utils.showSnackBar(context, error.toString());
      });
    }

    return new Column(
      children: <Widget>[
        new Expanded(child: new Container()),
        new Expanded(
          child: new Container(
            margin: EdgeInsets.only(left: 20.0, top: 15.0, right: 20.0),
            child: new Column(
              children: <Widget>[
                new LoginItem(
                  controller: _controllerName,
                  prefixIcon: Icons.person,
                  hintText: IntlUtil.getString(context, Ids.user_name),
                ),
                Gaps.vGap10,
                new LoginItem(
                  controller: _controllerPwd,
                  prefixIcon: Icons.lock,
                  hintText: IntlUtil.getString(context, Ids.user_pwd),
                ),
                Gaps.vGap10,
                new LoginItem(
                  controller: _controllerRePwd,
                  prefixIcon: Icons.lock,
                  hintText: IntlUtil.getString(context, Ids.user_re_pwd),
                ),
                new RoundButton(
                  text: IntlUtil.getString(context, Ids.user_register),
                  margin: EdgeInsets.only(top: 20),
                  onPressed: () {
                    _register();
                  },
                )
              ],
            ),
          ),
        ),
      ],
    );
  }
}
