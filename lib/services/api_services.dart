import 'dart:convert' as convert;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;
import '../utils/error_model.dart';

final apiServiceProvider = Provider((ref) => ApiServices());

class ApiServices {
  final _client = http.Client();

  Future<ErrorModel> postReq(
      {required Map<String, dynamic> body, required String url}) async {
    ErrorModel errorModel = ErrorModel(message: 'Unknown Error has occured');
    http.Response? response;
    try {
      response = await _client.post(
        Uri.parse(url),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: convert.jsonEncode(body),
      );
    } catch (e) {
      errorModel = ErrorModel(message: e.toString());
      return errorModel;
    }

    final data = convert.jsonDecode(response.body) as Map<String, dynamic>;
    if (response.statusCode == 200) {
      errorModel = ErrorModel(data: data);
    } else {
      errorModel =
          ErrorModel(message: data['message'] ?? 'Unknown Error has occured');
    }
    return errorModel;
  }
}
