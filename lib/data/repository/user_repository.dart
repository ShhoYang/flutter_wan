import 'package:flustars/flustars.dart';
import 'package:flutter_wan/common/common.dart';
import 'package:flutter_wan/data/api/apis.dart';
import 'package:flutter_wan/data/net/dio_util.dart';
import 'package:flutter_wan/data/protocol/base_resp.dart';
import 'package:flutter_wan/data/protocol/models.dart';

class UserRepository {
  Future<UserModel> login(LoginReq req) async {
    BaseRespR<Map<String, dynamic>> baseResp =
        await new DioUtil().requestR<Map<String, dynamic>>(
      Method.post,
      WanAndroidApi.user_login,
      data: req.toJson(),
    );

    if (baseResp.code != Constant.status_success) {
      return new Future.error(baseResp.msg);
    }

    baseResp.response.headers.forEach((String name, List<String> values) {
      if (name == 'set-cookie') {
        String cookie = values.toString();
        LogUtil.e('set-cookie' + cookie);
        SpUtil.putString(Constant.keyAppToken, cookie);
        new DioUtil().setCookie(cookie);
      }
    });

    UserModel user = new UserModel.fromJson(baseResp.data);
    SpUtil.putObject(Constant.keyUserModel, user);
    return user;
  }

  Future<UserModel> register(RegisterReq req) async {
    BaseRespR<Map<String, dynamic>> baseResp =
        await new DioUtil().requestR<Map<String, dynamic>>(
      Method.post,
      WanAndroidApi.user_register,
      data: req.toJson(),
    );

    if (baseResp.code != Constant.status_success) {
      return new Future.error(baseResp.msg);
    }

    baseResp.response.headers.forEach((String name, List<String> values) {
      if (name == 'set-cookie') {
        String cookie = values.toString();
        LogUtil.e('set-cookie' + cookie);
        SpUtil.putString(Constant.keyAppToken, cookie);
        new DioUtil().setCookie(cookie);
      }
    });

    UserModel user = new UserModel.fromJson(baseResp.data);
    SpUtil.putObject(Constant.keyUserModel, user);
    return user;
  }
}
