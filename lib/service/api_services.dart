import 'dart:async';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'package:myraid_demo/themes/app_colors.dart';

import 'dart:convert';

import 'package:overlay_loading_progress/overlay_loading_progress.dart';

class ApiService {
  static String baseUrl = 'https://69a081e03188b0b1d538e92a.mockapi.io/taskmanager';
  static const int maxRetries = 3;
  static const Duration timeoutDuration = Duration(seconds: 10);

  static Future<dynamic> getRequest(
      String endpoint, BuildContext context, bool showLoader) async {
    return _retryRequest(() async {
      if (showLoader) {
        OverlayLoadingProgress.start(
          context,
          color: AppColors.primaryColor,
          barrierDismissible: false,
        );
      }

      final response = await http
          .get(Uri.parse('$baseUrl/$endpoint'))
          .timeout(timeoutDuration);
      OverlayLoadingProgress.stop();
      return _handleResponse(response);
    });
  }

  static Future<dynamic> postRequest(
      String endpoint, Map<String, dynamic> body, BuildContext context) async {
    return _retryRequest(() async {
      OverlayLoadingProgress.start(
        context,
        color: AppColors.primaryColor,
        barrierDismissible: false,
      );
      final response = await http
          .post(
            Uri.parse('$baseUrl/$endpoint'),
            headers: {"Content-Type": "application/json"},
            body: jsonEncode(body),
          )
          .timeout(timeoutDuration);
      OverlayLoadingProgress.stop();
      return _handleResponse(response);
    });
  }

  static Future<dynamic> putRequest(
      String endpoint, Map<String, dynamic> body, BuildContext context) async {
    return _retryRequest(() async {
      OverlayLoadingProgress.start(
        context,
        color: AppColors.primaryColor,
        barrierDismissible: false,
      );
      final response = await http
          .put(
            Uri.parse('$baseUrl/$endpoint'),
            headers: {"Content-Type": "application/json"},
            body: jsonEncode(body),
          )
          .timeout(timeoutDuration);
      OverlayLoadingProgress.stop();
      return _handleResponse(response);
    });
  }

  static Future<dynamic> deleteRequest(
      String endpoint, BuildContext context) async {
    return _retryRequest(() async {
      OverlayLoadingProgress.start(
        context,
        color: AppColors.primaryColor,
        barrierDismissible: false,
      );
      final response = await http
          .delete(Uri.parse('$baseUrl/$endpoint'))
          .timeout(timeoutDuration);
      OverlayLoadingProgress.stop();
      return _handleResponse(response);
    });
  }

  static Future<dynamic> _retryRequest(
      Future<dynamic> Function() request) async {
    int attempt = 0;

    while (attempt < maxRetries) {
      try {
        return await request();
      } on SocketException {
        attempt++;
        if (attempt >= maxRetries) {
          throw Exception("No Internet Connection");
        }
      } on TimeoutException {
        attempt++;
        if (attempt >= maxRetries) {
          throw Exception("Request Timeout. Please try again.");
        }
      } catch (e) {
        throw Exception("Unexpected Error: $e");
      }
    }
  }

  static dynamic _handleResponse(http.Response response) {
    final data = jsonDecode(response.body);

    switch (response.statusCode) {
      case 200:
      case 201:
        return data;

      case 400:
        throw Exception("Bad Request: ${data.toString()}");

      case 401:
        throw Exception("Unauthorized Access");

      case 404:
        throw Exception("Resource Not Found");

      case 500:
        throw Exception("Server Error. Try again later.");

      default:
        throw Exception("Error ${response.statusCode}: ${data.toString()}");
    }
  }
}
