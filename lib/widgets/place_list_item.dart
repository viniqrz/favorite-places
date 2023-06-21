import 'package:favorite_places/model/place.dart';
import 'package:favorite_places/providers/places.dart';
import 'package:favorite_places/screens/place_details.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

enum MenuOption { edit, delete }

class PlaceListItem extends ConsumerWidget {
  const PlaceListItem({super.key, required this.place});

  final Place place;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Dismissible(
      confirmDismiss: (direction) {
        return showDialog<bool>(
          context: context,
          builder: (context) {
            return AlertDialog(
              title: const Text('Delete Place'),
              content:
                  const Text('Are you sure you want to delete this place?'),
              actions: [
                TextButton(
                  onPressed: () {
                    return Navigator.of(context).pop(false);
                  },
                  child: const Text('No', style: TextStyle(color: Colors.blue)),
                ),
                TextButton(
                  onPressed: () {
                    ref.read(placesProvider.notifier).removePlace(place);
                    return Navigator.of(context).pop(true);
                  },
                  child: const Text('Yes', style: TextStyle(color: Colors.red)),
                ),
              ],
            );
          },
        );
      },
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
        trailing: PopupMenuButton<MenuOption>(
          // Callback that sets the selected popup menu item.
          onSelected: (MenuOption item) {},
          itemBuilder: (BuildContext context) => <PopupMenuEntry<MenuOption>>[
            const PopupMenuItem<MenuOption>(
              value: MenuOption.edit,
              child: Text('Edit'),
            ),
            const PopupMenuItem<MenuOption>(
              value: MenuOption.delete,
              child: Text('Delete'),
            ),
          ],
        ),
        title: Text(
          place.name,
          style: Theme.of(context).textTheme.titleLarge!.copyWith(
                color: Theme.of(context).colorScheme.onBackground,
              ),
        ),
        subtitle: Text(
          place.address.toString(),
          style: Theme.of(context).textTheme.titleSmall,
        ),
      ),
    );
  }
}
