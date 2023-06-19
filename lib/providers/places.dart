import 'package:favorite_places/model/place.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class PlacesNotifier extends StateNotifier<List<Place>> {
  PlacesNotifier()
      : super([
          Place(lat: 10, lng: 11, 'Place 1'),
          Place(lat: 10, lng: 11, 'Place 2'),
          Place(lat: 10, lng: 11, 'Place 3'),
          Place(lat: 10, lng: 11, 'Place 4'),
          Place(lat: 10, lng: 11, 'Place 5'),
        ]);

  void addPlace(Place place) {
    state = [...state, place];
  }

  void removePlace(Place place) {
    state = state.where((element) => element != place).toList();
  }

  bool isNameDuplicate(String placeName) {
    try {
      state.firstWhere((element) => element.name == placeName);
      return true;
    } catch (e) {
      return false;
    }
  }
}

final placesProvider = StateNotifierProvider<PlacesNotifier, List<Place>>(
  (ref) {
    return PlacesNotifier();
  },
);
