import 'package:favorite_place_medium/providers/user_places.dart';
import 'package:favorite_place_medium/screens/places_add.dart';
import 'package:favorite_place_medium/widgets/places_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class PlacesMainPage extends ConsumerWidget {
  const PlacesMainPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userPlaces = ref.watch(userPlacesProvider);
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Your places',
          style: TextStyle(color: Colors.white),
        ),
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
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: PlacesList(
          places: userPlaces,
        ),
      ),
    );
  }
}
