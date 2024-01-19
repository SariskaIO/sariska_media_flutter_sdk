import 'dart:convert';
import 'package:http/http.dart' as http;

Future<String> generateToken() async {
  final body = jsonEncode({
    'apiKey': "{api-key}",
  });
  var url = 'https://api.sariska.io/api/v1/misc/generate-token';
  Uri uri = Uri.parse(url);
  final response = await http.post(uri,
      headers: {"Content-Type": "application/json"}, body: body);
  if (response.statusCode == 200) {
    var body = jsonDecode(response.body);
    return body['token'];
  } else {
    // If the server did not return a 200 OK response,
    // then throw an exception.
    throw Exception('Failed to load album');
  }
}
