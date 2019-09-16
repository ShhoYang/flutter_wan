import 'package:flutter_wan/common/common.dart';
import 'package:flutter_wan/data/api/apis.dart';
import 'package:flutter_wan/data/net/dio_util.dart';
import 'package:flutter_wan/data/protocol/base_resp.dart';
import 'package:flutter_wan/data/protocol/models.dart';

class CollectRepository {
  Future<List<ReposModel>> getCollectList(int page) async {
    BaseResp<Map<String, dynamic>> baseResp =
        await new DioUtil().request<Map<String, dynamic>>(
            Method.get,
            WanAndroidApi.getPath(
              path: WanAndroidApi.lg_collect_list,
              page: page,
            ));

    if (baseResp.code != Constant.status_success) {
      return new Future.error(baseResp.msg);
    }

    List<ReposModel> list;
    if (baseResp.data != null) {
      ComData comData = new ComData.fromJson(baseResp.data);
      list = comData.datas?.map((value) {
        ReposModel model = new ReposModel.fromJson(value);
        model.collect = true;
        return model;
      })?.toList();
    }

    return list;
  }

  Future<bool> collect(int id) async {
    BaseResp baseResp = await new DioUtil().request(
        Method.post,
        WanAndroidApi.getPath(
          path: WanAndroidApi.lg_collect,
          page: id,
        ));
    if (baseResp.code != Constant.status_success) {
      return new Future.error(baseResp.msg);
    }

    return true;
  }

  Future<bool> unCollect(int id) async {
    BaseResp baseResp = await new DioUtil().request(
        Method.post,
        WanAndroidApi.getPath(
          path: WanAndroidApi.lg_uncollect_originid,
          page: id,
        ));

    if (baseResp.code != Constant.status_success) {
      return new Future.error(baseResp.msg);
    }

    return true;
  }
}
