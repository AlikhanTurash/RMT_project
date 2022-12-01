import 'dart:async';
import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:google_maps_app/location_service.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class MapSample extends StatefulWidget {
  @override
  State<MapSample> createState() => MapSampleState();
}

class MapSampleState extends State<MapSample> {
  Completer<GoogleMapController> _controller = Completer();

  TextEditingController _originController = TextEditingController();
  TextEditingController _destinationController = TextEditingController();

  Set<Marker> _markers = Set<Marker>();
  Set<Polyline> _polylines = Set<Polyline>();
  List<Marker> _bicycleStops = [
    Marker(markerId: MarkerId('stop1'), position: LatLng(55.762292, 37.601592)),
    Marker(markerId: MarkerId('stop2'), position: LatLng(55.764586, 37.645235)),
    Marker(markerId: MarkerId('stop3'), position: LatLng(55.748793, 37.636734)),
    Marker(markerId: MarkerId('stop4'), position: LatLng(55.738441, 37.617972)),
    Marker(markerId: MarkerId('stop5'), position: LatLng(55.743318, 37.652758)),
    Marker(markerId: MarkerId('stop6'), position: LatLng(55.745032, 37.595136))
  ];
  int _polylineIdCounter = 1;

  static final CameraPosition _moscow = CameraPosition(
    target: LatLng(55.751244, 37.618423),
    zoom: 12,
  );

  @override
  void initState() {
    super.initState();
    for (int i = 0; i < 6; i++) {
      _setMarker(_bicycleStops[i].position);
    }
  }

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
          Expanded(
            child: GoogleMap(
              zoomControlsEnabled: false,
              polylines: _polylines,
              mapType: MapType.normal,
              initialCameraPosition: _moscow,
              onMapCreated: (GoogleMapController controller) {
                _controller.complete(controller);
              },
              markers: _markers,
            ),
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
                                    _bicycleStops[firstStopIndex]
                                            .position
                                            .latitude
                                            .toString() +
                                        ',' +
                                        _bicycleStops[firstStopIndex]
                                            .position
                                            .longitude
                                            .toString(),
                                    'walking');
                            _setPolyline(
                                directions['polyline_decoded'], Colors.blue);
                            var directions2 = await LocationService()
                                .getDirections(
                                    _bicycleStops[firstStopIndex]
                                            .position
                                            .latitude
                                            .toString() +
                                        ',' +
                                        _bicycleStops[firstStopIndex]
                                            .position
                                            .longitude
                                            .toString(),
                                    _bicycleStops[lastStopIndex]
                                            .position
                                            .latitude
                                            .toString() +
                                        ',' +
                                        _bicycleStops[lastStopIndex]
                                            .position
                                            .longitude
                                            .toString(),
                                    'driving');
                            _setPolyline(directions2['polyline_decoded'],
                                Colors.pinkAccent);
                            var directions3 = await LocationService()
                                .getDirections(
                                    _bicycleStops[lastStopIndex]
                                            .position
                                            .latitude
                                            .toString() +
                                        ',' +
                                        _bicycleStops[lastStopIndex]
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

  Future<int> _findClosestStop(String point) async {
    var res = [0, 0, 0, 0, 0, 0];
    for (int i = 0; i < 6; i++) {
      var a = await LocationService().getDirectionLength(
        point,
        _bicycleStops[i].position.latitude.toString() +
            ',' +
            _bicycleStops[i].position.longitude.toString(),
      );
      res[i] = a['length'];
      // print(res[i]);
    }
    // for (int i = 0; i < 6; i++) {
    //   res[i] = temp[i]['length'];
    // }
    int min = res.reduce((curr, next) => curr > next ? curr : next);
    // print(res.indexOf(min));
    // return res.indexOf(min);
    return res.indexOf(min);
  }

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

  Future<void> _goToPlace(double lat, double lng, Map<String, dynamic> boundsNe,
      Map<String, dynamic> boundsSw) async {
    // final double lat = place['geometry']['location']['lat'];
    // final double lng = place['geometry']['location']['lng'];
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
