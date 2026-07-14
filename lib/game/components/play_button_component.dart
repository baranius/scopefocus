import 'package:flame/components.dart';
import 'package:flame/events.dart';

class PlayButtonComponent extends SpriteComponent
    with HasGameReference, TapCallbacks {
  PlayButtonComponent({required this.onPressed});

  final void Function() onPressed;

  @override
  Future<void> onLoad() async {
    sprite = await Sprite.load('play_button.png');
    anchor = Anchor.center;
    _resize();
  }

  void _resize() {
    final gameSize = game.size;
    final width = gameSize.x * 0.22;
    final height = width * (sprite!.srcSize.y / sprite!.srcSize.x);
    size = Vector2(width, height);
    position = gameSize / 2;
  }

  @override
  void onGameResize(Vector2 size) {
    super.onGameResize(size);
    if (isLoaded) _resize();
  }

  @override
  void onTapUp(TapUpEvent event) {
    onPressed();
  }
}
