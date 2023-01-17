import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:swipe/swipe.dart';

void main() {
  runApp(
    MaterialApp(
      title: 'snake',
      theme: ThemeData(
        brightness: Brightness.dark,
        primaryColor: Colors.blueGrey,
      ),
      home: Game(),
    ),
  );
}

class Game extends StatefulWidget {
  const Game({Key? key}) : super(key: key);

  @override
  State<Game> createState() => _GameState();
}

class _GameState extends State<Game> {
  String indicator = 'up';
  late String turn;
  int points = -1;
  int gridWidth = 11;
  late IconData signal;
  IconData pauseIcon = Icons.pause;
  Color color = Colors.greenAccent;
  List<Container> grid = [];
  List<List<int>> snake = [
    [5, 5],
    [5, 6],
    [5, 7]
  ];
  late int appleX;
  late int appleY;
  double speedMultiplayer = 1.1;
  bool gameOver = false;
  final random = Random();
  Timer? timer;

  @override
  void initState() {
    timer =
        Timer.periodic(Duration(milliseconds: 1000), (Timer t) => gameTick());
    for (int i = 0; i < 121; i++) {
      grid.add(Container(
        decoration: BoxDecoration(
          border: Border.all(color: color, width: 2),
        ),
      ));
    }
    randomizeApple();
    super.initState();
  }

  void randomizeApple() {
    //GENERATE ALL POSSIBLE COORDINATES
    List<List<int>> possible = [];

    for (int i = 0; i < 11; i++) {
      for (int j = 0; j < 11; j++) {
        possible.add([i, j]);
      }
    }

    //ITERATE THROUGH ALL COORDINATES AND FIND PROPER ONE
    while (true) {
      int i = random.nextInt(possible.length);
      int randomX = possible[i][0];
      int randomY = possible[i][1];

      bool isGood = false;

      for (List<int> pair in snake) {
        if (pair[0] == randomX && pair[1] == randomY) {
          possible.removeAt(i);
          break;
        }
        if (pair[0] == snake.last[0] && pair[1] == snake.last[1]) {
          isGood = true;
        }
      }

      if (isGood) {
        appleX = randomX;
        appleY = randomY;

        break;
      }
    }

    //SPEED UP
    speedMultiplayer -= 0.01;
    timer?.cancel();
    timer = Timer.periodic(
        Duration(milliseconds: (1000 * speedMultiplayer).floor()),
        (Timer t) => gameTick());

    //INCREMENT SCORE
    points++;
  }

