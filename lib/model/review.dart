import 'package:restaurant_review_app/model/entity.dart';
import 'package:restaurant_review_app/services/database.dart';

const String tableReviews = 'reviews';

class ReviewFields {
  static final List<String> values = [
    id,
    reviewer,
    reviewee,
    description,
    star
  ];

  static const String id = 'id';
  static const String reviewer = 'reviewer';
  static const String reviewee = 'reviewee';
  static const String description = 'description';
  static const String star = 'stars';
}

// Review that implements a factory design pattern
class Review {
  int? id;
  Entity entity;
  int star;
  String description;

  Review._(this.entity, this.star, this.description, {this.id});

  Map<String, dynamic> toMap({required Entity owner}) {
    return {
      ReviewFields.reviewer: owner.id,
      ReviewFields.reviewee: entity.id,
      ReviewFields.star: star,
      ReviewFields.description: description,
    };
  }

  static Future<Review> fromMap(Map<String, Object?> json) async {
    final db = EntityDatabase.instance;
    Entity? result;

    result = await db.read(json[ReviewFields.reviewee] as int);

    return Review._(result, json[ReviewFields.star] as int,
        json[ReviewFields.description] as String,
        id: json[ReviewFields.id] as int?);
  }

  Review copy({int? id, Entity? entity, int? star, String? description}) {
    return Review._(entity ?? this.entity, star ?? this.star,
        description ?? this.description,
        id: id ?? this.id);
  }

  @override
  String toString() {
    return 'Review(id: $id, entity_id: ${entity.id}, stars: $star, description: $description)';
  }

  static Review? reviewFrom(Entity restaurant, int star, String description) {
    // If the reviewed entity is not a restaurant
    if (!restaurant.isRestaurant) {
      return null;
    }

    // Rating must be within 0~5
    if (star > 5) {
      star = 5;
    } else if (star < 0) {
      star = 0;
    }

    return Review._(restaurant, star, description);
  }
}
