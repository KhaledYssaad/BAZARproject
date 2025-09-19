import 'package:http/http.dart' as http;
import 'dart:convert';

const String APIkey = "a6c9c09f9205ab32755a8c9c8a0e7cde";

Future<Map<String, double>?> getCoordinatesFromAPI(String location) async {
  try {
    final geoUrl = Uri.https(
      'api.openweathermap.org',
      '/geo/1.0/direct',
      {
        'q': location,
        'limit': '1',
        'appid': APIkey,
      },
    );

    final response = await http.get(geoUrl);
    if (response.statusCode != 200) return null;

    final data = json.decode(response.body) as List<dynamic>;
    if (data.isEmpty) return null;

    return {
      'lat': data[0]['lat'],
      'lon': data[0]['lon'],
    };
  } catch (e) {
    return null;
  }
}
