import 'package:flame/components.dart';

class CloudComponent extends SpriteComponent with HasGameReference {
  CloudComponent({
    required this.imageFile,
    required this.speed,
    required this.verticalFraction,
    required this.startFraction,
  });

  final String imageFile;
  final double speed;
  final double verticalFraction;
  final double startFraction;

  @override
  Future<void> onLoad() async {
    sprite = await Sprite.load(imageFile);
    anchor = Anchor.topLeft;
    _resize();
    x = game.size.x * startFraction;
  }

  void _resize() {
    final gameSize = game.size;
    final width = gameSize.x * 0.12;
    final height = width * (sprite!.srcSize.y / sprite!.srcSize.x);
    size = Vector2(width, height);
    y = gameSize.y * verticalFraction;
  }

  @override
  void onGameResize(Vector2 size) {
    super.onGameResize(size);
    if (isLoaded) _resize();
  }

  @override
  void update(double dt) {
    super.update(dt);
    x += speed * dt;
    final gameSize = game.size;
    if (speed > 0 && x > gameSize.x) {
      x = -size.x;
    } else if (speed < 0 && x < -size.x) {
      x = gameSize.x;
    }
  }
}
