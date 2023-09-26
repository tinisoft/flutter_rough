import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../interactive_canvas.dart';

class ExamplePage extends StatelessWidget {
  final String title;
  final InteractiveExample Function() exampleBuilder;

  const ExamplePage(
      {required this.title, required this.exampleBuilder, super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(title)),
      body: InteractiveBody(
        example: exampleBuilder(),
      ),
    );
  }
}
