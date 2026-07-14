import 'package:flame/components.dart';
import 'package:flame/events.dart';

import '../../web/fullscreen.dart';
import '../layout.dart';

class FullscreenButtonComponent extends SpriteComponent
    with HasGameReference, TapCallbacks {
  @override
  Future<void> onLoad() async {
    sprite = await Sprite.load('full_screen_button.png');
    anchor = Anchor.topLeft;
    _resize();
  }

  void _resize() {
    size = Layout.fullscreenButtonSize(game.size);
    position = Layout.fullscreenButtonPosition(game.size);
  }

  @override
  void onGameResize(Vector2 size) {
    super.onGameResize(size);
    if (isLoaded) _resize();
  }

  @override
  void onTapUp(TapUpEvent event) {
    requestFullscreen();
  }
}
