import 'dart:convert';
import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';

import 'package:http/http.dart';

class NetworkHelper {
  final String url;

  NetworkHelper({required this.url});

  Future<Either<Map<String, dynamic>, FlutterError>> getData() async {
    Response response = await get(
      Uri.parse(url),
    );

    if (response.statusCode == 200) {
      return Left(jsonDecode(response.body));
    } else {
      FlutterError error;
      switch (response.statusCode) {
        // Unauthorized request due to lack of API key attached in request
        case 401:
          error = FlutterError(
              'Client did not provide a valid API key to OpenWeatherMap');
          break;
        // Invalid request possibly due to wrong URL or unknown resource access
        case 404:
          error =
              FlutterError('Client sent an invalid request to OpenWeatherMap.');
          break;
        // Fallback
        default:
          error = FlutterError(
              'Unhandled exception thrown with status code ${response.statusCode}');
      }
      return Right(error);
    }
  }
}
