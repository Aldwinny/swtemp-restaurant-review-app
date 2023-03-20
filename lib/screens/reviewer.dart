import 'package:flutter/material.dart';
import 'package:restaurant_review_app/model/entity.dart';
import 'package:restaurant_review_app/services/database.dart';
import 'package:restaurant_review_app/widgets/reviewerImage.dart';

class AddEntityScreen extends StatefulWidget {
  const AddEntityScreen(
      {super.key, required this.isRestaurant, required this.entities});

  final List<Entity> entities;
  final bool isRestaurant;

  @override
  State<AddEntityScreen> createState() => _AddEntityScreenState();
}

class _AddEntityScreenState extends State<AddEntityScreen> {
  final ThemeData themeData =
      ThemeData(brightness: Brightness.dark, primaryColor: Colors.orange[600]);

  String name = '';
  String imageName = 'penguin';

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
    return Theme(
      data: themeData,
      child: Scaffold(
        appBar: AppBar(
          title: Text(
              'Add new ${widget.isRestaurant ? "Restaurant" : "Reviewer"}'),
          automaticallyImplyLeading: false,
        ),
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: <Widget>[
              Row(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      'Image for ${widget.isRestaurant ? "Restaurant" : "Reviewer"}:',
                      style: TextStyle(color: Colors.orange[400]),
                    ),
                  ),
                  Expanded(
                    child: DropdownButton<String>(
                        isExpanded: true,
                        value: imageName,
                        items: [
                          'bird',
                          'cat',
                          'dog',
                          'elephant',
                          'master',
                          'seal',
                          'penguin'
                        ].map<DropdownMenuItem<String>>((String value) {
                          return DropdownMenuItem(
                              value: value, child: Text(value));
                        }).toList(),
                        onChanged: (String? value) {
                          setState(() {
                            imageName = value!;
                          });
                        }),
                  ),
                ],
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 20),
                child: Text('Preview:',
                    style: TextStyle(color: Colors.orange[400])),
              ),
              ReviewerImage(imageName: imageName, radius: 40),
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 30, vertical: 8),
                child: TextField(
                    maxLength: 75,
                    decoration: InputDecoration(
                        labelText:
                            'Name of ${widget.isRestaurant ? "Restaurant" : "Reviewer"}'),
                    controller: _controller,
                    onChanged: (String val) => setState(() => name = val)),
              ),
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 40, vertical: 10),
                child: ElevatedButton(
                  onPressed: () async {
                    await showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          if (name.isNotEmpty) {
                            Entity newEntity = Entity(
                                name: name,
                                imageName: imageName,
                                isRestaurant: widget.isRestaurant);

                            EntityDatabase e = EntityDatabase.instance;
                            e.create(newEntity);

                            return AlertDialog(
                                title: const Text('Thank you!'),
                                content: const Text(
                                    'Your review was recorded successfully!'),
                                actions: <Widget>[
                                  TextButton(
                                      onPressed: () => Navigator.of(context)
                                          .popUntil((route) => route.isFirst),
                                      child: const Text('OK'))
                                ]);
                          }
                          return AlertDialog(
                            title: const Text('Error'),
                            content: const Text(
                                'Please fill up the review text field!'),
                            actions: <Widget>[
                              TextButton(
                                  onPressed: () => Navigator.pop(context),
                                  child: const Text('OK'))
                            ],
                          );
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
                  child: const Center(child: Text('Back')),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
