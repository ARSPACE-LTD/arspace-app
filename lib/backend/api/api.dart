/*
  Authors : initappz (Rahul Jograna)
  Website : https://initappz.com/
  App Name : Ultimate Salon Full App Flutter V2
  This App Template Source code is licensed as per the
  terms found in the Website https://initappz.com/license
  Copyright and Good Faith Purchasers © 2023-present initappz.
*/
import 'dart:convert';
import 'dart:io';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';

class ApiService extends GetxService {
  final String appBaseUrl;
  static const String connectionIssue = 'Connection failed!';
  final int timeoutInSeconds = 30;

  ApiService({required this.appBaseUrl});

  Future<Response> getPublic(String uri) async {
    try {
      http.Response response = await http
          .get(
            Uri.parse(appBaseUrl + uri),
          )
          .timeout(Duration(seconds: timeoutInSeconds));
      return parseResponse(response, uri);
    } catch (e) {
      return const Response(statusCode: 1, statusText: connectionIssue);
    }
  }

  Future<Response> getPrivate(String uri, String token) async {
    try {
     /* http.Response response = await http.get(Uri.parse(appBaseUrl + uri),
          headers: {
            'Content-Type': 'application/json;',
            'Authorization': 'Token $token'
          }).timeout(Duration(seconds: timeoutInSeconds));*/
      http.Response response = await http.get(Uri.parse(appBaseUrl + uri),
          headers: token != null && token.isNotEmpty ?
          {
            'Content-Type': 'application/json;',
            'Authorization': 'Token $token'
          }:
          {
            'Content-Type': 'application/json;',
          }

          ).timeout(Duration(seconds: timeoutInSeconds));
      return parseResponse(response, uri);
    } catch (e) {
      return const Response(statusCode: 1, statusText: connectionIssue);
    }
  }

  Future<Response> deletePrivate(String uri, String token) async {
    try {
      /* http.Response response = await http.get(Uri.parse(appBaseUrl + uri),
          headers: {
            'Content-Type': 'application/json;',
            'Authorization': 'Token $token'
          }).timeout(Duration(seconds: timeoutInSeconds));*/
      http.Response response = await http.delete(Uri.parse(appBaseUrl + uri),
          headers: token != null && token.isNotEmpty ?
          {
            'Content-Type': 'application/json;',
            'Authorization': 'Token $token'
          }:
          {
            'Content-Type': 'application/json;',
          }

      ).timeout(Duration(seconds: timeoutInSeconds));
      return parseResponse(response, uri);
    } catch (e) {
      return const Response(statusCode: 1, statusText: connectionIssue);
    }
  }


  Future<Response> getPrivatePatchRequest(String uri, String token) async {
    try {
      /* http.Response response = await http.get(Uri.parse(appBaseUrl + uri),
          headers: {
            'Content-Type': 'application/json;',
            'Authorization': 'Token $token'
          }).timeout(Duration(seconds: timeoutInSeconds));*/
      http.Response response = await http.patch(Uri.parse(appBaseUrl + uri),
          headers: {
            'Content-Type': 'application/json',
            'Authorization': 'Token $token'
          }).timeout(Duration(seconds: timeoutInSeconds));
      return parseResponse(response, uri);
    } catch (e) {
      return const Response(statusCode: 1, statusText: connectionIssue);
    }
  }

  Future<Response> getPrivatePatchLIkeDislikeRequest(String uri, String token, dynamic body) async {
    try {
      /* http.Response response = await http.get(Uri.parse(appBaseUrl + uri),
          headers: {
            'Content-Type': 'application/json;',
            'Authorization': 'Token $token'
          }).timeout(Duration(seconds: timeoutInSeconds));*/
      http.Response response = await http.patch(Uri.parse(appBaseUrl + uri),
          body: jsonEncode(body),
          headers: {
          'Content-Type': 'application/json',
            'Authorization': 'Token $token'
          }).timeout(Duration(seconds: timeoutInSeconds));
      return parseResponse(response, uri);
    } catch (e) {
      return const Response(statusCode: 1, statusText: connectionIssue);
    }
  }


  Future<Response> uploadRecordingFiles(
      String uri,
      String file,
      ) async {
    try {
      http.MultipartRequest request =
      http.MultipartRequest('POST', Uri.parse(appBaseUrl + uri));

      request.files.add(await http.MultipartFile.fromPath('attachment', file));

      http.Response response =
      await http.Response.fromStream(await request.send());
      return parseResponse(response, uri);
    } catch (e) {
      print("error== ${e}");
      return const Response(statusCode: 1, statusText: connectionIssue);
    }
  }

  Future<Response> uploadFiles(
    String uri,
    List<MultipartBody> multipartBody,
      String token,
  ) async {
    try {
      http.MultipartRequest request =
          http.MultipartRequest('POST', Uri.parse(appBaseUrl + uri));

     // request.headers['Authorization'] = 'Token $token';

      for (MultipartBody multipart in multipartBody) {
        File file = File(multipart.file.path);
        request.files.add(http.MultipartFile(
          multipart.key,
          file.readAsBytes().asStream(),
          file.lengthSync(),
          filename: file.path.split('/').last,
        ));
      }
      http.Response response =
          await http.Response.fromStream(await request.send());
      return parseResponse(response, uri);
    } catch (e) {
      print("error== ${e}");
      return const Response(statusCode: 1, statusText: connectionIssue);
    }
  }

