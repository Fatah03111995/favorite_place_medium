import 'package:favorite_place_medium/screens/places_add.dart';
import 'package:favorite_place_medium/widgets/places_list.dart';
import 'package:flutter/material.dart';

class PlacesMainPage extends StatelessWidget {
  const PlacesMainPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Your places'),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const PlacesAddPage()));
            },
            icon: const Icon(Icons.add),
          )
        ],
      ),
      body: PlacesList(),
    );
  }
}
