import 'dart:io';

import 'package:favorite_place_medium/models/location_place.dart';
import 'package:favorite_place_medium/models/place.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sqflite/sqflite.dart' as sql;
import 'package:path_provider/path_provider.dart' as syspath;
import 'package:path/path.dart' as path;

class UserPlacesNotifier extends StateNotifier<List<Place>> {
  UserPlacesNotifier() : super(const []);

  Future<sql.Database> _getDb() async {
    final dbPath = await sql.getDatabasesPath();
    return await sql.openDatabase(
      path.join(dbPath, 'places.db'),
      onCreate: (db, version) {
        return db.execute(
            'CREATE TABLE user_places (id TEXT PRIMARYKEY, title TEXT, image TEXT, lat REAL, lon REAL, address TEXT)');
      },
      version: 1,
    );
  }

  Future<void> loadData() async {
    final db = await _getDb();
    final response = await db.query('user_places');
    final places = response.map((item) {
      return Place(
          id: item['id'] as String,
          title: item['title'] as String,
          fileImage: File(item['image'] as String),
          locationPlaceData: LocationPlace(
              latitude: item['lat'] as double,
              longitude: item['lon'] as double,
              address: item['address'] as String));
    }).toList();

    state = places;
  }

  void addPlace(
      String title, File fileImage, LocationPlace locationPlaceData) async {
    final appDir = await syspath.getApplicationDocumentsDirectory();
    final fileName = path.basename(fileImage.path);
    final newPath = path.join(appDir.path, fileName);
    final copiedImage = await fileImage.copy(newPath);

    final newPlace = Place(
        title: title,
        fileImage: copiedImage,
        locationPlaceData: locationPlaceData);

    final db = await _getDb();
    db.insert('user_places', {
      'id': newPlace.id,
      'title': newPlace.title,
      'image': newPlace.fileImage.path,
      'lat': newPlace.locationPlaceData.latitude,
      'lon': newPlace.locationPlaceData.longitude,
      'address': newPlace.locationPlaceData.address
    });
    state = [newPlace, ...state];
  }
}

final userPlacesProvider =
    StateNotifierProvider<UserPlacesNotifier, List<Place>>((ref) {
  return UserPlacesNotifier();
});
