import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';

class PickMap extends StatefulWidget {
  final LatLng initial;
  const PickMap({super.key, required this.initial});

  @override
  State<PickMap> createState() => _PickMapState();
}

class _PickMapState extends State<PickMap> {
  @override
  Widget build(BuildContext context) {
    LatLng initialVal = widget.initial;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Select Map'),
      ),
      body: FlutterMap(
        options: MapOptions(
          initialCenter: initialVal,
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
                  point: initialVal,
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
