import 'package:flutter/material.dart';
import 'package:restaurant_review_app/model/entity.dart';
import 'package:restaurant_review_app/model/review.dart';
import 'package:restaurant_review_app/services/database.dart';
import 'package:restaurant_review_app/widgets/reviewerImage.dart';

class ReviewDetailsScreen extends StatefulWidget {
  const ReviewDetailsScreen(
      {super.key, required this.entity, required this.review});

  final Entity entity;
  final Review review;

  @override
  State<ReviewDetailsScreen> createState() => _ReviewDetailsScreenState();
}

class _ReviewDetailsScreenState extends State<ReviewDetailsScreen> {
  final ThemeData themeData =
      ThemeData(brightness: Brightness.dark, primaryColor: Colors.orange[600]);

  final ButtonStyle redButton =
      ElevatedButton.styleFrom(backgroundColor: Colors.red[400]);

  Widget getStars(int count) {
    List<Widget> list = <Widget>[];

    for (int i = 0; i < count; i++) {
      list.add(Icon(Icons.star_outlined, color: Colors.yellow[300]));
    }

    return Row(
      children: list,
      mainAxisAlignment: MainAxisAlignment.center,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Theme(
        data: themeData,
        child: Scaffold(
            appBar: AppBar(
              title: Center(
                  child: Text(
                '${widget.entity.name}\'s review',
                style: TextStyle(color: Colors.orange[400]),
              )),
              automaticallyImplyLeading: false,
            ),
            body: SingleChildScrollView(
              padding: EdgeInsets.symmetric(horizontal: 10, vertical: 35),
              child: Center(
                child: Column(children: <Widget>[
                  ReviewerImage(
                    imageName: widget.review.entity.imageName,
                    radius: 45,
                  ),
                  Text(
                    widget.review.entity.name,
                    style: TextStyle(
                        color: Colors.orange[400],
                        fontSize: 25,
                        fontWeight: FontWeight.bold),
                  ),
                  getStars(widget.review.star),
                  Padding(
                      padding:
                          EdgeInsets.symmetric(horizontal: 10, vertical: 30),
                      child: Text(
                        '"${widget.review.description}"',
                        style: TextStyle(
                            fontSize: 20, fontStyle: FontStyle.italic),
                      )),
                  Text("Review by ${widget.entity.name}",
                      style: TextStyle(fontSize: 15)),
                  SizedBox(height: 25),
                  ElevatedButton(
                    child: Center(
                        child: Text("BACK",
                            style:
                                TextStyle(color: Colors.white, fontSize: 15))),
                    onPressed: () => Navigator.pop(context),
                  ),
                  ElevatedButton(
                    child: Center(
                        child: Text("DELETE",
                            style:
                                TextStyle(color: Colors.white, fontSize: 15))),
                    style: redButton,
                    onPressed: () {
                      EntityDatabase db = EntityDatabase.instance;
                      db
                          .deleteReview(widget.review.id!)
                          .whenComplete(() => Navigator.pop(context));
                    },
                  ),
                ]),
              ),
            )));
  }
}
