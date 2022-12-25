import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:http/http.dart' as http;
import 'dart:convert' as convert;
import './constants.dart';

class LocationService {
  //Сервис для поиска проезда от origin до destination
  Future<Map<String, dynamic>> getDirections(
      String origin, String destination, String mode) async {
    //URL запрос
    final String url =
        'https://maps.googleapis.com/maps/api/directions/json?origin=$origin&destination=$destination&key=$key&mode=$mode';

    //Парсинг json-a
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

  Future<Map<String, dynamic>> getBuyerData(
      String origin, String destination, String mode) async {
    //URL запрос
    final String url =
        'https://maps.googleapis.com/maps/api/directions/json?origin=$origin&destination=$destination&key=$key&mode=$mode';

    //Парсинг json-a
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

  //Сервис для определения длинны проезда от origin до destination
  //На выходе map со значением length
  Future<Map<String, dynamic>> getDirectionLength(
      String origin, String destination) async {
    //URL запрос
    final String url =
        'https://maps.googleapis.com/maps/api/distancematrix/json?destinations=$destination&origins=$origin&units=metric&key=$key';

    //Парсинг json-a
    var response = await http.get(Uri.parse(url));
    var json = convert.jsonDecode(response.body);

    var result = {
      'length': json['rows'][0]['elements'][0]['distance']['value'],
    };

    return result;
  }
}
