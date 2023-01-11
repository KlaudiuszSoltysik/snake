import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

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
  String indicator = "";

  @override
  Widget build(BuildContext context) {
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);

    return Scaffold(
      body: SizedBox.expand(
        child: GestureDetector(
          onPanUpdate: (details) {
            if (details.delta.dx > 0) {
              setState(
                () {
                  indicator = "right";
                },
              );
            }

            if (details.delta.dx < 0) {
              setState(
                () {
                  indicator = "left";
                },
              );
            }

            if (details.delta.dy > 0) {
              setState(
                () {
                  indicator = "down";
                },
              );
            }

            if (details.delta.dy < 0) {
              setState(
                () {
                  indicator = "up";
                },
              );
            }
          },
          child: Text(),
        ),
      ),
    );
  }
}

class Grid extends StatefulWidget {
  const Grid({Key? key}) : super(key: key);

  @override
  State<Grid> createState() => _GridState();
}

class _GridState extends State<Grid> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Row(
          children: [],
        )
      ],
    );
  }
}
