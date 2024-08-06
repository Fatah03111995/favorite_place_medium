import 'dart:io';

import 'package:favorite_place_medium/models/location_place.dart';
import 'package:favorite_place_medium/providers/user_places.dart';
import 'package:favorite_place_medium/widgets/image_input.dart';
import 'package:favorite_place_medium/widgets/location_input.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class PlacesAddPage extends ConsumerStatefulWidget {
  const PlacesAddPage({super.key});

  @override
  ConsumerState<PlacesAddPage> createState() => _PlacesAddPageState();
}

class _PlacesAddPageState extends ConsumerState<PlacesAddPage> {
  final TextEditingController _titleController = TextEditingController();
  File? selectedImage;
  LocationPlace? locationPlace;

  void _safePlace() {
    final String enteredText = _titleController.value.text;

    if (enteredText.isEmpty || selectedImage == null || locationPlace == null) {
      return;
    }

    ref
        .read(userPlacesProvider.notifier)
        .addPlace(enteredText, selectedImage!, locationPlace!);
    Navigator.pop(context);
  }

  @override
  void dispose() {
    _titleController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Add New Place',
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(12),
        child: Column(
          children: [
            TextField(
              style: const TextStyle(color: Colors.white),
              decoration: const InputDecoration(labelText: 'Title'),
              controller: _titleController,
            ),
            const SizedBox(height: 16),
            ImageInput(
              onPickImage: (selectedImage) {
                this.selectedImage = selectedImage;
              },
            ),
            const SizedBox(height: 16),
            LocationInput(
              onSelectLocation: (data) {
                locationPlace = data;
              },
            ),
            const SizedBox(height: 16),
            ElevatedButton.icon(
                onPressed: () {
                  _safePlace();
                },
                icon: const Icon(Icons.add),
                label: const Text(
                  'Add Place',
                  style: TextStyle(color: Colors.white),
                )),
          ],
        ),
      ),
    );
  }
}
