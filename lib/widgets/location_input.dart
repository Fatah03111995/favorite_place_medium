import 'package:flutter/material.dart';
import 'package:location/location.dart';

class LocationInput extends StatefulWidget {
  const LocationInput({super.key});

  @override
  State<StatefulWidget> createState() {
    return _LocationInputState();
  }
}

class _LocationInputState extends State<LocationInput> {
  bool _isGetLocation = false;

  void _getCurrentLocation() async {
    Location location = Location();

    bool serviceEnabled;
    PermissionStatus permissionGranted;
    LocationData locationData;

    serviceEnabled = await location.serviceEnabled();
    if (!serviceEnabled) {
      serviceEnabled = await location.requestService();
      if (!serviceEnabled) {
        return;
      }
    }

    permissionGranted = await location.hasPermission();
    if (permissionGranted == PermissionStatus.denied) {
      permissionGranted = await location.requestPermission();
      if (permissionGranted != PermissionStatus.granted) {
        return;
      }
    }

    setState(() {
      _isGetLocation = true;
    });

    locationData = await location.getLocation();
    print({
      'acc': locationData.accuracy,
      'lat': locationData.latitude,
      'lon': locationData.longitude,
    });

    setState(() {
      _isGetLocation = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    Widget content = _isGetLocation
        ? const Center(
            child: CircularProgressIndicator(),
          )
        : const Text(
            'No Location chosen',
            textAlign: TextAlign.center,
            style: TextStyle(color: Colors.white, fontSize: 12),
          );

    return Column(
      children: [
        Container(
          clipBehavior: Clip.hardEdge,
          height: 170,
          width: double.infinity,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            border: Border.all(
              width: 1,
              color: Theme.of(context).colorScheme.primary.withOpacity(0.2),
            ),
          ),
          child: content,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            TextButton.icon(
              onPressed: _getCurrentLocation,
              icon: const Icon(Icons.location_on),
              label: const Text('Get Current Location'),
            ),
            TextButton.icon(
              onPressed: () {},
              icon: const Icon(Icons.map),
              label: const Text('Select on Map'),
            )
          ],
        ),
      ],
    );
  }
}
