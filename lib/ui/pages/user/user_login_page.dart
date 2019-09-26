import 'package:fluintl/fluintl.dart';
import 'package:flustars/flustars.dart';
import 'package:flutter/material.dart';
import 'package:flutter_wan/common/common.dart';
import 'package:flutter_wan/common/sp_helper.dart';
import 'package:flutter_wan/data/protocol/models.dart';
import 'package:flutter_wan/data/repository/user_repository.dart';
import 'package:flutter_wan/event/event.dart';
import 'package:flutter_wan/res/colors.dart';
import 'package:flutter_wan/res/dimens.dart';
import 'package:flutter_wan/res/strings.dart';
import 'package:flutter_wan/res/style.dart';
import 'package:flutter_wan/ui/pages/user/user_register_page.dart';
import 'package:flutter_wan/ui/widgets/login_item.dart';
import 'package:flutter_wan/ui/widgets/round_button.dart';
import 'package:flutter_wan/utils/navigator_utils.dart';
import 'package:flutter_wan/utils/route_util.dart';
import 'package:flutter_wan/utils/utils.dart';
import 'package:rxdart/rxdart.dart';

class UserLoginPage extends StatelessWidget {
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
            fit: BoxFit.fill,
          ),
          new UserLoginBody(),
        ],
      ),
    );
  }
}

class UserLoginBody extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    TextEditingController _controllerName = new TextEditingController();
    TextEditingController _controllerPwd = new TextEditingController();
    UserRepository userRepository = new UserRepository();
    UserModel userModel = SpHelper.getObject<UserModel>(Constant.keyUserModel);
    _controllerName.text = userModel?.username ?? '';

    void _userLogin() {
      var username = _controllerName.text;
      var pwd = _controllerPwd.text;
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

      LoginReq req = new LoginReq(username, pwd);
      userRepository.login(req).then((UserModel model) {
        LogUtil.e('LoginResp : ${model.toString()}');
        Utils.showSnackBar(context, '登录成功');
        Observable.just(1).delay(new Duration(milliseconds: 500)).listen((_) {
          Event.sendAppEvent(context, Constant.type_refresh_all);
          RouteUtil.goMain(context);
        });
      }).catchError((error) {
        LogUtil.e('LoginResp error: ${error.toString()}');
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
                hasSuffixIcon: false,
                hintText: IntlUtil.getString(context, Ids.user_name),
              ),
              new LoginItem(
                controller: _controllerPwd,
                prefixIcon: Icons.lock,
                hasSuffixIcon: true,
                hintText: IntlUtil.getString(context, Ids.user_pwd),
              ),
              new Container(
                padding: EdgeInsets.only(top: Dimens.gap_dp15),
                alignment: Alignment.centerRight,
                child: InkWell(
                  child: new Text(
                    IntlUtil.getString(context, Ids.user_forget_pwd),
                    style: new TextStyle(
                        color: Colours.gray_99, fontSize: Dimens.font_sp14),
                  ),
                  onTap: () {
                    Utils.showSnackBar(context, '请联系管理员');
                  },
                ),
              ),
              new RoundButton(
                text: IntlUtil.getString(context, Ids.user_login),
                margin: EdgeInsets.only(top: 20),
                onPressed: () {
                  _userLogin();
                },
              ),
              Gaps.vGap15,
              new InkWell(
                onTap: () {
                  NavigatorUtils.pushPage(context, new UserRegisterPage());
                },
                child: new RichText(
                  text: new TextSpan(children: [
                    new TextSpan(
                      text: IntlUtil.getString(context, Ids.user_new_user_hint),
                      style:
                          new TextStyle(color: Colours.text_gray, fontSize: 14),
                    ),
                    new TextSpan(
                      text: IntlUtil.getString(context, Ids.user_register),
                      style: new TextStyle(
                          color: Theme.of(context).primaryColor, fontSize: 14),
                    ),
                  ]),
                ),
              )
            ],
          ),
        ))
      ],
    );
  }
}
