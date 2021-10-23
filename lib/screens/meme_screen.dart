import 'package:flutter/material.dart';

import 'package:memes_app/models/meme.dart';

class MemeScreen extends StatefulWidget {
  final Meme meme;

  MemeScreen({ required this.meme });

  @override
  _MemeScreenState createState() => _MemeScreenState();
}

class _MemeScreenState extends State<MemeScreen> {
  @override
  Widget build(BuildContext context) {
    return const Text('Meme screen');
  }
}