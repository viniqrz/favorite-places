import 'package:favorite_places/model/place.dart';
import 'package:favorite_places/widgets/empty_list.dart';
import 'package:favorite_places/widgets/place_list_item.dart';
import 'package:flutter/material.dart';

class PlaceList extends StatelessWidget {
  const PlaceList({super.key, required this.places});

  final List<Place> places;

  @override
  Widget build(BuildContext context) {
    if (places.isEmpty) return const EmptyList();

    return ListView.builder(
      itemCount: places.length,
      itemBuilder: (context, index) {
        return PlaceListItem(
          place: places[index],
        );
      },
      prototypeItem: PlaceListItem(
        place: places.first,
      ),
    );
  }
}
