import 'package:favorite_place_medium/models/place.dart';
import 'package:favorite_place_medium/screens/pick_map.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';

class PlacesDetailPage extends StatelessWidget {
  final Place place;
  const PlacesDetailPage({super.key, required this.place});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          place.title,
          style: const TextStyle(color: Colors.white),
        ),
      ),
      body: Stack(
        children: [
          Image.file(
            place.fileImage,
            width: double.infinity,
            height: double.infinity,
            fit: BoxFit.cover,
          ),
          GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => PickMap(
                    initial: LatLng(place.locationPlaceData.latitude,
                        place.locationPlaceData.latitude),
                  ),
                ),
              );
            },
            child: Align(
                alignment: Alignment.bottomCenter,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      width: 200,
                      height: 200,
                      clipBehavior: Clip.hardEdge,
                      decoration: const BoxDecoration(shape: BoxShape.circle),
                      child: FlutterMap(
                        options: MapOptions(
                          initialCenter: LatLng(
                              place.locationPlaceData.latitude,
                              place.locationPlaceData.latitude),
                          initialZoom: 15,
                        ),
                        children: [
                          TileLayer(
                            urlTemplate:
                                'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                            userAgentPackageName: 'com.example.app',
                          ),
                          MarkerLayer(
                            markers: [
                              Marker(
                                  point: LatLng(
                                      place.locationPlaceData.latitude,
                                      place.locationPlaceData.latitude),
                                  child: const Icon(
                                    Icons.location_pin,
                                    size: 40,
                                    color: Colors.red,
                                  ))
                            ],
                          ),
                        ],
                      ),
                    ),
                    Container(
                      margin: const EdgeInsets.only(bottom: 50),
                      decoration: const BoxDecoration(
                        gradient: LinearGradient(
                          colors: [Colors.transparent, Colors.black54],
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                        ),
                      ),
                      child: Text(
                        place.locationPlaceData.data['display_name'],
                        style: Theme.of(context).textTheme.titleMedium!,
                      ),
                    )
                  ],
                )),
          ),
        ],
      ),
    );
  }
}
