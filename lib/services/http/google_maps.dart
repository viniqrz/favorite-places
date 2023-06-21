import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';

class GoogleMapsService {
  static final apiKey = dotenv.env['GOOGLE_API_KEY'];

  static Future<String> getCoordsAddress(double lat, double lng) async {
    final url = Uri.parse(
        'https://maps.googleapis.com/maps/api/geocode/json?latlng=$lat,$lng&key=$apiKey');
    final response = await http.get(url);
    final data = jsonDecode(response.body);
    return data['results'][0]['formatted_address'];
  }
}
