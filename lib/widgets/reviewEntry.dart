import 'package:flutter/material.dart';
import 'package:restaurant_review_app/widgets/reviewerImage.dart';

class ReviewEntry extends StatelessWidget {
  const ReviewEntry(this.text,
      {super.key,
      required this.onPressed,
      required this.author,
      required this.restaurant,
      required this.stars,
      this.image = const ReviewerImage()});

  final void Function() onPressed;
  final ReviewerImage image;
  final String text;
  final String author;
  final String restaurant;
  final int stars;

  final TextStyle white = const TextStyle(color: Colors.white);

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: onPressed,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 4),
        child: Row(children: <Widget>[
          image,
          Flexible(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  '"$text"',
                  style: const TextStyle(
                      color: Colors.white, fontStyle: FontStyle.italic),
                  overflow: TextOverflow.ellipsis,
                ),
                Row(children: <Widget>[
                  Icon(
                    Icons.star_rate_rounded,
                    size: 15,
                    color: Colors.orange[400],
                  ),
                  Flexible(
                    child: Text(
                      stars.toString(),
                      style: white.apply(color: Colors.orange[400]),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  Text('· $restaurant',
                      style: white.apply(color: Colors.orange[400]))
                ]),
                Text(
                  'by $author',
                  style: white,
                )
              ],
            ),
          ),
        ]),
      ),
    );
  }
}
