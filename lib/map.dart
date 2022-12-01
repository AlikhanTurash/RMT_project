import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:google_maps_app/location_service.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import './constants.dart';

class MapSample extends StatefulWidget {
  @override
  State<MapSample> createState() => MapSampleState();
}

class MapSampleState extends State<MapSample> {
  //контроллер Гугл Карт
  Completer<GoogleMapController> _controller = Completer();

  //контроллеры текстфилдов
  TextEditingController _originController = TextEditingController();
  TextEditingController _destinationController = TextEditingController();

  //коллекции маркеров и полилайнов
  Set<Marker> _markers = Set<Marker>();
  Set<Polyline> _polylines = Set<Polyline>();

  //ID для полилайнов
  int _polylineIdCounter = 1;

  //Позиция камеры на москву при иницализации карты
  static final CameraPosition _moscow = CameraPosition(
    target: LatLng(55.751244, 37.618423),
    zoom: 12,
  );

  @override
  void initState() {
    super.initState();

    //Инизализация маркеров стопов
    for (int i = 0; i < 6; i++) {
      _setMarker(bicycleStops[i].position);
    }
  }

  //Функция установки маркера на карту
  void _setMarker(LatLng point) {
    setState(
      () {
        _markers.add(
          Marker(markerId: MarkerId('marker'), position: point),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      body: Stack(
        alignment: Alignment.center,
        children: [
          GoogleMap(
            zoomControlsEnabled: false,
            polylines: _polylines,
            mapType: MapType.normal,
            initialCameraPosition: _moscow,
            onMapCreated: (GoogleMapController controller) {
              _controller.complete(controller);
            },
            markers: _markers,
          ),
          SafeArea(
            child: Column(
              children: [
                Container(
                  width: MediaQuery.of(context).size.width / 1.1,
                  height: MediaQuery.of(context).size.height / 6.7,
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.all(Radius.circular(20))),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      children: [
                        Expanded(
                          child: Column(
                            children: [
                              TextFormField(
                                controller: _originController,
                                textCapitalization: TextCapitalization.words,
                                decoration: InputDecoration(hintText: 'Origin'),
                                onChanged: (value) {},
                              ),
                              TextFormField(
                                controller: _destinationController,
                                textCapitalization: TextCapitalization.words,
                                decoration:
                                    InputDecoration(hintText: 'Destination'),
                                onChanged: (value) {},
                              ),
                            ],
                          ),
                        ),
                        IconButton(
                          onPressed: () async {
                            _polylines.clear();

                            int lastStopIndex =
                                await _findClosestStop(_originController.text);
                            int firstStopIndex = await _findClosestStop(
                                _destinationController.text);

                            print(firstStopIndex);
                            print(lastStopIndex);

                            _polylines.remove(context);

                            var directions = await LocationService()
                                .getDirections(
                                    _originController.text,
                                    bicycleStops[firstStopIndex]
                                            .position
                                            .latitude
                                            .toString() +
                                        ',' +
                                        bicycleStops[firstStopIndex]
                                            .position
                                            .longitude
                                            .toString(),
                                    'walking');
                            _setPolyline(
                                directions['polyline_decoded'], Colors.blue);
                            var directions2 = await LocationService()
                                .getDirections(
                                    bicycleStops[firstStopIndex]
                                            .position
                                            .latitude
                                            .toString() +
                                        ',' +
                                        bicycleStops[firstStopIndex]
                                            .position
                                            .longitude
                                            .toString(),
                                    bicycleStops[lastStopIndex]
                                            .position
                                            .latitude
                                            .toString() +
                                        ',' +
                                        bicycleStops[lastStopIndex]
                                            .position
                                            .longitude
                                            .toString(),
                                    'driving');
                            _setPolyline(directions2['polyline_decoded'],
                                Colors.pinkAccent);
                            var directions3 = await LocationService()
                                .getDirections(
                                    bicycleStops[lastStopIndex]
                                            .position
                                            .latitude
                                            .toString() +
                                        ',' +
                                        bicycleStops[lastStopIndex]
                                            .position
                                            .longitude
                                            .toString(),
                                    _destinationController.text,
                                    'walking');
                            _setPolyline(
                                directions3['polyline_decoded'], Colors.blue);
                            // focusing the camera to the whole route
                            _goToPlace(
                                directions['start_location']['lat'],
                                directions['start_location']['lng'],
                                directions['bounds_ne'],
                                directions['bounds_sw']);
                          },
                          icon: Icon(Icons.search),
                        )
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  //Функция по поиску ближайшего стопа
  //На выходе индекс ближайшего стопа
  Future<int> _findClosestStop(String point) async {
    var res = [0, 0, 0, 0, 0, 0];
    for (int i = 0; i < 6; i++) {
      var a = await LocationService().getDirectionLength(
        point,
        bicycleStops[i].position.latitude.toString() +
            ',' +
            bicycleStops[i].position.longitude.toString(),
      );
      res[i] = a['length'];
    }

    int min = res.reduce((curr, next) => curr > next ? curr : next);

    return res.indexOf(min);
  }

  //Функция отрисовки Полилайнов
  void _setPolyline(List<PointLatLng> points, Color color) {
    final String polylineIdVal = 'polyline_$_polylineIdCounter';
    _polylineIdCounter++;
    _polylines.add(
      Polyline(
          polylineId: PolylineId(polylineIdVal),
          width: 2,
          color: color,
          points: points
              .map(
                (point) => LatLng(point.latitude, point.longitude),
              )
              .toList()),
    );
  }

  //Функция перемещения камеры с анимацией
  Future<void> _goToPlace(double lat, double lng, Map<String, dynamic> boundsNe,
      Map<String, dynamic> boundsSw) async {
    final GoogleMapController controller = await _controller.future;
    controller.animateCamera(
      CameraUpdate.newCameraPosition(
        CameraPosition(target: LatLng(lat, lng), zoom: 12),
      ),
    );

    controller.animateCamera(
      CameraUpdate.newLatLngBounds(
          LatLngBounds(
              southwest: LatLng(boundsSw['lat'], boundsSw['lng']),
              northeast: LatLng(boundsNe['lat'], boundsNe['lng'])),
          25),
    );
    _setMarker(LatLng(lat, lng));
  }
}
