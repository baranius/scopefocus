import 'package:flame/flame.dart';
import 'package:flame/game.dart';
import 'package:flame_audio/flame_audio.dart';
import 'package:flutter/material.dart';

import 'game/pattern_game.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  Flame.images.prefix = 'assets/';
  FlameAudio.updatePrefix('assets/');
  runApp(const CognitiveLearningApp());
}

class CognitiveLearningApp extends StatelessWidget {
  const CognitiveLearningApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Pattern Match',
      home: Scaffold(
        body: GameWidget(game: PatternGame()),
      ),
    );
  }
}
