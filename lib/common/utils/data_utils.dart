import 'package:actual/common/const/data.dart';

class DataUtils {
  /// 무조건 static이어야함
  static String pathToUrl(String value){
    return 'http://$ip$value';
  }

  // 들어오는 List는 dynamic으로 인식됨
  static List<String> listPathsToUrls(List paths){
    return paths.map((e) => pathToUrl(e)).toList();
  }
}