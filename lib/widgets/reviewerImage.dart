import 'package:flutter/material.dart';

class ReviewerImage extends StatelessWidget {
  const ReviewerImage(
      {super.key,
      this.imageName = 'penguin',
      this.padding = const EdgeInsets.all(8),
      this.radius = 27});

  final String imageName;
  final EdgeInsetsGeometry padding;
  final double radius;

  ImageProvider resolveImage() {
    switch (imageName) {
      case 'bird':
        return AssetImage('assets/images/avatar_bird.jpg');
      case 'cat':
        return AssetImage('assets/images/avatar_cat.jpg');
      case 'dog':
        return AssetImage('assets/images/avatar_dog.jpg');
      case 'elephant':
        return AssetImage('assets/images/avatar_elephant.jpg');
      case 'master':
        return AssetImage('assets/images/avatar_master_cat.jpg');
      case 'seal':
        return AssetImage('assets/images/avatar_seal.jpg');
      default:
        return AssetImage('assets/images/avatar_penguin.png');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: padding,
        child: CircleAvatar(
          foregroundImage: resolveImage(),
          radius: radius,
        ));
  }
}
