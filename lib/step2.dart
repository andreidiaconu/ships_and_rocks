import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flame/game.dart';
import 'package:flutter/material.dart';

/// We add a ship to the game. It sits in the middle of the screen, does not
/// move yet.
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
  Future<void> onLoad() async {
    add(Ship());
  }

  @override
  Color backgroundColor() => Colors.grey[800]!;
}

class Ship extends SpriteComponent with HasGameRef {
  Ship() : super(size: Vector2(46, 84.0), anchor: Anchor.center);

  @override
  Future<void> onLoad() async {
    sprite = await gameRef.loadSprite('ship.png');
    position = gameRef.size / 2;
    add(RectangleHitbox());
  }
}
