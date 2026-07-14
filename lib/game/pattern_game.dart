import 'package:flame/components.dart';
import 'package:flame/game.dart';
import 'package:flutter/material.dart';

import 'components/background_component.dart';
import 'components/celebration_component.dart';
import 'components/center_line_component.dart';
import 'components/cloud_component.dart';
import 'components/draggable_shape_component.dart';
import 'components/fullscreen_button_component.dart';
import 'components/play_button_component.dart';
import 'components/reference_panel_component.dart';
import 'components/scoreboard_component.dart';
import 'components/slot_component.dart';
import 'model/game_round.dart';
import 'model/shape_kind.dart';

enum GameState { menu, playing }

class PatternGame extends FlameGame {
  GameState state = GameState.menu;
  int score = 0;
  GameRound? round;
  int _filledSlots = 0;

  late final ScoreboardComponent scoreboard;
  PlayButtonComponent? _playButton;
  CenterLineComponent? _centerLine;
  ReferencePanelComponent? _referencePanel;
  final List<SlotComponent> _slots = [];
  final List<DraggableShapeComponent> _trayPieces = [];

  @override
  Color backgroundColor() => const Color(0xFF87CEEB);

  @override
  Future<void> onLoad() async {
    add(BackgroundComponent()..priority = -10);
    add(
      CloudComponent(
        imageFile: 'cloud1.png',
        speed: 35,
        verticalFraction: 0.12,
        startFraction: 0.05,
      )..priority = -5,
    );
    add(
      CloudComponent(
        imageFile: 'cloud2.png',
        speed: -25,
        verticalFraction: 0.22,
        startFraction: 0.65,
      )..priority = -5,
    );

    scoreboard = ScoreboardComponent()..priority = 100;
    add(scoreboard);

    add(FullscreenButtonComponent()..priority = 100);

    _showMenu();
  }

  void _showMenu() {
    state = GameState.menu;
    _playButton = PlayButtonComponent(onPressed: startRound)..priority = 10;
    add(_playButton!);
  }

  void startRound() {
    _playButton?.removeFromParent();
    _playButton = null;

    round = GameRound.random();
    _filledSlots = 0;
    state = GameState.playing;

    _centerLine = CenterLineComponent()..priority = 1;
    add(_centerLine!);

    _slots.clear();
    for (var i = 0; i < round!.slots.length; i++) {
      final slot = SlotComponent(target: round!.slots[i], index: i)
        ..priority = 2;
      _slots.add(slot);
      add(slot);
    }

    _referencePanel = ReferencePanelComponent(pieces: round!.slots)
      ..priority = 5;
    add(_referencePanel!);

    _trayPieces.clear();
    for (var i = 0; i < round!.tray.length; i++) {
      final piece = DraggableShapeComponent(piece: round!.tray[i], index: i)
        ..priority = 3;
      _trayPieces.add(piece);
      add(piece);
    }
  }

  SlotComponent? findMatchingEmptySlot(Vector2 worldPosition, ShapePiece piece) {
    for (final slot in _slots) {
      if (slot.filled) continue;
      if (!slot.target.matches(piece)) continue;
      final distance = (worldPosition - slot.position).length;
      if (distance < slot.size.x * 0.75) return slot;
    }
    return null;
  }

  void onCorrectPlacement() {
    score += 10;
    scoreboard.updateScore(score);
    _filledSlots++;
    if (_filledSlots == _slots.length) {
      _onRoundComplete();
    }
  }

  void _onRoundComplete() {
    add(CelebrationComponent(center: size / 2));
    add(
      TimerComponent(
        period: 1.5,
        removeOnFinish: true,
        onTick: _endRound,
      ),
    );
  }

  void _endRound() {
    _centerLine?.removeFromParent();
    _referencePanel?.removeFromParent();
    for (final slot in _slots) {
      slot.removeFromParent();
    }
    for (final piece in _trayPieces) {
      piece.removeFromParent();
    }
    _slots.clear();
    _trayPieces.clear();
    _centerLine = null;
    _referencePanel = null;
    round = null;
    _showMenu();
  }
}
