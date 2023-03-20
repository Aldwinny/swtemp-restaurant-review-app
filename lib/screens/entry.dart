import 'package:flutter/material.dart';
import 'package:restaurant_review_app/model/entity.dart';
import 'package:restaurant_review_app/model/review.dart';
import 'package:restaurant_review_app/services/database.dart';

class AddReviewScreen extends StatefulWidget {
  const AddReviewScreen({super.key, required this.entities});

  final List<Entity> entities;

  @override
  State<AddReviewScreen> createState() => AddReviewScreenState();
}

class AddReviewScreenState extends State<AddReviewScreen> {
  final ThemeData themeData =
      ThemeData(brightness: Brightness.dark, primaryColor: Colors.orange[600]);
  final TextStyle white = const TextStyle(color: Colors.white);

  int? selectedReviewer;
  int? selectedRestaurant;
  int stars = 0;
  String review = '';

  late TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Im too lazy to optimize this lmao
    final List<int> restaurants = [];
    final List<int> reviewers = [];

    for (int i = 0; i < widget.entities.length; i++) {
      if (widget.entities[i].isRestaurant) {
        restaurants.add(i);
      } else {
        reviewers.add(i);
      }
    }
    return Theme(
      data: themeData,
      child: Scaffold(
        appBar: AppBar(
          title: Center(
            child: Text(
              'Add new Review',
              style: white.apply(color: Colors.orange[400]),
            ),
          ),
          automaticallyImplyLeading: false,
        ),
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(10),
          child: Column(
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 10),
                child: Row(
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      child: Text('Select Reviewer:',
                          style: white.apply(color: Colors.orange[400])),
                    ),
                    Expanded(
                      child: DropdownButton<int>(
                        isExpanded: true,
                        value: selectedReviewer ?? reviewers[0],
                        items:
                            reviewers.map<DropdownMenuItem<int>>((int value) {
                          return DropdownMenuItem(
                              value: value,
                              child: Text(widget.entities[value].name));
                        }).toList(),
                        onChanged: (int? value) {
                          setState(() {
                            selectedReviewer = value!;
                          });
                        },
                      ),
                    ),
                  ],
                ),
              ),
              Row(
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    child: Text(
                      'Select Restaurant:',
                      style: white.apply(color: Colors.orange[400]),
                    ),
                  ),
                  Expanded(
                    child: DropdownButton<int>(
                      isExpanded: true,
                      value: selectedRestaurant ?? restaurants[0],
                      items:
                          restaurants.map<DropdownMenuItem<int>>((int value) {
                        return DropdownMenuItem(
                            value: value,
                            child: Text(widget.entities[value].name));
                      }).toList(),
                      onChanged: (int? value) {
                        setState(() {
                          selectedRestaurant = value!;
                        });
                      },
                    ),
                  ),
                ],
              ),
              Row(
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    child: Text(
                      'Stars:',
                      style: white.apply(color: Colors.orange[400]),
                    ),
                  ),
                  Expanded(
                    child: DropdownButton<int>(
                      isExpanded: true,
                      value: stars,
                      items: [0, 1, 2, 3, 4, 5]
                          .map<DropdownMenuItem<int>>((int value) {
                        return DropdownMenuItem(
                            value: value,
                            child: Text('${value.toString()} stars'));
                      }).toList(),
                      onChanged: (int? value) {
                        setState(() {
                          stars = value!;
                        });
                      },
                    ),
                  ),
                ],
              ),
              Padding(
                padding: const EdgeInsets.only(top: 25),
                child: TextField(
                    maxLines: null,
                    maxLength: 500,
                    keyboardType: TextInputType.multiline,
                    decoration: InputDecoration(
                        hintText: 'Add Review',
                        labelText: 'Add Review',
                        labelStyle: white.apply(color: Colors.orange[400])),
                    controller: _controller,
                    onChanged: (String value) =>
                        setState(() => review = value)),
              ),
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 40, vertical: 10),
                child: ElevatedButton(
                  onPressed: () async {
                    await showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          if (review.isNotEmpty) {
                            Review newReview = Review.reviewFrom(
                                widget.entities[
                                    selectedRestaurant ?? restaurants[0]],
                                stars,
                                review)!;

                            EntityDatabase db = EntityDatabase.instance;
                            db
                                .createReview(
                                    widget.entities[
                                        selectedReviewer ?? reviewers[0]],
                                    newReview)
                                .then((r) => {
                                      widget
                                          .entities[
                                              selectedReviewer ?? reviewers[0]]
                                          .reviews
                                          .add(r)
                                    });

                            return AlertDialog(
                              title: const Text('Thank you!'),
                              content: const Text(
                                  'Your review was recorded successfully!'),
                              actions: <Widget>[
                                TextButton(
                                    onPressed: () => Navigator.of(context)
                                        .popUntil((route) => route.isFirst),
                                    child: const Text('OK'))
                              ],
                            );
                          }
                          return AlertDialog(
                              title: const Text('Error'),
                              content: const Text(
                                  'Please fill up the review text field!'),
                              actions: <Widget>[
                                TextButton(
                                    child: const Text('OK'),
                                    onPressed: () => Navigator.pop(context))
                              ]);
                        });
                  },
                  child: const Center(child: Text('Save')),
                ),
              ),
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 40, vertical: 10),
                child: ElevatedButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Center(child: Text('Back'))),
              )
            ],
          ),
        ),
      ),
    );
  }
}
