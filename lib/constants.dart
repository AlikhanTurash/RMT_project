import 'package:google_maps_flutter/google_maps_flutter.dart';

//Рандомные стопы по Москве
List<Marker> bicycleStops = [
  Marker(markerId: MarkerId('stop1'), position: LatLng(55.762292, 37.601592)),
  Marker(markerId: MarkerId('stop2'), position: LatLng(55.764586, 37.645235)),
  Marker(markerId: MarkerId('stop3'), position: LatLng(55.748793, 37.636734)),
  Marker(markerId: MarkerId('stop4'), position: LatLng(55.738441, 37.617972)),
  Marker(markerId: MarkerId('stop5'), position: LatLng(55.743318, 37.652758)),
  Marker(markerId: MarkerId('stop6'), position: LatLng(55.745032, 37.595136))
];

//API ключ
final String key = 'AIzaSyC5Jx_JfDJAfEbo5clHabVZizgHsOGu2rM';