  void gameTick() {
    setState(() {
      if (!gameOver) {
        grid = [];
        turn = indicator;

        if (turn == 'left') {
          List<int> head = snake[0];

          //SNAKE MOVEMENT AND COLLECTING APPLES
          if (head[0] - 1 == appleX && head[1] == appleY) {
            snake.insert(0, [appleX, appleY]);
            randomizeApple();
          } else {
            List<int> tail = snake.last;
            tail[0] = snake[0][0] - 1;
            tail[1] = snake[0][1];
            snake.removeLast();
            snake.insert(0, tail);
          }
        } else if (turn == 'right') {
          List<int> head = snake[0];

          if (head[0] + 1 == appleX && head[1] == appleY) {
            snake.insert(0, [appleX, appleY]);
            randomizeApple();
          } else {
            List<int> tail = snake.last;
            tail[0] = snake[0][0] + 1;
            tail[1] = snake[0][1];
            snake.removeLast();
            snake.insert(0, tail);
          }
        } else if (turn == 'up') {
          List<int> head = snake[0];

          if (head[0] == appleX && head[1] - 1 == appleY) {
            snake.insert(0, [appleX, appleY]);
            randomizeApple();
          } else {
            List<int> tail = snake.last;
            tail[0] = snake[0][0];
            tail[1] = snake[0][1] - 1;
            snake.removeLast();
            snake.insert(0, tail);
          }
        } else {
          List<int> head = snake[0];

          if (head[0] == appleX && head[1] + 1 == appleY) {
            snake.insert(0, [appleX, appleY]);
            randomizeApple();
          } else {
            List<int> tail = snake.last;
            tail[0] = snake[0][0];
            tail[1] = snake[0][1] + 1;
            snake.removeLast();
            snake.insert(0, tail);
          }
        }

        //CHANGE COLOR THEME DEPENDING ON SCORE
        if (points == 10) {
          color = Colors.tealAccent;
        } else if (points == 20) {
          color = Colors.cyanAccent;
        } else if (points == 30) {
          color = Colors.blueAccent;
        } else if (points == 40) {
          color = Colors.purpleAccent;
        } else if (points == 50) {
          color = Colors.pinkAccent;
        } else if (points == 60) {
          color = Colors.limeAccent;
        }

        //GENERATE GRID
        for (int i = 0; i < 121; i++) {
          int col = i % 11;
          int row = (i / 11).floor();

          //PLACE SNAKE
          for (List<int> pair in snake) {
            int snakeCol = pair[0];
            int snakeRow = pair[1];

            if ((snakeRow == row) && (snakeCol == col)) {
              grid.add(Container(
                decoration: BoxDecoration(
                  color: color,
                  border: Border.all(color: Color(0xFF383434), width: 2),
                ),
              ));
              break;
            }
          }

          //PLACE APPLE
          if (col == appleX && row == appleY) {
            grid.add(Container(
              decoration: BoxDecoration(
                color: Colors.redAccent,
                border: Border.all(color: color, width: 2),
              ),
            ));
          }

          //FULL EMPTY FIELDS
          if (!grid.asMap().containsKey(i)) {
            grid.add(Container(
              decoration: BoxDecoration(
                border: Border.all(color: color, width: 2),
              ),
            ));
          }
        }

        //CHECK IF SNAKE IS CROSSING HIMSELF
        for (int i = 1; i < snake.length; i++) {
          if (snake[0][0] == snake[i][0] && snake[0][1] == snake[i][1]) {
            gameOver = true;
          }
        }

        //CHECK IF SNAKE IS OUT OF THE GRID
        if (snake[0][0] == -1 ||
            snake[0][0] == 11 ||
            snake[0][1] == -1 ||
            snake[0][1] == 11) {
          gameOver = true;
        }
      } else {
        grid = [];
        grid.add(
          Container(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                Text(
                  'You lost!',
                  style: TextStyle(fontSize: 70),
                ),
                TextButton(
                  onPressed: () {
                    setState(() {
                      timer?.cancel();
                      indicator = 'up';
                      points = -1;
                      gridWidth = 11;
                      pauseIcon = Icons.pause;
                      color = Colors.greenAccent;
                      grid = [];
                      snake = [
                        [5, 5],
                        [5, 6],
                        [5, 7]
                      ];
                      speedMultiplayer = 1.1;
                      gameOver = false;
                      initState();
                    });
                  },
                  child: Text(
                    'New game',
                    style: TextStyle(fontSize: 70, color: Colors.white),
                  ),
                ),
              ],
            ),
          ),
        );
        gridWidth = 1;
        signal = Icons.dangerous;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);

    if (indicator == 'left') {
      signal = Icons.arrow_back_sharp;
    } else if (indicator == 'right') {
      signal = Icons.arrow_forward_sharp;
    } else if (indicator == 'up') {
      signal = Icons.arrow_upward_sharp;
    } else {
      signal = Icons.arrow_downward_sharp;
    }

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          'Snake',
          style: TextStyle(fontSize: 35),
        ),
        leading: IconButton(
          icon: Icon(
            pauseIcon,
            size: 40,
          ),
          onPressed: () {
            if (timer!.isActive) {
              timer?.cancel();
              setState(() {
                pauseIcon = Icons.play_arrow;
              });
            } else {
              timer = Timer.periodic(
                  Duration(milliseconds: (1000 * speedMultiplayer).floor()),
                  (Timer t) => gameTick());
              setState(() {
                pauseIcon = Icons.pause;
              });
            }
          },
        ),
      ),
      body: SizedBox.expand(
        child: Swipe(
          onSwipeLeft: () {
            if (turn != 'right') {
              setState(() {
                indicator = 'left';
              });
            }
          },
          onSwipeRight: () {
            if (turn != 'left') {
              setState(() {
                indicator = 'right';
              });
            }
          },
          onSwipeUp: () {
            if (turn != 'down') {
              setState(() {
                indicator = 'up';
              });
            }
          },
          onSwipeDown: () {
            if (turn != 'up') {
              setState(() {
                indicator = 'down';
              });
            }
          },
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Expanded(
                flex: 2,
                child: Center(
                  child: Text(
                    style: TextStyle(fontSize: 100),
                    points.toString(),
                  ),
                ),
              ),
              Expanded(
                flex: 5,
                child: GridView.count(
                  physics: NeverScrollableScrollPhysics(),
                  crossAxisCount: gridWidth,
                  children: grid,
                ),
              ),
              Expanded(
                flex: 2,
                child: Icon(
                  signal,
                  size: 150,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
