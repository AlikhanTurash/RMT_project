// SafeArea(
//   child: Column(
//     children: [
//       // Container(
//       //   width: MediaQuery.of(context).size.width / 1.1,
//       //   height: MediaQuery.of(context).size.height / 6.7,
//       //   decoration: BoxDecoration(
//       //       color: Colors.white,
//       //       borderRadius: BorderRadius.all(Radius.circular(20))),
//       //   child: Padding(
//       //     padding: const EdgeInsets.all(8.0),
//       //     child: Row(
//       //       children: [
//       //         Expanded(
//       //           child: Column(
//       //             children: [
//       //               TextFormField(
//       //                 controller: _originController,
//       //                 textCapitalization: TextCapitalization.words,
//       //                 decoration: InputDecoration(hintText: 'Origin'),
//       //                 onChanged: (value) {},
//       //               ),
//       //               TextFormField(
//       //                 controller: _destinationController,
//       //                 textCapitalization: TextCapitalization.words,
//       //                 decoration:
//       //                     InputDecoration(hintText: 'Destination'),
//       //                 onChanged: (value) {},
//       //               ),
//       //             ],
//       //           ),
//       //         ),
//       //         IconButton(
//       //           onPressed: () async {
//       //             _polylines.clear();
//       //
//       //             int lastStopIndex =
//       //                 await _findClosestStop(_originController.text);
//       //             int firstStopIndex = await _findClosestStop(
//       //                 _destinationController.text);
//       //
//       //             print(firstStopIndex);
//       //             print(lastStopIndex);
//       //
//       //             _polylines.remove(context);
//       //
//       //             var directions = await LocationService()
//       //                 .getDirections(
//       //                     _originController.text,
//       //                     bicycleStops[firstStopIndex]
//       //                             .position
//       //                             .latitude
//       //                             .toString() +
//       //                         ',' +
//       //                         bicycleStops[firstStopIndex]
//       //                             .position
//       //                             .longitude
//       //                             .toString(),
//       //                     'walking');
//       //             _setPolyline(
//       //                 directions['polyline_decoded'], Colors.blue);
//       //             var directions2 = await LocationService()
//       //                 .getDirections(
//       //                     bicycleStops[firstStopIndex]
//       //                             .position
//       //                             .latitude
//       //                             .toString() +
//       //                         ',' +
//       //                         bicycleStops[firstStopIndex]
//       //                             .position
//       //                             .longitude
//       //                             .toString(),
//       //                     bicycleStops[lastStopIndex]
//       //                             .position
//       //                             .latitude
//       //                             .toString() +
//       //                         ',' +
//       //                         bicycleStops[lastStopIndex]
//       //                             .position
//       //                             .longitude
//       //                             .toString(),
//       //                     'driving');
//       //             _setPolyline(directions2['polyline_decoded'],
//       //                 Colors.pinkAccent);
//       //             var directions3 = await LocationService()
//       //                 .getDirections(
//       //                     bicycleStops[lastStopIndex]
//       //                             .position
//       //                             .latitude
//       //                             .toString() +
//       //                         ',' +
//       //                         bicycleStops[lastStopIndex]
//       //                             .position
//       //                             .longitude
//       //                             .toString(),
//       //                     _destinationController.text,
//       //                     'walking');
//       //             _setPolyline(
//       //                 directions3['polyline_decoded'], Colors.blue);
//       //             // focusing the camera to the whole route
//       //             _goToPlace(
//       //                 directions['start_location']['lat'],
//       //                 directions['start_location']['lng'],
//       //                 directions['bounds_ne'],
//       //                 directions['bounds_sw']);
//       //           },
//       //           icon: Icon(Icons.search),
//       //         )
//       //       ],
//       //     ),
//       //   ),
//       // ),
//     ],
//   ),
// ),