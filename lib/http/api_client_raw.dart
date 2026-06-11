import 'dart:convert';

import 'package:http/http.dart' as http;
import '../utils/logger.dart';

class BaseRequest {
  Future<String> postRequest(
    String url,
    Map jsonMap, {
    String? token,
  }) async {
    Logger.println("HTTP: POST: REQUEST: \n$jsonMap");
    var response = await http.post(
      Uri.parse(url),
      headers: {
        'Content-type': "application/json",
        'Authorization': "'Bearer $token",
      },
      body: jsonEncode(jsonMap),
    );

    Logger.println("HTTP: POST: RESPONSE: \n${response.body}");
    return response.body;
    /* HttpClient httpClient = HttpClient();
    HttpClientRequest request = await httpClient.postUrl(Uri.parse(url));
    request.headers.set('Content-Type', 'application/json');
    token != null
        ? request.headers.set('Authorization', 'Bearer ' + token)
        : null;

    Logger.println("HTTP: POST: REQUEST: \n" + jsonMap.toString());
    request.add(utf8.encode(json.encode(jsonMap)));
    HttpClientResponse response = await request.close();
    String reply = await response.transform(utf8.decoder).join();
    httpClient.close();
    Logger.println("HTTP: POST: RESPONSE: \n" + reply);
    return reply;*/
  }

  Future<String> getRequest(
    String url, {
    String? token,
  }) async {
    Logger.println("HTTP: GET: REQUEST: \n$url");
    var response = await http.get(
      Uri.parse(url),
      headers: {
        'Content-type': "application/json",
        'Authorization': "'Bearer $token",
      },
    );

    Logger.println("HTTP: GET: RESPONSE: \n${response.body}");
    return response.body;
    /* HttpClient httpClient = HttpClient();
    HttpClientRequest request = await httpClient.getUrl(Uri.parse(url));
    request.headers.set('Content-Type', 'application/json');

    token != null
        ? request.headers.set('Authorization', 'Bearer ' + token)
        : null;
    HttpClientResponse response = await request.close();
    String reply = await response.transform(utf8.decoder).join();
    print("token:${token}");
    httpClient.close();
    Logger.println("HTTP: GET: RESPONSE: \n" + reply);
    return reply;*/
  }

  Future<String> putRequest(String url, {String? token, Map? jsonMap}) async {
    Logger.println("HTTP: PUT: REQUEST: \n$jsonMap");
    var response = await http.put(
      Uri.parse(url),
      headers: {
        'Content-type': "application/json",
        'Authorization': "'Bearer $token",
      },
      body: jsonEncode(jsonMap),
    );

    Logger.println("HTTP: PUT: RESPONSE: \n${response.body}");
    return response.body;
    /*HttpClient httpClient = HttpClient();
    HttpClientRequest request = await httpClient.putUrl(Uri.parse(url));
    request.headers.set('Content-Type', 'application/json');
    token != null
        ? request.headers.set('Authorization', 'Bearer ' + token)
        : null;
    Logger.println("HTTP: PUT: REQUEST: \n" + jsonMap.toString());
    request.add(utf8.encode(json.encode(jsonMap)));
    HttpClientResponse response = await request.close();
    String reply = await response.transform(utf8.decoder).join();
    httpClient.close();
    Logger.println("HTTP: PUT: RESPONSE: \n" + reply);
    return reply;*/
  }

  Future<String> deleteRequest(
    String url, {
    Map? jsonMap,
    String? token,
  }) async {
    Logger.println("HTTP: DELETE: REQUEST: \n$jsonMap");
    var response = await http.delete(
      Uri.parse(url),
      headers: {
        'Content-type': "application/json",
        'Authorization': "'Bearer $token",
      },
      body: jsonEncode(jsonMap),
    );

    Logger.println("HTTP: DELETE: RESPONSE: \n${response.body}");
    return response.body;
    /* HttpClient httpClient = HttpClient();
    HttpClientRequest request = await httpClient.deleteUrl(Uri.parse(url));
    request.headers.set('Content-Type', 'application/json');
    token != null
        ? request.headers.set('Authorization', 'Bearer ' + token)
        : null;

    Logger.println("HTTP: DELETE: REQUEST: \n" + jsonMap.toString());
    request.add(utf8.encode(json.encode(jsonMap)));
    HttpClientResponse response = await request.close();
    String reply = await response.transform(utf8.decoder).join();
    httpClient.close();
    Logger.println("HTTP: DELETE: RESPONSE: \n" + reply);
    return reply;*/
  }
}
