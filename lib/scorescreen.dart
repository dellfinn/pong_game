import 'package:flutter/material.dart';

class Scorescreen extends StatelessWidget {
  final bool gameHasStarted;
  // ignore: prefer_typing_uninitialized_variables
  final enemyScore;
  // ignore: prefer_typing_uninitialized_variables
  final playerScore;

  Scorescreen(
      {required this.gameHasStarted,
      required this.enemyScore,
      required this.playerScore});
  @override
  Widget build(BuildContext context) {
    return gameHasStarted
        ? Stack(
            children: [
              Container(
                alignment: Alignment(0, 0),
                child: Container(
                  height: 1,
                  width: MediaQuery.of(context).size.width / 4,
                  color: Colors.grey[800],
                ),
              ),
              Container(
                alignment: Alignment(0, -0.2),
                child: Text(
                  enemyScore.toString(),
                  style: TextStyle(color: Colors.grey[800], fontSize: 100),
                ),
              ),
              Container(
                alignment: Alignment(0, 0.2),
                child: Text(
                  playerScore.toString(),
                  style: TextStyle(color: Colors.grey[800], fontSize: 100),
                ),
              ),
            ],
          )
        : Container();
  }
}
