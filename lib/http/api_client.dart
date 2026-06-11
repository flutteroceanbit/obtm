import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:oceanbit_timeclock/main.dart';
import 'package:oceanbit_timeclock/utils/logger.dart';

class DioClient {
  final Dio dio = Dio();

  DioClient() {
    dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) {
          Logger.println("HTTP: ${options.method}: REQUEST: \n${options.uri}");
          Logger.println("Headers: ${options.headers}");
          Logger.println("Body: ${options.data}");
          return handler.next(options);
        },
        onResponse: (response, handler) {
          Logger.println("HTTP RESPONSE: \n${response.data}");
          return handler.next(response);
        },
        onError: (DioException e, handler) {
          Logger.println("HTTP ERROR: ${e.message}");
          if (e.response != null) {
            Logger.println("Error Response: ${e.response?.data}");
          }
          return handler.next(e);
        },
      ),
    );
  }

  Future<Response> postMultipartRequest({
    required String url,
    Map<String, String>? body,
    String? token,
  }) async {
    FormData formData = FormData.fromMap(body ?? {});

    try {
      Response response = await dio.post(
        url,
        data: formData,
        options: Options(
          headers: {
            'Authorization': 'Bearer $token',
            // 'Content-Type': 'multipart/form-data',
          },
        ),
      );
      return response;
    } catch (e) {
      if (e is DioException) {
        // Handle Dio exception
        print("Response error : ${e.error}");
        print("Response error : ${e.response}");
        print("Response error : ${e.stackTrace}");
        print("Response error : ${e.message}");
        return e.response!;
      } else {
        rethrow;
      }
    }
  }

  Future<Response> getRequest({
    required String url,
    Map<String, dynamic>? queryParams,
    String? token,
    // Map<String, dynamic>? body,
  }) async {
    try {
      Response response = await dio.get(
        url,
        queryParameters: queryParams,
        // data: body,
        options: Options(headers: _getHeaders(token)),
      );
      return response;
    } catch (e) {
      if (e is DioException) {
        // Handle Dio exception
        return e.response!;
      } else {
        rethrow;
      }
    }
  }

  Future<Response> postRequest({
    required String url,
    Map<String, dynamic>? body,
    String? token,
  }) async {
    try {
      Response response = await dio.post(
        url,
        data: jsonEncode(body),
        options: Options(headers: _getHeaders(token)),
      );
      return response;
    } catch (e) {
      if (e is DioException) {
        print("Response error : ${e.error}");
        print("Response error : ${e.response}");
        print("Response error : ${e.stackTrace}");
        print("Response error : ${e.message}");
        return e.response!;
      } else {
        rethrow;
      }
    }
  }

  Future<Response> putRequest({
    required String url,
    Map<String, dynamic>? body,
    String? token,
  }) async {
    try {
      Response response = await dio.put(
        url,
        data: jsonEncode(body),
        options: Options(headers: _getHeaders(token)),
      );
      return response;
    } catch (e) {
      if (e is DioException) {
        // Handle Dio exception
        return e.response!;
      } else {
        rethrow;
      }
    }
  }

  Future<Response> deleteRequest({
    required String url,
    Map<String, dynamic>? body,
    String? token,
  }) async {
    try {
      Response response = await dio.delete(
        url,
        data: jsonEncode(body),
        options: Options(headers: _getHeaders(token)),
      );
      return response;
    } catch (e) {
      if (e is DioException) {
        // Handle Dio exception
        return e.response!;
      } else {
        rethrow;
      }
    }
  }

  Future<Response> postMultiPart({
    required String url,
    required String fileKey,
    required Map<String, String> body,
    required String? token,
    String? filePath,
    PlatformFile? file,
    Uint8List? fileBytes,
  }) async {
    FormData formData = FormData.fromMap(body);

    if (kIsWeb && file != null) {
      formData.files.add(
        MapEntry(
          fileKey,
          MultipartFile.fromBytes(file.bytes!, filename: file.name),
        ),
      );
    } else if (!kIsWeb && filePath != null && filePath.isNotEmpty) {
      formData.files.add(
        MapEntry(
          fileKey,
          await MultipartFile.fromFile(
            filePath,
            filename: filePath.split('/').last,
          ),
        ),
      );
    }

    try {
      Response response = await dio.post(
        url,
        data: formData,
        options: Options(headers: _getHeaders(token, isMultipart: true)),
      );
      return response;
    } catch (e) {
      if (e is DioException) {
        // Handle Dio exception
        return e.response!;
      } else {
        rethrow;
      }
    }
  }

  Map<String, String> _getHeaders(String? token, {bool isMultipart = false}) {
    return {
      'Authorization': 'Bearer $token',
      'version': '$version',
      'versionCode': '$buildNumber',
      'platform': Platform.operatingSystem,
      'os': Platform.operatingSystemVersion,
      if (!isMultipart) 'Content-Type': 'application/json',
    };
  }
}
