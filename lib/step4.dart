import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flame/game.dart';
import 'package:flame/palette.dart';
import 'package:flutter/material.dart';

/// We make the joystick control the ship, making sure the ship does not ever
/// leave the screen.
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

class ShipsAndRocksGame extends FlameGame with HasDraggables {
  late final JoystickComponent joystick;

  @override
  Future<void> onLoad() async {
    final knobPaint = BasicPalette.blue.withAlpha(200).paint();
    final backgroundPaint = BasicPalette.blue.withAlpha(100).paint();

    joystick = JoystickComponent(
      knob: CircleComponent(radius: 30, paint: knobPaint),
      background: CircleComponent(radius: 100, paint: backgroundPaint),
      margin: const EdgeInsets.only(left: 40, bottom: 40),
    );

    add(Ship(joystick));
    add(joystick);
  }

  @override
  Color backgroundColor() => Colors.grey[800]!;
}

void ensureVisible(Vector2 position, Vector2 size) {
  if (position.x > size.x) {
    position.x = 0;
  }
  if (position.x < 0) {
    position.x = size.x;
  }
  if (position.y > size.y) {
    position.y = 0;
  }
  if (position.y < 0) {
    position.y = size.y;
  }
}

class Ship extends SpriteComponent with HasGameRef {
  double maxSpeed = 300.0;
  final JoystickComponent joystick;

  Ship(this.joystick) : super(size: Vector2(46, 84.0), anchor: Anchor.center);

  @override
  Future<void> onLoad() async {
    sprite = await gameRef.loadSprite('ship.png');
    position = gameRef.size / 2;
    add(RectangleHitbox());
  }

  @override
  void update(double dt) {
    super.update(dt);
    if (!joystick.delta.isZero()) {
      position.add(joystick.relativeDelta * maxSpeed * dt);
      angle = joystick.delta.screenAngle();
    }
    ensureVisible(position, gameRef.size);
  }
}