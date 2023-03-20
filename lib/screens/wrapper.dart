import 'package:flutter/material.dart';
import 'package:restaurant_review_app/model/entity.dart';
import 'package:restaurant_review_app/model/review.dart';
import 'package:restaurant_review_app/screens/detail.dart';
import 'package:restaurant_review_app/screens/entry.dart';
import 'package:restaurant_review_app/screens/reviewer.dart';
import 'package:restaurant_review_app/services/database.dart';
import 'package:restaurant_review_app/widgets/reviewEntry.dart';
import 'package:restaurant_review_app/widgets/reviewerImage.dart';

class WrapperScreen extends StatefulWidget {
  const WrapperScreen({super.key});

  @override
  State<WrapperScreen> createState() => _WrapperScreenState();
}

class _WrapperScreenState extends State<WrapperScreen> {
  final ThemeData themeData =
      ThemeData(brightness: Brightness.dark, primaryColor: Colors.orange[600]);

  final ButtonStyle orangeButton =
      TextButton.styleFrom(foregroundColor: Colors.orange[400]);

  List<ReviewEntry> generateWidgetList(Entity entity) {
    List<ReviewEntry> widgets = [];

    if (entity.reviews.isEmpty || entity.isRestaurant) {
      return widgets;
    }

    for (Review r in entity.reviews) {
      widgets.add(ReviewEntry(r.description,
          image: ReviewerImage(
            imageName: entity.imageName,
          ), onPressed: () async {
        await Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) =>
                    ReviewDetailsScreen(entity: entity, review: r)));
        setState(() => refreshEntities());
      }, author: entity.name, restaurant: r.entity.name, stars: r.star));
    }

    return widgets;
  }

  List<ReviewEntry> generateWidgetListMultiple(List<Entity> entityList) {
    List<ReviewEntry> widgets = [];

    for (Entity entity in entityList) {
      widgets.addAll(generateWidgetList(entity));
    }
    return widgets;
  }

  List<Entity> entities = [
    // Entity(name: 'Davie Jone\'s Fine Dining', isRestaurant: true),
    // Entity(name: 'Jollibee', isRestaurant: true),
    // Entity(name: 'King Kong', imageName: 'seal'),
    // Entity(name: 'Master Oogway', imageName: 'cat'),
    // Entity(name: 'Lord Cat', imageName: 'master'),
    // Entity(name: 'Pinguino'),
  ];

  // TODO: Remove later
  void refreshEntities() {
    EntityDatabase db = EntityDatabase.instance;

    db
        .readAll()
        .then((value) => setState(() => entities = value))
        .whenComplete(() => print(entities));
  }

  @override
  void initState() {
    setState(() {
      refreshEntities();
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: themeData,
      child: Scaffold(
        body: Padding(
          padding: const EdgeInsets.all(7),
          child: SingleChildScrollView(
            child: Column(
              children: <Widget>[
                const Center(
                  child: Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Image(
                      image: AssetImage(
                        'assets/images/home.png',
                      ),
                      height: 150,
                      color: Colors.orange,
                    ),
                  ),
                ),
                ...generateWidgetListMultiple(entities),
                OrangeTBIcon(
                  onPressed: () async {
                    await Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => AddEntityScreen(
                                  isRestaurant: true,
                                  entities: entities,
                                )));
                    setState(() =>
                        refreshEntities()); // Expensive as heck in terms of performance but OK
                  },
                  icon: const Icon(Icons.restaurant),
                  label: 'Add Restaurant',
                ),
                OrangeTBIcon(
                  // TODO: Add Restaurant preparation thingy
                  onPressed: () async {
                    await Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => AddEntityScreen(
                                  isRestaurant: false,
                                  entities: entities,
                                )));
                    setState(() =>
                        refreshEntities()); // Expensive as heck in terms of performance but OK
                  },
                  icon: const Icon(Icons.person),
                  label: 'Add Reviewer',
                ),
                OrangeTBIcon(
                  onPressed: () async {
                    List<Entity> restaurant = [];
                    List<Entity> reviewer = [];

                    for (Entity i in entities) {
                      if (i.isRestaurant) {
                        restaurant.add(i);
                      } else {
                        reviewer.add(i);
                      }
                    }

                    if (restaurant.isNotEmpty && reviewer.isNotEmpty) {
                      await Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) =>
                                  AddReviewScreen(entities: entities)));

                      // For some reason, this feels so wrong.
                      setState(() {});
                    } else {
                      await showDialog(
                        context: context,
                        builder: (context) => AlertDialog(
                          title: const Text('Error'),
                          content: const Text(
                              'Please add a restaurant and a reviewer first!'),
                          actions: <Widget>[
                            TextButton(
                                onPressed: () => Navigator.pop(context),
                                child: const Text('OK'))
                          ],
                        ),
                      );
                    }
                  },
                  icon: const Icon(Icons.reviews),
                  label: 'Add Review',
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class OrangeTBIcon extends StatelessWidget {
  OrangeTBIcon(
      {super.key,
      required this.onPressed,
      required this.label,
      required this.icon});

  final void Function() onPressed;
  final String label;
  final Icon icon;

  final ButtonStyle orangeButton = TextButton.styleFrom(
    foregroundColor: Colors.orange[400],
    padding: const EdgeInsets.all(20),
  );

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: OutlinedButton.icon(
        onPressed: onPressed,
        icon: icon,
        label: Text(
          label,
          style: TextStyle(color: Colors.orange[400]),
        ),
        style: orangeButton,
      ),
    );
  }
}
