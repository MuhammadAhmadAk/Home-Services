import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:home_services/Utils/constants/api_const.dart';
import 'package:location/location.dart';

class ViewCustomer extends StatefulWidget {
  final double targetLat;
  final double targetLng;

  const ViewCustomer({
    Key? key,
    required this.targetLat,
    required this.targetLng,
  }) : super(key: key);

  @override
  _ViewCustomerState createState() => _ViewCustomerState();
}

class _ViewCustomerState extends State<ViewCustomer> {
  late GoogleMapController _mapController;
  LatLng? _currentLocation;
  final Location _location = Location();
  List<LatLng> polylineCoordinates = [];
  final Dio _dio = Dio();
  final String googleAPIKey = MAP_APIKEY; // Replace with your API key

  @override
  void initState() {
    super.initState();
    _getCurrentLocation();

    // Start listening to live location changes
    _location.onLocationChanged.listen((locationData) {
      if (locationData != null) {
        setState(() {
          _currentLocation =
              LatLng(locationData.latitude!, locationData.longitude!);
        });

        // Update route whenever location changes
        _getDirections();
      }
    });
  }

  Future<void> _getCurrentLocation() async {
    final locationData = await _location.getLocation();
    setState(() {
      _currentLocation =
          LatLng(locationData.latitude!, locationData.longitude!);
    });

    // Fetch route from Google Directions API
    _getDirections();
  }

  Future<void> _getDirections() async {
    if (_currentLocation == null) return;

    final String url =
        'https://maps.googleapis.com/maps/api/directions/json?origin=${_currentLocation!.latitude},${_currentLocation!.longitude}&destination=${widget.targetLat},${widget.targetLng}&mode=driving&alternatives=true&key=$googleAPIKey';

    final response = await _dio.get(url);

    if (response.statusCode == 200) {
      final data = response.data;

      // Check if there are multiple routes and choose the shortest one
      var routes = data['routes'] as List;
      if (routes.isNotEmpty) {
        // Sort routes by distance (shortest first)
        routes.sort((a, b) => a['legs'][0]['distance']['value']
            .compareTo(b['legs'][0]['distance']['value']));

        // Take the shortest route (first one after sorting)
        final shortestRoute = routes[0];

        // Extract the polyline points from the shortest route
        final String encodedPolyline =
            shortestRoute['overview_polyline']['points'];
        polylineCoordinates = _decodePolyline(encodedPolyline);
        setState(() {});
      }
    }
  }

  // Decode the polyline string to LatLng
  List<LatLng> _decodePolyline(String encoded) {
    List<LatLng> polyline = [];
    int index = 0, len = encoded.length;
    int lat = 0, lng = 0;

    while (index < len) {
      int b, shift = 0, result = 0;
      do {
        b = encoded.codeUnitAt(index++) - 63;
        result |= (b & 0x1F) << shift;
        shift += 5;
      } while (b >= 0x20);
      int dlat = ((result & 1) != 0 ? ~(result >> 1) : (result >> 1));
      lat += dlat;

      shift = 0;
      result = 0;
      do {
        b = encoded.codeUnitAt(index++) - 63;
        result |= (b & 0x1F) << shift;
        shift += 5;
      } while (b >= 0x20);
      int dlng = ((result & 1) != 0 ? ~(result >> 1) : (result >> 1));
      lng += dlng;

      LatLng point = LatLng((lat / 1E5).toDouble(), (lng / 1E5).toDouble());
      polyline.add(point);
    }
    return polyline;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Location'),
      ),
      body: _currentLocation == null
          ? const Center(child: CircularProgressIndicator())
          : GoogleMap(
              initialCameraPosition: CameraPosition(
                target: _currentLocation!,
                zoom: 14.0,
              ),
              markers: _buildMarkers(),
              polylines: _buildPolylines(),
              onMapCreated: (controller) {
                _mapController = controller;
              },
            ),
    );
  }

  Set<Marker> _buildMarkers() {
    Set<Marker> markers = {};

    // Marker for current location
    if (_currentLocation != null) {
      markers.add(
        Marker(
          markerId: const MarkerId('currentLocation'),
          position: _currentLocation!,
          infoWindow: const InfoWindow(title: 'Current Location'),
        ),
      );
    }

    // Marker for the target location
    markers.add(
      Marker(
        markerId: const MarkerId('targetLocation'),
        position: LatLng(widget.targetLat, widget.targetLng),
        infoWindow: const InfoWindow(title: 'Target Location'),
      ),
    );

    return markers;
  }

  Set<Polyline> _buildPolylines() {
    Set<Polyline> polylines = {};

    if (polylineCoordinates.isNotEmpty) {
      polylines.add(
        Polyline(
          polylineId: const PolylineId('route'),
          points: polylineCoordinates,
          color: Colors.blue, // Customize the color of the polyline
          width: 5, // Customize the thickness of the polyline
        ),
      );
    }

    return polylines;
  }
}
