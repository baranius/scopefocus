import 'package:flame/components.dart';

import '../layout.dart';

class CenterLineComponent extends SpriteComponent with HasGameReference {
  @override
  Future<void> onLoad() async {
    sprite = await Sprite.load('seperator_line.png');
    anchor = Anchor.topLeft;
    _resize();
  }

  void _resize() {
    size = Layout.centerLineSize(game.size);
    position = Layout.centerLinePosition(game.size);
  }

  @override
  void onGameResize(Vector2 size) {
    super.onGameResize(size);
    if (isLoaded) _resize();
  }
}