  Future<Response> MultipartBodyStringAndImage(
      String uri,
      List<MultipartBody> multipartBody,
      Map<String, dynamic> textData,
      token) async {
    try {
      final http.MultipartRequest request =
          http.MultipartRequest('PUT', Uri.parse(appBaseUrl + uri));

      // Add headers to the request
      //request.headers['Content-Type'] = 'multipart/form-data';
      request.headers['Authorization'] = 'Token $token';

      textData.forEach((key, value) {
        request.fields[key] = value.toString();
      });

      for (final MultipartBody multipart in multipartBody) {
        final File file = File(multipart.file.path);
        request.files.add(http.MultipartFile.fromBytes(
          multipart.key,
          await file.readAsBytes(),
          filename: file.path.split('/').last,
        ));
      }

      final http.Response response = await http.Response.fromStream(
        await request.send(),
      );

      return parseResponse(response, uri);
    } catch (e) {
      return const Response(statusCode: 1, statusText: connectionIssue);

      // return Response(statusCode: 1, statusText: 'Connection Issue');
    }
  }

  Future<Response> postPublic(String uri, dynamic body,
      {Map<String, String>? headers}) async {
    try {
      http.Response response = await http
          .post(
            Uri.parse(appBaseUrl + uri),
            headers: {"Content-Type": "application/json"},
            body: jsonEncode(body),
          )
          .timeout(Duration(seconds: timeoutInSeconds));
      return parseResponse(response, appBaseUrl + uri);
    } catch (e) {
      return const Response(statusCode: 1, statusText: connectionIssue);
    }
  }

  Future<Response> getOther(String uri) async {
    try {
      http.Response response = await http
          .get(
            Uri.parse(uri),
          )
          .timeout(Duration(seconds: timeoutInSeconds));
      return parseResponse(response, uri);
    } catch (e) {
      return const Response(statusCode: 1, statusText: connectionIssue);
    }
  }

  Future<Response> postPrivate(
    String uri,
    dynamic body,
    String token,
  ) async {
    try {
      http.Response response = await http.post(Uri.parse(appBaseUrl + uri),
          body: jsonEncode(body),
          headers: {
            'Content-Type': 'application/json',
            'Authorization': 'Token $token'
          }).timeout(Duration(seconds: timeoutInSeconds));
      return parseResponse(response, uri);
    } catch (e) {
      return const Response(statusCode: 1, statusText: connectionIssue);
    }
  }

  Future<Response> postPrivateWithoutBody(
      String uri,
      String token,
      ) async {
    try {
      http.Response response = await http.post(Uri.parse(appBaseUrl + uri),
          headers: {
            'Content-Type': 'application/json',
            'Authorization': 'Token $token'
          }).timeout(Duration(seconds: timeoutInSeconds));
      return parseResponse(response, uri);
    } catch (e) {
      return const Response(statusCode: 1, statusText: connectionIssue);
    }
  }

  Future<Response> putPrivate(
    String uri,
    dynamic body,
    String token,
  ) async {
    try {
      http.Response response = await http.put(Uri.parse(appBaseUrl + uri),
          body: jsonEncode(body),
          headers: {
            'Content-Type': 'application/json',
            'Authorization': 'Token $token'
          }).timeout(Duration(seconds: timeoutInSeconds));
      return parseResponse(response, uri);
    } catch (e) {
      return const Response(statusCode: 1, statusText: connectionIssue);
    }
  }

  Future<Response> logout(
    String uri,
    String token,
  ) async {
    try {
      http.Response response = await http.post(Uri.parse(appBaseUrl + uri),
          headers: {
            'Content-Type': 'application/json',
            'Authorization': 'Token $token'
          }).timeout(Duration(seconds: timeoutInSeconds));
      return parseResponse(response, uri);
    } catch (e) {
      return const Response(statusCode: 1, statusText: connectionIssue);
    }
  }

  Response parseResponse(http.Response res, String uri) {
    dynamic body;
    try {
      body = jsonDecode(res.body);
    } catch (e) {
      e;
    }
    Response response = Response(
      body: body != '' ? body : res.body,
      bodyString: res.body.toString(),
      headers: res.headers,
      statusCode: res.statusCode,
      statusText: res.reasonPhrase,
    );
    if (response.statusCode != 200 &&
        response.body != null &&
        response.body is! String) {
      if (response.body.toString().startsWith('{errors: [{code:')) {
        response = Response(
            statusCode: response.statusCode,
            body: response.body,
            statusText: 'error');
      } else if (response.body.toString().startsWith('{message')) {
        response = Response(
            statusCode: response.statusCode,
            body: response.body,
            statusText: response.body['message']);
      }
    } else if (response.statusCode != 200 && response.body == null) {
      response = const Response(statusCode: 0, statusText: connectionIssue);
    }
    return response;
  }
}

class MultipartBody {
  String key;
  XFile file;

  MultipartBody(this.key, this.file);
}
