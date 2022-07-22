import 'dart:math';

import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flame/effects.dart';
import 'package:flame/game.dart';
import 'package:flame/input.dart';
import 'package:flame/palette.dart';
import 'package:flutter/material.dart';

/// We make the ship shoot bullets.
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

class ShipsAndRocksGame extends FlameGame
    with HasDraggables, HasCollisionDetection, HasTappables {
  late final JoystickComponent joystick;
  late final HudButtonComponent button;

  @override
  Future<void> onLoad() async {
    final knobPaint = BasicPalette.blue.withAlpha(200).paint();
    final backgroundPaint = BasicPalette.blue.withAlpha(100).paint();

    joystick = JoystickComponent(
      knob: CircleComponent(radius: 30, paint: knobPaint),
      background: CircleComponent(radius: 100, paint: backgroundPaint),
      margin: const EdgeInsets.only(left: 40, bottom: 40),
    );
    button = HudButtonComponent(
      button: CircleComponent(radius: 50, paint: knobPaint),
      margin: const EdgeInsets.only(right: 40, bottom: 40),
    );

    add(Ship(joystick, button));

    addRandomRock();
    addRandomRock();
    addRandomRock();

    add(joystick);
    add(button);
  }

  @override
  Color backgroundColor() => Colors.grey[800]!;

  void addRandomRock() {
    add(Rock(Vector2.random()..multiply(size), Vector2.all(100)));
  }
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

class Ship extends SpriteComponent with HasGameRef, CollisionCallbacks {
  double maxSpeed = 300.0;
  final JoystickComponent joystick;
  final HudButtonComponent button;

  Ship(this.joystick, this.button) : super(size: Vector2(46, 84.0), anchor: Anchor.center);

  @override
  Future<void> onLoad() async {
    sprite = await gameRef.loadSprite('ship.png');
    position = gameRef.size / 2;
    add(RectangleHitbox());
    button.onPressed = () {
      parent!.add(Bullet(position: position, angle: angle - pi/2));
    };
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

  @override
  void onCollisionStart(Set<Vector2> _, PositionComponent other) {
    super.onCollisionStart(_, other);
    if (other is Rock) {
      add(OpacityEffect.fadeOut(
        EffectController(
          duration: .1,
          reverseDuration: .1,
          infinite: false,
          repeatCount: 3,
        ),
      ));
    }
  }
}

class Rock extends PositionComponent with HasGameRef, CollisionCallbacks {
  late Vector2 velocity;

  Rock(Vector2 position, Vector2 size)
      : super(
          position: position,
          size: size,
          anchor: Anchor.center,
        );

  @override
  Future<void> onLoad() async {
    final defaultPaint = Paint()
      ..color = Colors.limeAccent
      ..style = PaintingStyle.fill;
    final hitbox = CircleHitbox()
      ..paint = defaultPaint
      ..renderShape = true;
    add(hitbox);
    velocity = Vector2.random() * 150;
  }

  @override
  void update(double dt) {
    super.update(dt);
    position.add(velocity * dt);
    ensureVisible(position, gameRef.size);
  }
}

class Bullet extends PositionComponent with HasGameRef {
  late Vector2 velocity;
  late double spawnTime;

  Bullet({
    required Vector2 position,
    required double angle,
  })  : velocity = Vector2(cos(angle), sin(angle)).scaled(500),
        super(
          position: position,
          size: Vector2.all(10),
          anchor: Anchor.center,
        );

  @override
  Future<void> onLoad() async {
    final defaultPaint = Paint()
      ..color = Colors.red
      ..style = PaintingStyle.fill;
    final hitbox = CircleHitbox()
      ..paint = defaultPaint
      ..renderShape = true;
    add(hitbox);
    spawnTime = gameRef.currentTime();
  }

  @override
  void update(double dt) {
    super.update(dt);
    if (gameRef.currentTime() > spawnTime + 1) {
      removeFromParent();
    }
    position.add(velocity * dt);
    ensureVisible(position, gameRef.size);
  }
}
