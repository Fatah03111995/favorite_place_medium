import 'dart:convert';

import 'package:favorite_place_medium/models/location_place.dart';
import 'package:favorite_place_medium/screens/pick_map.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:http/http.dart';
import 'package:latlong2/latlong.dart';
import 'package:location/location.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:http/http.dart' as http;

class LocationInput extends StatefulWidget {
  final void Function(LocationPlace) onSelectLocation;
  const LocationInput({super.key, required this.onSelectLocation});

  @override
  State<StatefulWidget> createState() {
    return _LocationInputState();
  }
}

class _LocationInputState extends State<LocationInput> {
  bool _isGetLocation = false;
  double? lon;
  double? lat;

  Future<void> _getLocation() async {
    Location location = Location();

    bool serviceEnabled;
    PermissionStatus permissionGranted;
    LocationData locationData;

    serviceEnabled = await location.serviceEnabled();
    if (!serviceEnabled) {
      serviceEnabled = await location.requestService();
      if (!serviceEnabled) {
        return;
      }
    }

    permissionGranted = await location.hasPermission();
    if (permissionGranted == PermissionStatus.denied) {
      permissionGranted = await location.requestPermission();
      if (permissionGranted != PermissionStatus.granted) {
        return;
      }
    }

    locationData = await location.getLocation();
    lat = locationData.latitude;
    lon = locationData.longitude;
  }

  Future<Response> _getData() async {
    Uri url = Uri.parse(
        'https://nominatim.openstreetmap.org/reverse?format=json&lat=$lat&lon=$lon');
    return await http.get(url);
  }

  void _getCurrentLocation() async {
    setState(() {
      _isGetLocation = true;
    });
    await _getLocation();
    final response = await _getData();
    widget.onSelectLocation(LocationPlace(
        latitude: lat!,
        longitude: lon!,
        address: jsonDecode(response.body)['display_name'] as String));
    setState(() {
      _isGetLocation = false;
    });
  }

  void _pickMap() async {
    await _getLocation();
    if (!mounted || lat == null || lon == null) {
      return;
    }
    LatLng update = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => PickMap(
          initial: LatLng(lat!, lon!),
        ),
      ),
    );

    setState(() {
      lat = update.latitude;
      lon = update.longitude;
    });

    final response = await _getData();
    widget.onSelectLocation(LocationPlace(
        latitude: lat!,
        longitude: lon!,
        address: jsonDecode(response.body)['display_name'] as String));
  }

  @override
  Widget build(BuildContext context) {
    Widget runMap(double lon, double lat) {
      return FlutterMap(
        options: MapOptions(
          initialCenter: LatLng(lat, lon),
          initialZoom: 15,
        ),
        children: [
          TileLayer(
            urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
            userAgentPackageName: 'com.example.app',
          ),
          MarkerLayer(
            markers: [
              Marker(
                  point: LatLng(lat, lon),
                  child: const Icon(
                    Icons.location_pin,
                    size: 40,
                    color: Colors.red,
                  ))
            ],
          ),
          RichAttributionWidget(
            attributions: [
              TextSourceAttribution(
                'OpenStreetMap contributors',
                onTap: () =>
                    launchUrl(Uri.parse('https://openstreetmap.org/copyright')),
              ),
            ],
          ),
        ],
      );
    }

    return Column(
      children: [
        Container(
          clipBehavior: Clip.hardEdge,
          height: 170,
          width: double.infinity,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            border: Border.all(
              width: 1,
              color: Theme.of(context).colorScheme.primary.withOpacity(0.2),
            ),
          ),
          child: _isGetLocation
              ? const Center(
                  child: CircularProgressIndicator(),
                )
              : lat == null || lon == null
                  ? const Text(
                      'No Location chosen',
                      textAlign: TextAlign.center,
                      style: TextStyle(color: Colors.white, fontSize: 12),
                    )
                  : runMap(lon!, lat!),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            TextButton.icon(
              onPressed: _getCurrentLocation,
              icon: const Icon(Icons.location_on),
              label: const Text('Get Current Location'),
            ),
            TextButton.icon(
              onPressed: _pickMap,
              icon: const Icon(Icons.map),
              label: const Text('Select on Map'),
            )
          ],
        ),
      ],
    );
  }
}
