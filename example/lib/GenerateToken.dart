import 'dart:convert';
import 'package:http/http.dart' as http;

Future<String> generateToken() async {
  final body = jsonEncode({
    'apiKey': "27fd6f9e85c304447d3cc0fb31e7ba8062df58af86ac3f9437",
  });
  //final headers = {"Content-Type": "application/json"};
  var url = 'https://api.sariska.io/api/v1/misc/generate-token';
  Uri uri = Uri.parse(url);
  final response = await http.post(uri,
      headers: {"Content-Type": "application/json"}, body: body);
  if (response.statusCode == 200) {
    // If the server did return a 200 OK response,
    // then parse the JSON.
    var body = jsonDecode(response.body);
    print(body);
    return body['token'];
  } else {
    // If the server did not return a 200 OK response,
    // then throw an exception.
    throw Exception('Failed to load album');
  }
}
