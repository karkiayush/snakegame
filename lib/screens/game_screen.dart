import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:snakegame/models/position.dart';
import 'package:snakegame/providers/game_provider.dart';

class GameScreen extends StatefulWidget {
  const GameScreen({super.key});

  @override
  State<GameScreen> createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen> {
  @override
  Widget build(BuildContext context) {
    final game = Provider.of<GameProvider>(context);

    if (game.isGameOver) {
      /*addPostFrameCallback ensures that the current UI frame finished building and then only the dialog is shown containing restart and exit options*/
      WidgetsBinding.instance.addPostFrameCallback((_) {
        showDialog(
          context: context,
          /*I've set the barrierDismissible to false so that when user taps outside of the dialog container, it doesn't closes the dialog container*/
          barrierDismissible: false,
          builder: (_) => AlertDialog(
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            title: const Text("Game Over"),
            content: Text("Your score: ${game.score}"),
            actions: [
              TextButton(
                onPressed: () {
                  game.resetGame();
                  game.startGame();
                  Navigator.of(context).pop();
                },
                child: const Text("Play Again"),
              ),
              TextButton(
                onPressed: () {
                  Navigator.of(context).pushReplacementNamed('/menu');
                },
                child: const Text("Exit"),
              ),
            ],
          ),
        );
      });
    }

    return Scaffold(
      backgroundColor: Colors.grey[100],
      body: GestureDetector(
        onVerticalDragUpdate: (details) {
          /*the details objects contains the delta value which represents the change in position from last position.*/
          if (details.delta.dy < 0) game.changeDirection("up");
          if (details.delta.dy > 0) game.changeDirection("down");
        },
        onHorizontalDragUpdate: (details) {
          if (details.delta.dx < 0) game.changeDirection("left");
          if (details.delta.dx > 0) game.changeDirection("right");
        },
        child: SafeArea(
          child: Column(
            children: [
              const SizedBox(height: 16),
              // Score Bar
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(vertical: 12, horizontal: 24),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: const [
                      BoxShadow(
                          color: Colors.black12,
                          blurRadius: 10,
                          offset: Offset(0, 4))
                    ],
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text("Score: ${game.score}",
                          style: const TextStyle(
                              fontSize: 20, fontWeight: FontWeight.bold)),
                      ElevatedButton.icon(
                        onPressed: () => game.togglePause(),
                        icon: Icon(
                            game.isPaused ? Icons.play_arrow : Icons.pause),
                        label: Text(game.isPaused ? "Resume" : "Pause"),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: game.isPaused
                              ? Colors.green
                              : Colors.orangeAccent,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),

              // Grid Game Area
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: GridView.builder(
                    /*It ensure the GridView don't scroll as by default GridView is a scrollable widget*/
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount:
                        GameProvider.totalRows * GameProvider.totalColumns,
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: GameProvider.totalColumns,
                    ),
                    itemBuilder: (context, index) {
                      final x = index % GameProvider.totalColumns;
                      final y = index ~/ GameProvider.totalColumns;
                      final pos = Position(x, y);

                      final bool isSnake = game.snake.any((p) => p.equals(pos));
                      final bool isFood = game.food.equals(pos);

                      return AnimatedContainer(
                        duration: const Duration(milliseconds: 150),
                        margin: const EdgeInsets.all(1),
                        decoration: BoxDecoration(
                          color: isSnake
                              ? Colors.green[600]
                              : isFood
                                  ? Colors.redAccent
                                  : Colors.grey[200],
                          borderRadius: BorderRadius.circular(4),
                          boxShadow: isFood
                              ? [
                                  const BoxShadow(
                                    color: Colors.redAccent,
                                    blurRadius: 8,
                                    spreadRadius: 1,
                                  )
                                ]
                              : [],
                        ),
                      );
                    },
                  ),
                ),
              ),
              const SizedBox(height: 12),
              const Text(
                "Swipe to Control Snake ⬆️⬇️⬅️➡️",
                style: TextStyle(
                    fontStyle: FontStyle.italic, color: Colors.black54),
              ),
              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }
}
