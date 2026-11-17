import 'dart:async';
import 'dart:convert';
import 'dart:developer' as developer;
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

import 'api_exception.dart';

class ApiClient {
  final http.Client _client;
  final String host;

  ApiClient(this._client, {this.host = 'jsonplaceholder.typicode.com'});

  Map<String, String> get headers {
    return {'Accept': 'application/json'};
  }

  Uri buildUri(String path, [Map<String, String>? queryParameters]) {
    return Uri.https(host, path, queryParameters);
  }

  Future<http.Response> _send(Future<http.Response> Function() call) async {
    try {
      final response = await call().timeout(const Duration(seconds: 10));

      if (kDebugMode) {
        developer.log(
          '${response.request?.method} '
          '${response.request?.url.path} '
          '→ ${response.statusCode}',
          name: 'api',
        );
      }

      return response;
    } on SocketException {
      throw const NoConnectionException();
    } on TimeoutException {
      throw const NoConnectionException();
    } on http.ClientException {
      throw const NoConnectionException();
    }
  }

  void _check(http.Response response) {
    if (response.statusCode == 401) {
      throw const UnauthorizedException();
    }

    if (response.statusCode == 404) {
      throw const NotFoundException();
    }

    if (response.statusCode >= 500) {
      throw ServerException(response.statusCode);
    }
  }

  dynamic _decode(http.Response response) {
    try {
      return jsonDecode(response.body);
    } on FormatException {
      throw const BadResponseException('Invalid JSON response');
    }
  }

  Future<dynamic> get(
    String path, {
    Map<String, String>? queryParameters,
  }) async {
    final uri = buildUri(path, queryParameters);

    final response = await _send(() => _client.get(uri, headers: headers));

    _check(response);

    if (response.statusCode != 200) {
      throw BadResponseException(
        'Unexpected GET status: ${response.statusCode}',
      );
    }

    return _decode(response);
  }

  Future<dynamic> post(String path, Map<String, dynamic> data) async {
    final uri = buildUri(path);

    final requestHeaders = {...headers, 'Content-Type': 'application/json'};

    final response = await _send(
      () => _client.post(uri, headers: requestHeaders, body: jsonEncode(data)),
    );

    _check(response);

    if (response.statusCode != 201) {
      throw BadResponseException(
        'Unexpected POST status: ${response.statusCode}',
      );
    }

    return _decode(response);
  }
}
