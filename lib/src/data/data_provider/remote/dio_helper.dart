import 'package:dio/dio.dart';
import 'package:seda/src/constants/end_points.dart';
import 'package:seda/src/constants/shared_preference_keys.dart';
import 'package:seda/src/data/data_provider/local/cache_helper.dart';

class DioHelper {
  static Dio? dio;

  static init() {
    dio = Dio(
      BaseOptions(
        baseUrl: EndPoints.baseUrl,
        receiveDataWhenStatusError: true,
      ),
    );
  }

  static Future<Response> downloadMedia({
    required String url,
    required String path,
    Map<String, dynamic>? query,
    Function(int, int)? onReceiveProgress,
    String? token,
  }) async {
    dio!.options.headers = {
      'Accept-Language': CacheHelper.getDataFromSharedPreference(
          key: SharedPreferenceKeys.appLanguageSharedKey),
      'appKey': EndPoints.appKey,
    };
    if (token != null) {
      dio!.options.headers['Authorization'] = 'Bearer $token';
    } else {
      dio!.options.headers['Authorization'] =
          'Bearer ${CacheHelper.getDataFromSharedPreference(key: SharedPreferenceKeys.userToken)}';
    }
    return await dio!.download(
      url,
      path,
      queryParameters: query,
      onReceiveProgress: onReceiveProgress,
    );
  }

  static Future<Response> getData({
    required String url,
    Map<String, dynamic>? query,
    String? token,
  }) async {
    dio!.options.headers = {
      'Accept': 'application/json',
      // 'Content-Type': 'application/json;multipart/form-data',
      'Accept-Language': CacheHelper.getDataFromSharedPreference(
          key: SharedPreferenceKeys.appLanguageSharedKey),
      'appKey': EndPoints.appKey,
    };
    if (token != null) {
      dio!.options.headers['Authorization'] = 'Bearer $token';
    } else {
      dio!.options.headers['Authorization'] =
          'Bearer ${CacheHelper.getDataFromSharedPreference(key: SharedPreferenceKeys.userToken)}';
    }
    return await dio!.get(url, queryParameters: query);
  }

  static Future<Response> postData({
    required String url,
    Map<String, dynamic>? query,
    Map<String, dynamic>? body,
    bool isForm = false,
    String? token,
  }) async {
    dio!.options.headers = {
      'Accept': 'application/json',
      // 'Content-Type': 'application/json;multipart/form-data',
      'Accept-Language': CacheHelper.getDataFromSharedPreference(
          key: SharedPreferenceKeys.appLanguageSharedKey),
      'appKey': EndPoints.appKey,
    };
    if (token != null) {
      dio!.options.headers['Authorization'] = 'Bearer $token';
    } else {
      dio!.options.headers['Authorization'] =
          'Bearer ${CacheHelper.getDataFromSharedPreference(key: SharedPreferenceKeys.userToken)}';
    }
    return await dio!.post(
      url,
      queryParameters: query,
      data: body != null && isForm ? FormData.fromMap(body) : body,
    );
  }

  static Future<Response> putData({
    required String url,
    Map<String, dynamic>? query,
    Map<String, dynamic>? body,
    bool isForm = false,
    String? token,
  }) async {
    dio!.options.headers = {
      'Accept': 'application/json',
      // 'Content-Type': 'application/json;multipart/form-data',
      'Accept-Language': CacheHelper.getDataFromSharedPreference(
          key: SharedPreferenceKeys.appLanguageSharedKey),
      'appKey': EndPoints.appKey,
    };
    if (token != null) {
      dio!.options.headers['Authorization'] = 'Bearer $token';
    } else {
      dio!.options.headers['Authorization'] =
          'Bearer ${CacheHelper.getDataFromSharedPreference(key: SharedPreferenceKeys.userToken)}';
    }
    return await dio!.put(
      url,
      queryParameters: query,
      data: body != null && isForm ? FormData.fromMap(body) : body,
    );
  }

  static Future<Response> deleteData({
    required String url,
    Map<String, dynamic>? query,
    Map<String, dynamic>? body,
    bool isForm = false,
    String? token,
  }) async {
    dio!.options.headers = {
      'Accept': 'application/json',
      // 'Content-Type': 'application/json;multipart/form-data',
      'Accept-Language': CacheHelper.getDataFromSharedPreference(
          key: SharedPreferenceKeys.appLanguageSharedKey),
      'appKey': EndPoints.appKey,
    };
    if (token != null) {
      dio!.options.headers['Authorization'] = 'Bearer $token';
    } else {
      dio!.options.headers['Authorization'] =
          'Bearer ${CacheHelper.getDataFromSharedPreference(key: SharedPreferenceKeys.userToken)}';
    }
    return await dio!.delete(
      url,
      queryParameters: query,
      data: body != null && isForm ? FormData.fromMap(body) : body,
    );
  }

  static Future<Response> verifyPhoneSocial({
    required String url,
    required dynamic body,
    required String token,
  }) async {
    dio!.options.headers = {
      'Accept': 'application/json',
      // 'Content-Type': 'application/json',
      'Accept-Language': CacheHelper.getDataFromSharedPreference(
          key: SharedPreferenceKeys.appLanguageSharedKey),
      'Authorization': "Bearer $token",
      'appKey': EndPoints.appKey,
    };
    return await dio!.post(
      url,
      data: body,
    );
  }
}
