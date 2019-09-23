import 'package:flustars/flustars.dart';
import 'package:flutter_wan/common/common.dart';
import 'package:flutter_wan/data/api/apis.dart';
import 'package:flutter_wan/data/net/dio_util.dart';
import 'package:flutter_wan/data/protocol/base_resp.dart';
import 'package:flutter_wan/data/protocol/models.dart';

class WanRepository {
  final String TAG = 'WanRepository--';

  Future<List<BannerModel>> getBanner() async {
    BaseResp<List> baseResp = await new DioUtil()
        .request(Method.get, WanAndroidApi.getPath(path: WanAndroidApi.BANNER));

    if (baseResp.code != Constant.status_success) {
      return new Future.error(baseResp.msg);
    }

    List<BannerModel> list;

    if (baseResp.data != null) {
      LogUtil.e('getBanner -- ${baseResp.data}', tag: TAG);
      list = baseResp.data.map((value) {
        return new BannerModel.fromJson(value);
      }).toList();
    }

    return list;
  }

  Future<List<ReposModel>> getArticleListProject(int page) async {
    BaseResp<Map<String, dynamic>> baseResp =
        await new DioUtil().request<Map<String, dynamic>>(
      Method.get,
      WanAndroidApi.getPath(
          path: WanAndroidApi.ARTICLE_LISTPROJECT, page: page),
    );

    if (baseResp.code != Constant.status_success) {
      return new Future.error(baseResp.msg);
    }

    List<ReposModel> list;
    if (baseResp.data != null) {
      LogUtil.e('getArticleListProject -- ${baseResp.data}', tag: TAG);
      ComData comData = new ComData.fromJson(baseResp.data);
      list = comData.datas.map((value) {
        return new ReposModel.fromJson(value);
      }).toList();
    }

    return list;
  }

  Future<List<ReposModel>> getArticleList({int page, data}) async {
    BaseResp<Map<String, dynamic>> baseResp = await new DioUtil()
        .request<Map<String, dynamic>>(Method.get,
            WanAndroidApi.getPath(path: WanAndroidApi.ARTICLE_LIST, page: page),
            data: data);

    if (baseResp.code != Constant.status_success) {
      return new Future.error(baseResp.msg);
    }

    List<ReposModel> list;
    if (baseResp.data != null) {
      LogUtil.e('getArticleList -- ${baseResp.data}', tag: TAG);
      ComData comData = new ComData.fromJson(baseResp.data);
      list = comData.datas.map((value) {
        return new ReposModel.fromJson(value);
      }).toList();
    }

    return list;
  }

  Future<List<TreeModel>> getTree() async {
    BaseResp<List> baseResp = await DioUtil().request<List>(
        Method.get, WanAndroidApi.getPath(path: WanAndroidApi.TREE));

    if (baseResp.code != Constant.status_success) {
      return new Future.error(baseResp.msg);
    }
    List<TreeModel> list;

    if (baseResp.data != null) {
      LogUtil.e('getTree -- ${baseResp.data}', tag: TAG);
      list = baseResp.data.map((value) {
        return TreeModel.fromJson(value);
      }).toList();
    }
    return list;
  }

  Future<List<ReposModel>> getProjectList({int page: 1, data}) async {
    BaseResp<Map<String, dynamic>> baseResp = await DioUtil()
        .request<Map<String, dynamic>>(Method.get,
            WanAndroidApi.getPath(path: WanAndroidApi.PROJECT_LIST, page: page),
            data: data);

    if (baseResp.code != Constant.status_success) {
      return new Future.error(baseResp.msg);
    }
    List<ReposModel> list;
    if (baseResp.data != null) {
      LogUtil.e('getProjectList -- ${baseResp.data}', tag: TAG);
      ComData comData = ComData.fromJson(baseResp.data);
      list = comData.datas.map((value) {
        return ReposModel.fromJson(value);
      }).toList();
    }
    return list;
  }

  Future<List<ReposModel>> getWxArticleList({int id, int page: 1, data}) async {
    BaseResp<Map<String, dynamic>> baseResp = await DioUtil()
        .request<Map<String, dynamic>>(
            Method.get,
            WanAndroidApi.getPath(
                path: WanAndroidApi.WXARTICLE_LIST + '/$id', page: page),
            data: data);

    if (baseResp.code != Constant.status_success) {
      return new Future.error(baseResp.msg);
    }

    List<ReposModel> list;
    if (baseResp.data != null) {
      LogUtil.e('getWxArticleList -- ${baseResp.data}', tag: TAG);
      ComData comData = ComData.fromJson(baseResp.data);
      list = comData.datas.map((value) {
        return ReposModel.fromJson(value);
      }).toList();
    }
    return list;
  }

  Future<List<TreeModel>> getWxArticleChapters() async {
    BaseResp<List> baseResp = await DioUtil().request<List>(Method.get,
        WanAndroidApi.getPath(path: WanAndroidApi.WXARTICLE_CHAPTERS));

    if (baseResp.code != Constant.status_success) {
      return new Future.error(baseResp.msg);
    }
    List<TreeModel> list;
    if (baseResp.data != null) {
      LogUtil.e('getWxArticleChapters -- ${baseResp.data}', tag: TAG);
      list = baseResp.data.map((value) {
        return TreeModel.fromJson(value);
      }).toList();
    }
    return list;
  }

  Future<List<TreeModel>> getProjectTree() async {
    BaseResp<List> baseResp = await DioUtil().request<List>(
        Method.get, WanAndroidApi.getPath(path: WanAndroidApi.PROJECT_TREE));

    if (baseResp.code != Constant.status_success) {
      return new Future.error(baseResp.msg);
    }
    List<TreeModel> list;
    if (baseResp.data != null) {
      LogUtil.e('getProjectTree -- ${baseResp.data}', tag: TAG);
      list = baseResp.data.map((value) {
        return TreeModel.fromJson(value);
      }).toList();
    }
    return list;
  }
}
