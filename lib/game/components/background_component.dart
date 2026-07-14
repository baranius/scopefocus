import 'package:flame/components.dart';

class BackgroundComponent extends SpriteComponent
    with HasGameReference {
  @override
  Future<void> onLoad() async {
    sprite = await Sprite.load('background.png');
    anchor = Anchor.topLeft;
    position = Vector2.zero();
    size = game.size;
  }

  @override
  void onGameResize(Vector2 size) {
    super.onGameResize(size);
    this.size = size;
  }
}
