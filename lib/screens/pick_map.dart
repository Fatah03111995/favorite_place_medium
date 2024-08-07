import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';

class PickMap extends StatefulWidget {
  final LatLng initial;
  const PickMap({
    super.key,
    required this.initial,
  });

  @override
  State<PickMap> createState() => _PickMapState();
}

class _PickMapState extends State<PickMap> {
  late double lat;
  late double lon;

  @override
  void initState() {
    lat = widget.initial.latitude;
    lon = widget.initial.longitude;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Select Map'),
        actions: [
          IconButton(
              onPressed: () {
                Navigator.pop<LatLng>(context, LatLng(lat, lon));
              },
              icon: const Icon(Icons.save))
        ],
      ),
      body: FlutterMap(
        options: MapOptions(
          onTap: (tapPosition, latln) {
            setState(() {
              lat = latln.latitude;
              lon = latln.longitude;
            });
          },
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
        ],
      ),
    );
  }
}
