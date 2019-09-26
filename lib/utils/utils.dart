import 'package:flustars/flustars.dart';
import 'package:flutter/material.dart';
import 'package:flutter_wan/common/common.dart';
import 'package:flutter_wan/res/colors.dart';
import 'package:flutter_wan/res/strings.dart';
import 'package:lpinyin/lpinyin.dart';

class Utils {
  static String getImgPath(String name, {String format: 'png'}) {
    return 'assets/images/$name.$format';
  }

  static String getPinyin(String str) {
    return PinyinHelper.getShortPinyin(str).substring(0, 1).toUpperCase();
  }

  static Color getCircleAvatarBg(String key) {
    return circleAvatarMap[key];
  }

  static Color getCircleBg(String str) {
    return getCircleAvatarBg(getPinyin(str));
  }

  static Color getChipBgColor(String name) {
    String pinyin =
        PinyinHelper.getFirstWordPinyin(name).substring(0, 1).toUpperCase();
    return nameToColor(pinyin);
  }

  static Color nameToColor(String name) {
    final int hash = name.hashCode & 0xFFFF;
    final double hue = (360.0 * hash / (1 << 15) % 163.0);
    return HSVColor.fromAHSV(1.0, hue, 0.4, 0.9).toColor();
  }

  static String getTimeLine(BuildContext context, int timeMillis) {
    return TimelineUtil.format(timeMillis,
        locale: Localizations.localeOf(context).languageCode,
        dayFormat: DayFormat.Common);
  }

  static double getTitleFontSize(String title) {
    if (ObjectUtil.isEmpty(title) || title.length < 10) {
      return 18.0;
    }

    int count = 0;
    List<String> list = title.split('');
    for (int i = 0, length = list.length; i < length; i++) {
      String ss = list[i];
      if (RegexUtil.isZh(ss)) {
        count++;
      }
    }

    return (count >= 10 || title.length > 16) ? 14.0 : 18.0;
  }

  static int getUpdateStatus(String version) {
    String locVersion = AppConfig.version;
    int remote = int.tryParse(version.replaceAll('.', ''));
    int loc = int.tryParse(locVersion.replaceAll('.', ''));
    if (remote <= loc) {
      return 0;
    } else if (remote - loc >= 2) {
      return -1;
    } else {
      return 1;
    }
  }

  static bool isNeedLogin(String pageId) {
    if (pageId == Ids.titleCollection) {
      return true;
    }
    return false;
  }

  static bool isLogin() {
    return ObjectUtil.isNotEmpty(SpUtil.getString(Constant.keyAppToken));
  }

  static void showSnackBar(BuildContext context, String msg) {
    Scaffold.of(context).showSnackBar(
      SnackBar(content: Text("$msg")),
    );
  }

  static int getLoadStatus(bool hasError, List data) {
    if (hasError) {
      return LoadStatus.fail;
    }

    if (data == null) {
      return LoadStatus.loading;
    } else if (data.isEmpty) {
      return LoadStatus.empty;
    } else {
      return LoadStatus.success;
    }
  }
}
