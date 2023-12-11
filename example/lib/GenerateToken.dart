import 'dart:convert';
import 'package:http/http.dart' as http;

Future<String> generateToken() async {
  final body = jsonEncode({
    'apiKey': "{your-api-key}",
  });

  var url = 'https://api.sariska.io/api/v1/misc/generate-token';
  Uri uri = Uri.parse(url);

  try {
    final response = await http.post(
      uri,
      headers: {"Content-Type": "application/json"},
      body: body,
    );

    print('Response status code: ${response.statusCode}');
    print('Response body: ${response.body}');

    if (response.statusCode == 200) {
      // If the server returned a 200 OK response, parse the JSON.
      var responseBody = jsonDecode(response.body);
      print(responseBody);
      return responseBody['token'];
    } else {
      // If the server did not return a 200 OK response, throw an exception.
      throw Exception(
          'Failed to generate token. Status code: ${response.statusCode}');
    }
  } catch (e) {
    // Handle exceptions thrown during the request (e.g., network issues).
    print('Exception during request: $e');
    throw Exception('Failed to generate token. Check your network connection.');
  }
}
