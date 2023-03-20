import 'package:restaurant_review_app/model/review.dart';

const String tableEntities = 'entities';

class EntityFields {
  static final List<String> values = [id, name, imageName, isRestaurant];

  static const String id = 'id';
  static const String name = 'name';
  static const String imageName = 'imageName';
  static const String isRestaurant = 'isRestaurant';
}

class Entity {
  // Entity basic information
  final int? id;
  final String name;
  final String imageName;

  // Determines if the entity is a restaurant and is reviewed by individuals
  final bool isRestaurant;

  List<Review> reviews;

  Map<String, Object?> toMap() => {
        EntityFields.id: id,
        EntityFields.name: name,
        EntityFields.imageName: imageName,
        EntityFields.isRestaurant: isRestaurant ? 1 : 0
      };

  Entity copy(
          {int? id,
          String? name,
          String? imageName,
          bool? isRestaurant,
          List<Review>? reviews}) =>
      Entity(
        id: id ?? this.id,
        name: name ?? this.name,
        imageName: imageName ?? this.imageName,
        isRestaurant: isRestaurant ?? this.isRestaurant,
        reviews: reviews ?? this.reviews,
      );

  static Entity fromMap(Map<String, Object?> json) => Entity(
        id: json[EntityFields.id] as int?,
        name: json[EntityFields.name] as String,
        imageName: json[EntityFields.imageName] as String,
        isRestaurant: json[EntityFields.isRestaurant] == 1,
        // TODO: Resolve Reviews
      );

  Entity(
      {this.id,
      required this.name,
      this.reviews = const [],
      this.imageName = 'dog',
      this.isRestaurant = false});
}
