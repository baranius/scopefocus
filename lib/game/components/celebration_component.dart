import 'dart:math';

import 'package:flame/components.dart';
import 'package:flame/particles.dart';

class CelebrationComponent extends PositionComponent {
  CelebrationComponent({required Vector2 center}) : super(position: center);

  @override
  Future<void> onLoad() async {
    final starSprite = await Sprite.load('star.png');
    final rng = Random();

    final particle = Particle.generate(
      count: 28,
      lifespan: 1.1,
      generator: (i) {
        final angle = rng.nextDouble() * 2 * pi;
        final speed = 150 + rng.nextDouble() * 220;
        return AcceleratedParticle(
          acceleration: Vector2(0, 320),
          speed: Vector2(cos(angle), sin(angle)) * speed,
          child: SpriteParticle(
            sprite: starSprite,
            size: Vector2.all(22 + rng.nextDouble() * 18),
          ),
        );
      },
    );

    add(ParticleSystemComponent(particle: particle));
  }
}
