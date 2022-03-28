import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:pong/ball.dart';
import 'package:pong/brick.dart';
import 'package:pong/coverscreen.dart';
import 'package:pong/scorescreen.dart';

class HomePage extends StatefulWidget {
  @override
  State<HomePage> createState() => _HomePageState();
}

enum direction { UP, DOWN, LEFT, RIGHT }

class _HomePageState extends State<HomePage> {
  //player variables bottom bricks
  double playerX = -0.2;
  double bricksWidth = 0.4; //out of 2
  int playerScore = 0;

  //enemy variables top bricks
  double enemyX = -0.2;
  int enemyScore = 0;

  //ball variables
  double ballX = 0;
  double ballY = 0;
  var ballYDirection = direction.DOWN;
  var ballXDirection = direction.LEFT;

  //game settings
  bool gameHasStarted = false;

  void startGame() {
    gameHasStarted = true;
    Timer.periodic(Duration(milliseconds: 50), (timer) {
      //update direction
      updateDirection();
      //moveball
      moveBall();
      //move enemy
       moveEnemy();
      //check if player is dead
      if (isPlayerDead()) {
        enemyScore++; //add enemy score
        timer.cancel();
        _showDialog(false);
      }
      if (isEnemyDead()) {
        playerScore++; //add player score
        timer.cancel();
        _showDialog(true);
      }
    });
  }

  bool isEnemyDead() {
    if (ballY <= -1) {
      return true;
    }
    return false;
  }

  void moveEnemy() {
    setState(() {
      enemyX = ballX;
    });
  }

  void _showDialog(bool enemyDead) {
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return AlertDialog(
            backgroundColor: Colors.deepPurple,
            title: Center(
              child: Text(
                enemyDead ? "GREEN WIN" : "PURPLE WIN",
                style: TextStyle(color: Colors.white),
              ),
            ),
            actions: [
              GestureDetector(
                onTap: resetGame,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(5),
                  child: Container(
                    padding: EdgeInsets.all(7),
                    color:
                        enemyDead ? Colors.green[100] : Colors.deepPurple[100],
                    child: Text(
                      'PLAY AGAIN',
                      style: TextStyle(
                        color: enemyDead
                            ? Colors.green[800]
                            : Colors.deepPurple[800],
                      ),
                    ),
                  ),
                ),
              ),
            ],
          );
        });
  }

  void resetGame() {
    Navigator.pop(context);
    setState(() {
      gameHasStarted = false;
      ballX = 0;
      ballY = 0;
      playerX = -0.2;
      enemyX = -0.2;
    });
  }

  bool isPlayerDead() {
    if (ballY >= 1) {
      return true;
    }
    return false;
  }

  void updateDirection() {
    setState(() {
      //update vertical direction
      if (ballY >= 0.9 && playerX + bricksWidth >= ballX && playerX <= ballX) {
        ballYDirection = direction.UP;
      } else if (ballY <= -0.9) {
        ballYDirection = direction.DOWN;
      }
      //update horizontal direction
      if (ballX >= 1.0) {
        ballXDirection = direction.LEFT;
      } else if (ballX <= -1.0) {
        ballXDirection = direction.RIGHT;
      }
    });
  }

  void moveBall() {
    setState(() {
      //vertical movement
      if (ballYDirection == direction.DOWN) {
        ballY += 0.1;
      } else if (ballYDirection == direction.UP) {
        ballY -= 0.1;
      }

      //horizontal movement
      if (ballXDirection == direction.LEFT) {
        ballX -= 0.1;
      } else if (ballXDirection == direction.RIGHT) {
        ballX += 0.1;
      }
    });
  }

  void moveLeft() {
    setState(() {
      if (!(playerX - bricksWidth <= -1.4)) {
        playerX -= 0.1;
      }
    });
  }

  void moveRight() {
    setState(() {
      if (!(playerX + bricksWidth >= 1)) {
        playerX += 0.1;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return RawKeyboardListener(
      focusNode: FocusNode(),
      autofocus: true,
      onKey: (event) {
        if (event.isKeyPressed(LogicalKeyboardKey.arrowLeft)) {
          moveLeft();
        } else if (event.isKeyPressed(LogicalKeyboardKey.arrowRight)) {
          moveRight();
        }
      },
      child: GestureDetector(
        onTap: startGame,
        child: Scaffold(
          backgroundColor: Colors.grey[900],
          body: Center(
            child: Stack(
              children: [
                //tap to play
                CoverScreen(
                  gameHasStarted: gameHasStarted,
                ),
                //scoreScreen
                Scorescreen(
                  enemyScore: enemyScore,
                  playerScore: playerScore,
                  gameHasStarted: gameHasStarted,
                ),

                //enemy top bricks
                MyBrick(
                  x: enemyX,
                  y: -0.9,
                  brickWidth: bricksWidth,
                  thisIsenemy: true,
                ),

                //enemy bottom bricks
                MyBrick(
                  x: playerX,
                  y: 0.9,
                  brickWidth: bricksWidth,
                  thisIsenemy: false,
                ),
                MyBall(
                  x: ballX,
                  y: ballY,
                  gameHasStarted: gameHasStarted,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
