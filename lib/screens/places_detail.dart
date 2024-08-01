import 'package:favorite_place_medium/models/place.dart';
import 'package:flutter/material.dart';

class PlacesDetailPage extends StatelessWidget {
  final Place place;
  const PlacesDetailPage({super.key, required this.place});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(place.title),
      ),
      body: Center(
        child: Text(place.title),
      ),
    );
  }
}
