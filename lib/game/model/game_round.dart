import 'dart:math';

import 'shape_kind.dart';

const int slotCount = 5;
const int distractorCount = 3;

class GameRound {
  factory GameRound.random({Random? random}) {
    final rng = random ?? Random();
    final allPieces = [
      for (final kind in ShapeKind.values)
        for (final color in ShapeColor.values) ShapePiece(kind, color),
    ];

    final slots = List.generate(
      slotCount,
      (_) => allPieces[rng.nextInt(allPieces.length)],
    );

    final tray = [
      ...slots,
      for (var i = 0; i < distractorCount; i++)
        allPieces[rng.nextInt(allPieces.length)],
    ]..shuffle(rng);

    return GameRound._(slots: slots, tray: tray);
  }

  GameRound._({required this.slots, required this.tray});

  final List<ShapePiece> slots;
  final List<ShapePiece> tray;
}
