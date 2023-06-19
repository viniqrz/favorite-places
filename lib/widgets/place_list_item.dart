import 'package:favorite_places/model/place.dart';
import 'package:favorite_places/screens/place_details.dart';
import 'package:flutter/material.dart';

class PlaceListItem extends StatelessWidget {
  const PlaceListItem({super.key, required this.place});

  final Place place;

  @override
  Widget build(BuildContext context) {
    return Dismissible(
      key: ValueKey(place),
      child: ListTile(
        onTap: () => Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => PlaceDetails(
              place: place,
            ),
          ),
        ),
        contentPadding: const EdgeInsets.fromLTRB(16, 8, 0, 8),
        trailing: IconButton(
          icon: const Icon(Icons.more_vert),
          onPressed: () {},
        ),
        title: Text(
          place.name,
          style: Theme.of(context).textTheme.titleLarge!.copyWith(
                color: Theme.of(context).colorScheme.onBackground,
              ),
        ),
        subtitle: Text(
          '${place.lat}, ${place.lng}',
          style: Theme.of(context).textTheme.titleSmall,
        ),
      ),
    );
  }
}
