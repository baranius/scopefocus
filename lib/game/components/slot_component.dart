import 'package:flame/components.dart';

import '../layout.dart';
import '../model/shape_kind.dart';

class SlotComponent extends PositionComponent with HasGameReference {
  SlotComponent({required this.target, required this.index});

  final ShapePiece target;
  final int index;
  bool filled = false;
  SpriteComponent? _placeholder;

  @override
  Future<void> onLoad() async {
    anchor = Anchor.center;
    _resize();

    final sprite = await Sprite.load('expected_shape.png');
    _placeholder = SpriteComponent(
      sprite: sprite,
      size: size.clone(),
      anchor: Anchor.center,
      position: size / 2,
    );
    add(_placeholder!);
  }

  void _resize() {
    final positions = Layout.centerLineSlotPositions(game.size);
    position = positions[index];
    size = Layout.centerLineSlotSize(game.size);
    final placeholder = _placeholder;
    if (placeholder != null) {
      placeholder.size = size.clone();
      placeholder.position = size / 2;
    }
  }

  @override
  void onGameResize(Vector2 size) {
    super.onGameResize(size);
    if (isLoaded) _resize();
  }

  void markFilled() {
    filled = true;
    _placeholder?.removeFromParent();
    _placeholder = null;
  }
}
