import 'package:favorite_places/model/place.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class PlacesNotifier extends StateNotifier<List<Place>> {
  PlacesNotifier()
      : super([
          Place(lat: 10, lng: 11, name: 'Place 1'),
          Place(lat: 10, lng: 11, name: 'Place 2'),
          Place(lat: 10, lng: 11, name: 'Place 3'),
          Place(lat: 10, lng: 11, name: 'Place 4'),
          Place(lat: 10, lng: 11, name: 'Place '),
        ]);

  void addPlace(Place place) {
    state = [...state, place];
  }

  void removePlace(Place place) {}
}

final placesProvider = StateNotifierProvider<PlacesNotifier, List<Place>>(
  (ref) {
    return PlacesNotifier();
  },
);
