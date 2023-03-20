import 'package:path/path.dart';
import 'package:restaurant_review_app/model/entity.dart';
import 'package:restaurant_review_app/model/review.dart';
import 'package:sqflite/sqflite.dart';

class EntityDatabase {
  static final EntityDatabase instance = EntityDatabase._init();

  static Database? _database;

  EntityDatabase._init();

  Future<Database> get database async {
    if (_database != null) return _database!;

    _database = await _initDB('entities.db');
    return _database!;
  }

  Future<Database> _initDB(String filepath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filepath);

    return openDatabase(
      path,
      version: 1,
      onCreate: _createDB,
    );
  }

  Future _createDB(Database db, int version) async {
    const idType = 'INTEGER PRIMARY KEY AUTOINCREMENT';
    const boolType = 'BOOLEAN NOT NULL';
    const stringType = 'TEXT NOT NULL';
    const intType = 'INTEGER NOT NULL';

    db.execute('''CREATE TABLE $tableEntities(
            ${EntityFields.id} $idType,
            ${EntityFields.name} $stringType,
            ${EntityFields.imageName} $stringType,
            ${EntityFields.isRestaurant} $boolType)''');
    db.execute('''CREATE TABLE $tableReviews(
          ${ReviewFields.id} $idType,
          ${ReviewFields.reviewer} $intType,
          ${ReviewFields.reviewee} $intType,
          ${ReviewFields.description} $stringType,
          ${ReviewFields.star} $intType)''');
  }

  Future<Entity> create(Entity entity) async {
    final db = await instance.database;

    final id = await db.insert(tableEntities, entity.toMap());
    return entity.copy(id: id);
  }

  Future<Review> createReview(Entity owner, Review review) async {
    final db = await instance.database;

    final id = await db.insert(tableReviews, review.toMap(owner: owner));
    return review.copy(id: id);
  }

  Future<int> deleteReview(int id) async {
    final db = await instance.database;

    return await db
        .delete(tableReviews, where: '${ReviewFields.id} = ?', whereArgs: [id]);
  }

  Future<Entity> read(int id) async {
    final db = await instance.database;

    final maps = await db.query(
      tableEntities,
      columns: EntityFields.values,
      where: '${EntityFields.id} = ?',
      whereArgs: [id],
    );

    if (maps.isNotEmpty) {
      Entity e = Entity.fromMap(maps.first);

      final reviews = await db.query(tableReviews,
          columns: ReviewFields.values,
          where: '${ReviewFields.reviewer} = ?',
          whereArgs: [e.id]);

      if (!e.isRestaurant) {
        e.reviews = await Future.wait(
            reviews.map((json) => Review.fromMap(json)).toList());
      }

      return e;
    } else {
      throw Exception('ID $id not found.');
    }
  }

  Future<List<Entity>> readAll() async {
    final db = await instance.database;

    // Debug stuff
    // (await db.query('sqlite_master', columns: ['type', 'name'])).forEach((row) {
    //   print(row.values);
    // });

    // (await db.rawQuery('PRAGMA table_info(reviews)')).forEach((row) {
    //   print(row.values);
    // });

    final result = await db.query(tableEntities);

    List<Entity> entities = result.map((json) => Entity.fromMap(json)).toList();

    // Resolve all Reviews and assign them properly to entities
    for (Entity e in entities) {
      final reviews = await db.query(tableReviews,
          columns: ReviewFields.values,
          where: '${ReviewFields.reviewer} = ?',
          whereArgs: [e.id]);

      if (!e.isRestaurant) {
        e.reviews = await Future.wait(
            reviews.map((json) => Review.fromMap(json)).toList());
      }
    }

    return entities;
  }

  Future close() async {
    final db = await instance.database;

    db.close();
  }
}
