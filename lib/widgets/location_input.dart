import 'dart:convert';

import 'package:favorite_place_medium/models/location_place.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
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

  void _getCurrentLocation() async {
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

    setState(() {
      _isGetLocation = true;
    });

    locationData = await location.getLocation();
    lat = locationData.latitude;
    lon = locationData.longitude;
    Uri url = Uri.parse(
        'https://nominatim.openstreetmap.org/reverse?format=json&lat=$lat&lon=$lon');
    final response = await http.get(url);

    widget.onSelectLocation(LocationPlace(
        latitude: lat!, longitude: lon!, data: jsonDecode(response.body)));
    setState(() {
      _isGetLocation = false;
    });
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

    Widget content = _isGetLocation
        ? const Center(
            child: CircularProgressIndicator(),
          )
        : lat == null || lon == null
            ? const Text(
                'No Location chosen',
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.white, fontSize: 12),
              )
            : runMap(lon!, lat!);

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
          child: content,
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
              onPressed: () {},
              icon: const Icon(Icons.map),
              label: const Text('Select on Map'),
            )
          ],
        ),
      ],
    );
  }
}
