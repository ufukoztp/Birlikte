import 'package:flutter/material.dart';

class MyBird extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 60,
      width: 60,
      child: Image.asset(
        'lib/flappy_bird_game/images/flappybird.png'
      ),
    );
  }
}