import 'package:flame/components.dart';
import 'package:flutter/material.dart';

import '../layout.dart';
import '../model/shape_kind.dart';

class ReferencePanelComponent extends PositionComponent with HasGameReference {
  ReferencePanelComponent({required this.pieces});

  final List<ShapePiece> pieces;
  final Paint _backgroundPaint = Paint()..color = Colors.white;
  late SpriteComponent _miniLine;
  final List<SpriteComponent> _icons = [];

  @override
  Future<void> onLoad() async {
    anchor = Anchor.topLeft;

    final miniLineSprite = await Sprite.load('seperator_line.png');
    _miniLine = SpriteComponent(sprite: miniLineSprite, anchor: Anchor.center);
    add(_miniLine);

    for (final piece in pieces) {
      final sprite = await Sprite.load(piece.assetPath);
      final icon = SpriteComponent(sprite: sprite, anchor: Anchor.center);
      _icons.add(icon);
      add(icon);
    }

    _resize();
  }

  void _resize() {
    final gameSize = game.size;
    size = Layout.referencePanelSize(gameSize);
    position = Layout.referencePanelPosition(gameSize);

    final miniLineSize = Vector2(
      size.x * 0.85,
      size.x * 0.85 * separatorAspectRatio,
    );
    _miniLine.size = miniLineSize;
    _miniLine.position = size / 2;

    final miniLineTopLeft = size / 2 - miniLineSize / 2;
    final iconPositions = Layout.waveIconPositions(miniLineTopLeft, miniLineSize);
    final iconSize = size.y * 0.55;
    for (var i = 0; i < _icons.length; i++) {
      _icons[i].size = Vector2.all(iconSize);
      _icons[i].position = iconPositions[i];
    }
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
      Radius.circular(size.y * 0.25),
    );
    canvas.drawRRect(rrect, _backgroundPaint);
    super.render(canvas);
  }
}
