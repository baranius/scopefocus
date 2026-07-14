import 'package:flame/components.dart';
import 'package:flame/effects.dart';
import 'package:flame/events.dart';
import 'package:flutter/animation.dart';

import '../layout.dart';
import '../model/shape_kind.dart';
import '../pattern_game.dart';
import 'slot_component.dart';

class DraggableShapeComponent extends SpriteComponent
    with HasGameReference<PatternGame>, DragCallbacks {
  DraggableShapeComponent({required this.piece, required this.index});

  final ShapePiece piece;
  final int index;
  Vector2 origin = Vector2.zero();
  bool locked = false;
  SlotComponent? lockedSlot;
  bool _isDragging = false;

  @override
  Future<void> onLoad() async {
    sprite = await Sprite.load(piece.assetPath);
    anchor = Anchor.center;
    _resize();
  }

  void _resize() {
    if (locked) {
      final slot = lockedSlot;
      if (slot != null) {
        position = slot.position.clone();
        size = slot.size.clone();
      }
    } else {
      final trayPositions = Layout.trayPositions(game.size);
      final traySize = Layout.trayPieceSize(game.size);
      origin = trayPositions[index].clone();
      position = trayPositions[index].clone();
      size = traySize.clone();
    }
  }

  @override
  void onGameResize(Vector2 size) {
    super.onGameResize(size);
    if (isLoaded && !_isDragging) _resize();
  }

  @override
  void onDragStart(DragStartEvent event) {
    super.onDragStart(event);
    if (locked) return;
    _isDragging = true;
    priority = 1000;
  }

  @override
  void onDragUpdate(DragUpdateEvent event) {
    super.onDragUpdate(event);
    if (locked) return;
    position += event.localDelta;
  }

  @override
  void onDragEnd(DragEndEvent event) {
    super.onDragEnd(event);
    _isDragging = false;
    if (locked) return;
    final slot = game.findMatchingEmptySlot(position, piece);
    if (slot != null) {
      locked = true;
      lockedSlot = slot;
      priority = 4;
      position = slot.position.clone();
      size = slot.size.clone();
      slot.markFilled();
      game.onCorrectPlacement();
    } else {
      add(
        MoveToEffect(
          origin,
          EffectController(duration: 0.3, curve: Curves.easeOut),
        ),
      );
    }
  }
}
