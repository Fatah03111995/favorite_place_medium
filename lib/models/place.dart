// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:io';

import 'package:uuid/uuid.dart';

import 'package:favorite_place_medium/models/location_place.dart';

const uuid = Uuid();

class Place {
  final String id;
  final String title;
  final File fileImage;
  final LocationPlace locationPlaceData;
  Place({
    required this.title,
    required this.fileImage,
    required this.locationPlaceData,
  }) : id = uuid.v4();

  @override
  String toString() => 'Place(id: $id, title: $title, fileImage: $fileImage)';
}
