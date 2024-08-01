// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:io';

import 'package:uuid/uuid.dart';

const uuid = Uuid();

class Place {
  final String id;
  final String title;
  final File fileImage;
  Place({
    required this.title,
    required this.fileImage,
  }) : id = uuid.v4();

  @override
  String toString() => 'Place(id: $id, title: $title, fileImage: $fileImage)';
}
