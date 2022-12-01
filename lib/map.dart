import 'dart:async';

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
    _setMarker(LatLng(55.762292, 37.601592));
    _setMarker(LatLng(55.764586, 37.645235));
    _setMarker(LatLng(55.748793, 37.636734));
    _setMarker(LatLng(55.738441, 37.617972));
    _setMarker(LatLng(55.743318, 37.652758));
    _setMarker(LatLng(55.745032, 37.595136));
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
      appBar: AppBar(title: Text('ProductFit Map'), centerTitle: true),
      body: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: Column(
                  children: [
                    TextFormField(
                      controller: _originController,
                      textCapitalization: TextCapitalization.words,
                      decoration: InputDecoration(hintText: 'Origin'),
                      onChanged: (value) {
                        print(value);
                      },
                    ),
                    TextFormField(
                      controller: _destinationController,
                      textCapitalization: TextCapitalization.words,
                      decoration: InputDecoration(hintText: 'Destination'),
                      onChanged: (value) {
                        print(value);
                      },
                    ),
                  ],
                ),
              ),
              IconButton(
                onPressed: () async {
                  var directions = await LocationService()
                      .getDirections(_originController.text, 'Polyanka');
                  _setPolyline(directions['polyline_decoded'], Colors.blue);
                  var directions2 = await LocationService()
                      .getDirections('Polyanka', 'Bolshoi Theatre');
                  _setPolyline(
                      directions2['polyline_decoded'], Colors.pinkAccent);
                  var directions3 = await LocationService().getDirections(
                      'Bolshoi Theatre', _destinationController.text);
                  _setPolyline(directions3['polyline_decoded'], Colors.blue);
                  //focusing the camera to the whole route
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
        ],
      ),
    );
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
