import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:snakegame/models/position.dart';

class GameProvider extends ChangeNotifier {
  static const int totalRows = 20;
  static const int totalColumns = 20;
  static const Duration tickDuration = Duration(milliseconds: 200);

  List<Position> snake = [Position(10, 10)];
  Position food = Position(5, 5);
  String direction = 'right';
  int score = 0;
  bool isGameOver = false;
  bool isPaused = false;

  late Timer gameLoop;

  GameProvider() {
    startGame();
  }

  void startGame() {
    resetGame();
    gameLoop = Timer.periodic(tickDuration, (_) async {
      if (!isPaused && !isGameOver) {
        await updateSnake();
      }
    });
  }

  Future<void> updateSnake() async {
    final head = snake.last;
    late Position newHead;

    switch (direction) {
      case 'up':
        newHead = Position(head.x, head.y - 1);
        break;
      case 'down':
        newHead = Position(head.x, head.y + 1);
        break;
      case 'left':
        newHead = Position(head.x - 1, head.y);
        break;
      default:
        newHead = Position(head.x + 1, head.y);
    }

    if (_isCollision(newHead)) {
      isGameOver = true;
      gameLoop.cancel();
      await saveScoreToSupabase();
      notifyListeners();
      return;
    }

    snake.add(newHead);

    if (newHead.equals(food)) {
      score++;
      spawnFood();
    } else {
      snake.removeAt(0);
    }
    notifyListeners();
  }

  bool _isCollision(Position pos) {
    return snake.any((part) => part.equals(pos)) ||
        pos.x < 0 ||
        pos.y < 0 ||
        pos.x >= totalColumns ||
        pos.y >= totalRows;
  }

  void spawnFood() {
    final random = Random();
    late Position newFood;
    /*Loop runs until the new food position is not same as the position that exists inside the snake list*/
    do {
      newFood = Position(
        random.nextInt(totalColumns),
        random.nextInt(totalRows),
      );
    } while (snake.any((p) => p.equals(newFood)));
    food = newFood;
  }

  void changeDirection(String newDirection) {
    /*Prevents the snake from turning directly into itself. For example: if we're going up, then directly we can't navigate to its opposite. For that we will navigate either left or right and then down*/
    bool oppositeDirection = (direction == 'up' && newDirection == 'down') ||
        (direction == 'down' && newDirection == 'up') ||
        (direction == 'left' && newDirection == 'right') ||
        (direction == 'right' && newDirection == 'left');

    if (oppositeDirection) return;

    direction = newDirection;
    notifyListeners();
  }

  void togglePause() {
    isPaused = !isPaused;
    notifyListeners();
  }

  void resetGame() {
    snake = [Position(10, 10)];
    food = Position(5, 5);
    direction = 'right';
    score = 0;
    isGameOver = false;
    isPaused = false;
    notifyListeners();
  }

  // Save score to Supabase if user is logged in
  Future<void> saveScoreToSupabase() async {
    final supabase = Supabase.instance.client;
    final user = supabase.auth.currentUser;

    if (user == null) return;

    try {
      await supabase.from('scores').insert({
        'user_id': user.id,
        'score': score,
        'played_at': DateTime.now().toIso8601String(),
      });
    } catch (e) {
      debugPrint("Error saving score: $e");
    }
  }
}
