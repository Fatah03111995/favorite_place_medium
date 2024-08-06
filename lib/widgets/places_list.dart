import 'package:favorite_place_medium/models/place.dart';
import 'package:favorite_place_medium/screens/places_detail.dart';
import 'package:flutter/material.dart';

class PlacesList extends StatelessWidget {
  final List<Place> places;
  const PlacesList({
    super.key,
    this.places = const [],
  });

  @override
  Widget build(BuildContext context) {
    if (places.isEmpty) {
      return const Center(
        child: Text(
          'No Places added yet',
          style: TextStyle(color: Colors.white),
        ),
      );
    }

    return ListView.builder(
      itemCount: places.length,
      itemBuilder: (context, index) {
        return ListTile(
          leading: CircleAvatar(
            backgroundImage: FileImage(places[index].fileImage),
            radius: 26,
          ),
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => PlacesDetailPage(
                  place: places[index],
                ),
              ),
            );
          },
          title: Text(places[index].title,
              style: Theme.of(context).textTheme.titleMedium!),
          subtitle: Text(places[index].locationPlaceData.data['display_name'],
              style: Theme.of(context).textTheme.titleSmall!),
        );
      },
    );
  }
}
