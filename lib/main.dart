import 'package:favorite_place_medium/providers/user_places.dart';
import 'package:favorite_place_medium/screens/places_main.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:google_fonts/google_fonts.dart';

void main() {
  runApp(
    const ProviderScope(child: MyApp()),
  );
}

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.read(userPlacesProvider.notifier).loadData();
    return MaterialApp(
      title: 'Great Places',
      theme: ThemeData.dark().copyWith(
        textTheme: GoogleFonts.ubuntuCondensedTextTheme().copyWith(
          titleSmall: GoogleFonts.ubuntuCondensed(
              fontWeight: FontWeight.bold, color: Colors.white),
          titleMedium: GoogleFonts.ubuntuCondensed(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
          titleLarge: GoogleFonts.ubuntuCondensed(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      home: const PlacesMainPage(),
    );
  }
}
