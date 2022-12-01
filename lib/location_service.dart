import 'package:flutter/material.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart' as http;
import 'dart:convert' as convert;

class LocationService {
  final String key = 'AIzaSyC5Jx_JfDJAfEbo5clHabVZizgHsOGu2rM';

  Future<String> getPlaceId(String input) async {
    final String url =
        'https://maps.googleapis.com/maps/api/place/findplacefromtext/json?input=$input&inputtype=textquery&key=$key';
    var response = await http.get(Uri.parse(url));

    var json = convert.jsonDecode(response.body);

    var placeId = json['candidates'][0]['place_id'] as String;

    return placeId;
  }

  Future<Map<String, dynamic>> getPlace(String input) async {
    final placeId = await getPlaceId(input);
    final String url =
        'https://maps.googleapis.com/maps/api/place/details/json?place_id=$placeId&key=$key';

    var response = await http.get(Uri.parse(url));

    var json = convert.jsonDecode(response.body);
    var results = json['result'] as Map<String, dynamic>;

    return results;
  }

  Future<Map<String, dynamic>> getDirections(
      String origin, String destination, String mode) async {
    final String url =
        'https://maps.googleapis.com/maps/api/directions/json?origin=$origin&destination=$destination&key=$key&mode=$mode';

    var response = await http.get(Uri.parse(url));
    var json = convert.jsonDecode(response.body);
    var results = {
      'bounds_ne': json['routes'][0]['bounds']['northeast'],
      'bounds_sw': json['routes'][0]['bounds']['southwest'],
      'start_location': json['routes'][0]['legs'][0]['start_location'],
      'end_location': json['routes'][0]['legs'][0]['end_location'],
      'polyline': json['routes'][0]['overview_polyline']['points'],
      'polyline_decoded': PolylinePoints()
          .decodePolyline(json['routes'][0]['overview_polyline']['points'])
    };

    return results;
  }

  Future<Map<String, dynamic>> getDirectionLength(
      String origin, String destination) async {
    final String url =
        'https://maps.googleapis.com/maps/api/distancematrix/json?destinations=$destination&origins=$origin&units=metric&key=$key';

    // 'https://maps.googleapis.com/maps/api/distancematrix/json?destinations=$destination&origins=$origin&units=metric&key=$key';

    var response = await http.get(Uri.parse(url));
    var json = convert.jsonDecode(response.body);

    var result = {
      'length': json['rows'][0]['elements'][0]['distance']['value'],
    };

    return result;
  }
}
