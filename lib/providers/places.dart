import 'dart:async';
import 'dart:io';

import 'package:favorite_places/database/manager.dart';
import 'package:favorite_places/model/place.dart';
import 'package:favorite_places/repository/place.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class PlacesNotifier extends AsyncNotifier<List<Place>> {
  PlaceRepository? _repository;

  void addPlace(Place place) async {
    state = await AsyncValue.guard(() async {
      final repo = await _getRepository();
      await repo.insert(place);
      return [...state.asData!.value, place];
    });
  }

  void removePlace(Place place) async {
    state = await AsyncValue.guard(() async {
      final repo = await _getRepository();
      await repo.delete(place);
      return state.asData!.value.where((element) => element != place).toList();
    });
  }

  bool isNameDuplicate(String placeName) {
    try {
      final current = state.asData!.value;
      current.firstWhere((element) => element.name == placeName);
      return true;
    } catch (e) {
      return false;
    }
  }

  @override
  Future<List<Place>> build() async {
    state = const AsyncValue.loading();
    sleep(const Duration(seconds: 3));
    return PlaceRepository(await AppDatabaseManager.getDatabaseInstance())
        .list();
  }

  Future<PlaceRepository> _getRepository() async {
    if (_repository != null) return _repository!;
    return PlaceRepository(await AppDatabaseManager.getDatabaseInstance());
  }
}

final placesProvider = AsyncNotifierProvider<PlacesNotifier, List<Place>>(
  () {
    return PlacesNotifier();
  },
);
