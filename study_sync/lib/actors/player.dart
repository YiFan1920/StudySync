import 'dart:async';

import 'package:flame/components.dart';
import 'package:productivity_app_v1/data/players.dart';
import 'package:productivity_app_v1/ui/screens/focus_room_screen/widgets/my_game.dart';

enum PlayerState { idle, studying, sleeping, relax }

class Player extends SpriteAnimationGroupComponent with HasGameRef<MyGame> {
  Player({position, required this.character}) : super(position: position);
  String character;
  late final SpriteAnimation idleAnimation;
  late final SpriteAnimation studyAnimation;
  late final SpriteAnimation sleepingAnimation;
  late final SpriteAnimation relaxAnimation;
  final double stepTime = 0.4;
  final Vector2 idleAnimationSize = Vector2(60, 60);
  final Vector2 studyAnimationSize = Vector2(64, 64);
  final Vector2 sleepingAnimationSize = Vector2(109, 109);
  final Vector2 relaxAnimationSize = Vector2(100, 100);

  @override
  FutureOr<void> onLoad() {
    _loadAllAnimations();

    // Set the size of the sprite component
    size = idleAnimationSize; // Resize the sprite to 64x64 pixels
    current = PlayerState.idle;

    return super.onLoad();
  }

  @override
  void update(double dt) {
    // TODO: implement update
    super.update(dt);

    if (current == PlayerState.idle) {
      size = idleAnimationSize;
    }
    if (current == PlayerState.studying) {
      size = studyAnimationSize;
    }
    if (current == PlayerState.sleeping) {
      size = sleepingAnimationSize;
    }
    if (current == PlayerState.relax) {
      size = relaxAnimationSize;
    }
  }

  void _loadAllAnimations() {
    idleAnimation =
        _spriteAnimation("${character}_sprite_idle.png", 4, stepTime);

    studyAnimation =
        _spriteAnimation("${character}_sprite_study.png", 6, stepTime);

    sleepingAnimation =
        _spriteAnimation("${character}_sprite_sleeping.png", 8, stepTime);

    relaxAnimation = _spriteAnimation("${character}_sprite_couch.png", 6, 0.2);

    // List of all animations
    animations = {
      PlayerState.idle: idleAnimation,
      PlayerState.studying: studyAnimation,
      PlayerState.sleeping: sleepingAnimation,
      PlayerState.relax: relaxAnimation
    };

    // Set current animation
    // current = PlayerState.studying;
  }

  SpriteAnimation _spriteAnimation(
      String spriteLink, int amount, double stepTime) {
    return SpriteAnimation.fromFrameData(
        game.images.fromCache(spriteLink),
        SpriteAnimationData.sequenced(
            amount: amount,
            stepTime: stepTime,
            textureSize: Vector2(200, 200)));
  }

  /// Method to change animation
  void setAnimation(PlayerState state) {
    if (current != state) {
      current = state;
    }
  }
}
