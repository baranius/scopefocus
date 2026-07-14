import 'package:flame/components.dart';
import 'package:flutter/material.dart';

import '../layout.dart';

class ScoreboardComponent extends PositionComponent with HasGameReference {
  final Paint _panelPaint = Paint()..color = const Color(0xFF304254);
  late SpriteComponent _star;
  late TextComponent _scoreText;
  int _score = 0;

  @override
  Future<void> onLoad() async {
    anchor = Anchor.topLeft;

    final starSprite = await Sprite.load('star.png');
    _star = SpriteComponent(sprite: starSprite, anchor: Anchor.centerLeft);
    _scoreText = TextComponent(
      text: '0',
      anchor: Anchor.centerLeft,
      textRenderer: TextPaint(
        style: const TextStyle(
          fontFamily: 'Fredoka',
          color: Colors.white,
          fontSize: 24,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
    addAll([_star, _scoreText]);
    _resize();
  }

  void updateScore(int value) {
    _score = value;
    _scoreText.text = '$_score';
  }

  void _resize() {
    final gameSize = game.size;
    size = Layout.scoreboardSize(gameSize);
    position = Layout.scoreboardPosition(gameSize);

    final iconSize = size.y * 0.5;
    _star.size = Vector2.all(iconSize);
    _star.position = Vector2(size.y * 0.35, size.y / 2);
    _scoreText.position = Vector2(
      _star.position.x + _star.size.x + size.y * 0.25,
      size.y / 2,
    );
  }

  @override
  void onGameResize(Vector2 size) {
    super.onGameResize(size);
    if (isLoaded) _resize();
  }

  @override
  void render(Canvas canvas) {
    final rrect = RRect.fromRectAndRadius(
      Rect.fromLTWH(0, 0, size.x, size.y),
      Radius.circular(size.y * 0.3),
    );
    canvas.drawRRect(rrect, _panelPaint);
    super.render(canvas);
  }
}
