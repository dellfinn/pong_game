import 'package:avatar_glow/avatar_glow.dart';
import 'package:flutter/material.dart';

class MyBall extends StatelessWidget {
  final double x;
  final double y;
  final bool gameHasStarted;
   MyBall({required this.x, required this.y,required this.gameHasStarted});
  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment(x, y),
      child: AvatarGlow(
        endRadius: 30.00,
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            shape: BoxShape.circle,
          ),
          width: 20,
          height: 20,
        ),
      ),
    );
  }
}
