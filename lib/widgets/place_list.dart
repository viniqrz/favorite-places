import 'package:favorite_places/providers/places.dart';
import 'package:favorite_places/widgets/empty_list.dart';
import 'package:favorite_places/widgets/place_list_item.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class PlaceList extends ConsumerWidget {
  const PlaceList({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final asyncPlaces = ref.watch(placesProvider);

    return asyncPlaces.when(
      data: (places) {
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
      },
      error: (err, trace) {
        print(err);
        print(trace);
        return const Text('error');
      },
      loading: () => Center(
        child: Text(
          'Loading...',
          style: Theme.of(context)
              .textTheme
              .titleLarge!
              .copyWith(color: Theme.of(context).colorScheme.onBackground),
        ),
      ),
    );
  }
}
