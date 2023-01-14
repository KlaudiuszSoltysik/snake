import 'dart:async';
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
  int points = 0;
  IconData signal = Icons.arrow_upward_sharp;
  List<List<int>> snake = [
    [5, 5],
    [6, 5],
    [7, 5]
  ];
  List<Container> grid = [];
  Timer? timer;

  @override
  void initState() {
    Timer.periodic(Duration(seconds: 1), (Timer t) => gameTick());
    gameTick();
    super.initState();
  }

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }

  void gameTick() {
    grid = [];

    setState(() {
      for (List<int> pair in snake) {
        pair[0]--;
      }

      for (int i = 0; i < 121; i++) {
        int row = (i / 11).floor();
        int col = i % 11;

        for (List<int> pair in snake) {
          int snakeRow = pair[0];
          int snakeCol = pair[1];

          if ((snakeRow == row) && (snakeCol == col)) {
            grid.add(Container(
              decoration: BoxDecoration(
                color: Colors.greenAccent,
                border: Border.all(color: Color(0xFF383434), width: 2),
              ),
            ));
            break;
          }
        }

        if (!grid.asMap().containsKey(i)) {
          grid.add(Container(
            decoration: BoxDecoration(
              border: Border.all(color: Colors.greenAccent, width: 2),
            ),
          ));
        }
      }
    });
  }

  // else {
  // grid.add(Container(
  // decoration: BoxDecoration(
  // border: Border.all(color: Colors.greenAccent, width: 2),
  // ),
  // ));
  // }

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
      body: SizedBox.expand(
        child: Swipe(
          onSwipeUp: () {
            if (indicator != 'down') {
              setState(() {
                indicator = 'up';
              });
            }
          },
          onSwipeDown: () {
            if (indicator != 'up') {
              setState(() {
                indicator = 'down';
              });
            }
          },
          onSwipeLeft: () {
            if (indicator != 'right') {
              setState(() {
                indicator = 'left';
              });
            }
          },
          onSwipeRight: () {
            if (indicator != 'left') {
              setState(() {
                indicator = 'right';
              });
            }
          },
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Expanded(
                child: Center(
                  child: Text(
                    style: TextStyle(fontSize: 70),
                    points.toString(),
                  ),
                ),
              ),
              Expanded(
                flex: 2,
                child: GridView.count(
                  physics: NeverScrollableScrollPhysics(),
                  crossAxisCount: 11,
                  children: grid,
                ),
              ),
              Expanded(
                child: Icon(
                  signal,
                  size: 100,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
