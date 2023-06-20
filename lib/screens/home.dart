import 'package:favorite_places/providers/places.dart';
import 'package:favorite_places/screens/create_place.dart';
import 'package:favorite_places/widgets/place_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class Home extends ConsumerStatefulWidget {
  const Home({super.key});

  @override
  ConsumerState<Home> createState() => _HomeState();
}

class _HomeState extends ConsumerState<Home> {
  // @override
  // void initState() {
  //   super.initState();
  //   // "ref" can be used in all life-cycles of a StatefulWidget.
  //   // ref.read(placesProvider);
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Your Places'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => const CreatePlace(),
                ),
              );
            },
          ),
        ],
      ),
      body: PlaceList(),
    );
  }
}
