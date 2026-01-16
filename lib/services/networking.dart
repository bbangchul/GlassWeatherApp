import 'package:http/http.dart' as http;
import 'dart:convert';

class NetworkHelper {
  NetworkHelper(this.host, this.path, this.queryParameters);

  final String host;
  final String path;
  final Map<String, String> queryParameters;

  Future<dynamic> getData() async {
    final Uri uri = Uri.https(host, path, queryParameters);
    final http.Response response = await http.get(uri);

    if (response.statusCode == 200) {
      String data = response.body;

      var decodedData = jsonDecode(data);

      return jsonDecode(data);
    } else {
      print(response.statusCode);
      print(response.body);
    }
  }
}
