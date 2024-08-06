import 'dart:io';

import 'package:favorite_place_medium/models/location_place.dart';
import 'package:favorite_place_medium/models/place.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class UserPlacesNotifier extends StateNotifier<List<Place>> {
  UserPlacesNotifier() : super(const []);

  void addPlace(String title, File fileImage, LocationPlace locationPlaceData) {
    final newPlace = Place(
        title: title,
        fileImage: fileImage,
        locationPlaceData: locationPlaceData);
    state = [newPlace, ...state];
  }
}

final userPlacesProvider =
    StateNotifierProvider<UserPlacesNotifier, List<Place>>((ref) {
  return UserPlacesNotifier();
});
