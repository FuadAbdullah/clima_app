import 'dart:convert';

import 'package:http/http.dart';

class NetworkHelper {
  final String url;

  NetworkHelper({required this.url});

  Future getData() async {
    Response response = await get(
      Uri.parse(url),
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      print(response.statusCode);
      // TODO: Handle 404 error here
      // Maybe display a popup to tell the user something went wrong
    }
  }
}
