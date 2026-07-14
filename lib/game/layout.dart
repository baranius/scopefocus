import 'package:flame/components.dart';

import 'model/game_round.dart';

const double separatorAspectRatio = 219 / 1669;

// Fractions along the seperator_line.png curve where the wave dips to a
// trough / rises to a peak, read off the reference artwork. Slots/icons sit
// exactly at these extrema rather than on a flat mid-line.
const List<double> _waveXFractions = [0.114, 0.309, 0.505, 0.697, 0.891];
const double _waveTroughFraction = 0.61;
const double _wavePeakFraction = 0.37;

class Layout {
  static List<Vector2> waveIconPositions(Vector2 lineTopLeft, Vector2 lineSize) {
    final yTrough = lineTopLeft.y + lineSize.y * _waveTroughFraction;
    final yPeak = lineTopLeft.y + lineSize.y * _wavePeakFraction;
    return List.generate(slotCount, (i) {
      final x = lineTopLeft.x + lineSize.x * _waveXFractions[i];
      final y = i.isEven ? yTrough : yPeak;
      return Vector2(x, y);
    });
  }

  static Vector2 centerLineSize(Vector2 gameSize) {
    final width = gameSize.x * 0.62;
    return Vector2(width, width * separatorAspectRatio);
  }

  static Vector2 centerLinePosition(Vector2 gameSize) {
    final size = centerLineSize(gameSize);
    return Vector2((gameSize.x - size.x) / 2, (gameSize.y - size.y) / 2);
  }

  static List<Vector2> centerLineSlotPositions(Vector2 gameSize) {
    return waveIconPositions(centerLinePosition(gameSize), centerLineSize(gameSize));
  }

  static Vector2 centerLineSlotSize(Vector2 gameSize) =>
      Vector2.all(gameSize.x * 0.05);

  static Vector2 referencePanelSize(Vector2 gameSize) =>
      Vector2(gameSize.x * 0.40, gameSize.y * 0.10);

  static Vector2 referencePanelPosition(Vector2 gameSize) {
    final size = referencePanelSize(gameSize);
    final margin = Vector2(gameSize.x * 0.02, gameSize.y * 0.03);
    return Vector2(
      gameSize.x - size.x - margin.x,
      gameSize.y - size.y - margin.y,
    );
  }

  static Vector2 trayPieceSize(Vector2 gameSize) =>
      Vector2.all(gameSize.x * 0.065);

  static List<Vector2> trayPositions(Vector2 gameSize) {
    final marginX = gameSize.x * 0.03;
    final marginY = gameSize.y * 0.03;
    final cellW = gameSize.x * 0.09;
    final cellH = gameSize.y * 0.12;
    final points = <Vector2>[];
    for (var row = 0; row < 2; row++) {
      for (var col = 0; col < 4; col++) {
        final x = marginX + cellW * col + cellW / 2;
        final y = gameSize.y - marginY - cellH * (2 - row) + cellH / 2;
        points.add(Vector2(x, y));
      }
    }
    return points;
  }

  static Vector2 scoreboardSize(Vector2 gameSize) =>
      Vector2(gameSize.x * 0.16, gameSize.y * 0.08);

  static Vector2 scoreboardPosition(Vector2 gameSize) =>
      Vector2(gameSize.x * 0.02, gameSize.y * 0.02);

  static Vector2 fullscreenButtonSize(Vector2 gameSize) =>
      Vector2.all(gameSize.y * 0.07);

  static Vector2 fullscreenButtonPosition(Vector2 gameSize) {
    final size = fullscreenButtonSize(gameSize);
    final margin = Vector2(gameSize.x * 0.02, gameSize.y * 0.02);
    return Vector2(gameSize.x - size.x - margin.x, margin.y);
  }
}
