import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:simple_pacman_game/barriers.dart';
import 'package:simple_pacman_game/ghost.dart';
import 'package:simple_pacman_game/pixel.dart';
import 'package:simple_pacman_game/pacman.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  static int numberInRow = 11;
  int numberOfSquares = numberInRow * 14;
  int player = numberInRow * 12 + 1;
  int ghost = numberInRow * 2 - 2;
  bool mouthClosed = false;
  int score = 0;
  List<int> barriers = [
    0,
    1,
    2,
    3,
    4,
    5,
    6,
    7,
    8,
    9,
    10,
    11,
    22,
    33,
    44,
    55,
    66,
    88,
    99,
    110,
    121,
    132,
    143,
    144,
    145,
    146,
    147,
    148,
    149,
    150,
    151,
    152,
    153,
    142,
    131,
    120,
    109,
    98,
    76,
    65,
    54,
    43,
    32,
    21,
    67,
    68,
    69,
    70,
    72,
    73,
    74,
    75,
    89,
    90,
    91,
    92,
    94,
    95,
    96,
    97,
    114,
    115,
    116,
    125,
    127,
    112,
    123,
    118,
    129,
    26,
    28,
    37,
    38,
    39,
    59,
    61,
    30,
    41,
    52,
    24,
    35,
    46,
  ];

  List<int> food = [];

  void getFood() {
    for (int i = 0; i < numberOfSquares; i++) {
      if (!barriers.contains(i)) {
        food.add(i);
      }
    }
  }

  String direction = "right";
  bool gameStarted = false;

  void startGame() {
    moveGhost();
    gameStarted = true;
    getFood();
    Duration duration = const Duration(milliseconds: 120);
    Timer.periodic(duration, (timer) {
      setState(() {
        mouthClosed = !mouthClosed;
      });

      if (food.contains(player)) {
        food.remove(player);
        score++;
      }
      if (player == ghost) {
        ghost = -1;
      }
      switch (direction) {
        case "right":
          moveRight();
          break;

        case "up":
          moveUp();

          break;

        case "left":
          moveLeft();

          break;

        case "down":
          moveDown();

          break;
      }
    });
  }

  String ghostDirection = "left"; // initial
  void moveGhost() {
    Duration ghostSpeed = const Duration(milliseconds: 500);
    Timer.periodic(ghostSpeed, (timer) {
      if (!barriers.contains(ghost - 1) && ghostDirection != "right") {
        ghostDirection = "left";
      } else if (!barriers.contains(ghost - numberInRow) &&
          ghostDirection != "down") {
        ghostDirection = "up";
      } else if (!barriers.contains(ghost + numberInRow) &&
          ghostDirection != "up") {
        ghostDirection = "down";
      } else if (!barriers.contains(ghost + 1) && ghostDirection != "left") {
        ghostDirection = "right";
      }

      switch (ghostDirection) {
        case "right":
          setState(() {
            ghost++;
          });
          break;

        case "up":
          setState(() {
            ghost -= numberInRow;
          });
          break;

        case "left":
          setState(() {
            ghost--;
          });
          break;

        case "down":
          setState(() {
            ghost += numberInRow;
          });
          break;
      }
    });
  }

  void moveRight() {
    setState(() {
      if (!barriers.contains(player + 1)) {
        player += 1;
      }
    });
  }

  void moveUp() {
    setState(() {
      if (!barriers.contains(player - numberInRow)) {
        player -= numberInRow;
      }
    });
  }

  void moveLeft() {
    setState(() {
      if (!barriers.contains(player - 1)) {
        player -= 1;
      }
    });
  }

  void moveDown() {
    setState(() {
      if (!barriers.contains(player + numberInRow)) {
        player += numberInRow;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.black,
        body: Column(
          children: [
            Expanded(
              flex: 5,
              child: GestureDetector(
                onVerticalDragUpdate: (details) {
                  if (details.delta.dy > 0) {
                    direction = "down";
                  } else if (details.delta.dy < 0) {
                    direction = "up";
                  }
                },
                onHorizontalDragUpdate: (details) {
                  if (details.delta.dx > 0) {
                    direction = "right";
                  } else if (details.delta.dx < 0) {
                    direction = "left";
                  }
                },
                child: GridView.builder(
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: numberOfSquares,
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: numberInRow,
                  ),
                  itemBuilder: (BuildContext context, int index) {
                    if (mouthClosed && player == index) {
                      return Padding(
                        padding: const EdgeInsets.all(4),
                        child: Container(
                          decoration: const BoxDecoration(
                            color: Colors.yellow,
                            shape: BoxShape.circle,
                          ),
                        ),
                      );
                    } else if (player == index) {
                      switch (direction) {
                        case "left":
                          return Transform.rotate(
                            angle: pi,
                            child: const Pacman(),
                          );
                        case "right":
                          return const Pacman();
                        case "up":
                          return Transform.rotate(
                            angle: 3 * pi / 2,
                            child: const Pacman(),
                          );
                        case "down":
                          return Transform.rotate(
                            angle: pi / 2,
                            child: const Pacman(),
                          );
                        default:
                          return const Pacman();
                      }
                    } else if (ghost == index) {
                      return const Ghost();
                    } else if (barriers.contains(index)) {
                      return MyBarrier(
                        innerColor: Colors.blue.shade800,
                        outerColor: Colors.blue.shade900,
                        //child: Text(index.toString()),
                      );
                    } else if (food.contains(index) || !gameStarted) {
                      return const MyPixel(
                        innerColor: Colors.yellow,
                        outerColor: Colors.black,
                        //child: Text(index.toString()),
                      );
                    } else {
                      return const MyPixel(
                        innerColor: Colors.black,
                        outerColor: Colors.black,
                        //child:x Text(inde.toString()),
                      );
                    }
                  },
                ),
              ),
            ),
            Expanded(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Text(
                    "Score: $score",
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 40,
                    ),
                  ),
                  GestureDetector(
                    onTap: startGame,
                    child: const Text(
                      "P L A Y",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 40,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
