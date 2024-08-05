import 'package:favorite_place_medium/models/place.dart';
import 'package:flutter/material.dart';

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
          Center(
            child: Text(
              place.title,
              style: const TextStyle(fontSize: 30, color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }
}
