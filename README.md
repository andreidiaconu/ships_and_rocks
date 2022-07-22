# ships_and_rocks

A Flutter game powered by Flame that works nicely on foldable devices.

## Project structure

This project contains 11 steps. The project is meant to be used in a talk or tutorial and was used in the talk called ["Making a controller for my Flutter Game"](https://www.youtube.com/watch?v=0yq_zlRelWY&t=13913s).

1. The basic setup, a blank game engine.
2. We add a ship to the game. It sits in the middle of the screen, does not move yet.
3. We add a joystick to the game.
4. We make the joystick control the ship, making sure the ship does not ever leave the screen.
5. We add a few rocks.
6. We add collision to the ship and rocks.
7. We make the ship shoot bullets.
8. We make the rocks break in half when shot with a bullet or disappear if they are small.
9. We separate the controls and the game. Components no longer use gameRef for size or component changes, but use the parent instead. Game stays the same.
10. When the device has a hinge, we make the game and controls each take one screen. This is all done in the game engine.
11. Moving the controls out of the game and rendering them in a second game while using TwoPane to decide when to show only one or both.

The game works well on foldable devices on step 10 and 11 and they are both offered as alternatives: Step 11 uses TwoPane, while step 10 uses game objects for the foldable enhancements.
