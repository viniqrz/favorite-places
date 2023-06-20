import 'dart:io';

import 'package:favorite_places/model/place.dart';
import 'package:flutter/material.dart';

class PlaceDetails extends StatelessWidget {
  const PlaceDetails({super.key, required this.place});

  final Place place;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(place.name),
      ),
      body: Column(
        children: [
          place.imagePath != null
              ? Image.file(
                  File(place.imagePath!),
                  width: MediaQuery.of(context).size.width,
                  height: MediaQuery.of(context).size.width * (3 / 4),
                  fit: BoxFit.cover,
                )
              : Container(),
          const SizedBox(
            height: 16,
          ),
          Text(
            place.name,
            style: Theme.of(context).textTheme.titleMedium!.copyWith(
                  color: Theme.of(context).colorScheme.onBackground,
                ),
          ),
          const SizedBox(
            height: 16,
          ),
          Text(
            'Latitude: ${place.lat}',
            style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                  color: Theme.of(context).colorScheme.onBackground,
                ),
          ),
          const SizedBox(
            height: 8,
          ),
          Text(
            'Longitude: ${place.lng}',
            style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                  color: Theme.of(context).colorScheme.onBackground,
                ),
          ),
        ],
      ),
    );
  }
}
