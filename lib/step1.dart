import 'package:flame/game.dart';
import 'package:flutter/material.dart';

/// The basic setup, a blank game engine.
class ShipsAndRocks extends StatelessWidget {
  const ShipsAndRocks({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: GameWidget(game: ShipsAndRocksGame()),
    );
  }
}

class ShipsAndRocksGame extends FlameGame {
  @override
  Future<void> onLoad() async {}

  @override
  Color backgroundColor() => Colors.grey[800]!;
}
