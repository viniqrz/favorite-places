import 'package:favorite_places/model/place.dart';
import 'package:sqflite/sqflite.dart';

class PlaceRepository {
  const PlaceRepository(this.db);

  final Database db;

  Future<List<Place>> list() async {
    final records = await db.query('place');
    return records.map((e) => Place.fromMap(e)).toList();
  }

  Future<void> insert(
    Place place,
  ) async {
    print(place);
    await db.insert(
      'place',
      place.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
    return;
  }

  Future<void> delete(Place place) async {
    await db.delete(
      'place',
      where: 'id = ?',
      whereArgs: [place.id],
    );
    return;
  }

  Future<Place?> findByName(String name) async {
    final records = await db.query(
      'place',
      where: 'name = ?',
      whereArgs: [name],
    );
    if (records.isEmpty) return null;
    return Place.fromMap(records.first);
  }
}
