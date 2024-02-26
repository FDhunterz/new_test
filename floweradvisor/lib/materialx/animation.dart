import 'dart:async';

import 'package:flutter/cupertino.dart';

class ScaleAnimation extends StatefulWidget {
  final Widget child;
  final Duration? delay;
  const ScaleAnimation({Key? key, required this.child, this.delay}) : super(key: key);

  @override
  State<ScaleAnimation> createState() => _ScaleAnimationState();
}

class _ScaleAnimationState extends State<ScaleAnimation> with TickerProviderStateMixin {
  final tween = Tween(begin: 0.0, end: 1.0);
  late AnimationController controller;
  @override
  void initState() {
    super.initState();
    controller = AnimationController(vsync: this, duration: const Duration(milliseconds: 800), reverseDuration: const Duration(milliseconds: 600));
    Future.delayed(widget.delay ?? Duration.zero, () {
      controller.forward();
    });
  }

  @override
  void dispose() {
    controller.stop();
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimateScale(
      animation: tween.animate(CurvedAnimation(parent: controller, curve: Curves.elasticOut)),
      tween: tween,
      child: widget.child,
    );
  }
}

class AnimateScale extends AnimatedWidget {
  const AnimateScale({Key? key, required Animation<double> animation, required this.child, required this.tween}) : super(key: key, listenable: animation);
  final Tween<double> tween;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final animation = listenable as Animation<double>;
    return Transform.scale(
      scale: tween.evaluate(animation),
      child: child,
    );
  }
}

class FadeOutAnimation extends StatefulWidget {
  final Widget child;
  final Duration? delay;
  final Function(StreamController<bool>) active;
  const FadeOutAnimation({Key? key, required this.child, this.delay, required this.active}) : super(key: key);

  @override
  State<FadeOutAnimation> createState() => FadeOutAnimationState();
}

class FadeOutAnimationState extends State<FadeOutAnimation> with TickerProviderStateMixin {
  StreamController<bool> back = StreamController<bool>();
  final tween = Tween(begin: 0.0, end: 1.0);
  late AnimationController controller;
  @override
  void initState() {
    super.initState();
    controller = AnimationController(vsync: this, duration: const Duration(milliseconds: 500), reverseDuration: const Duration(milliseconds: 500));

    Future.delayed(widget.delay ?? Duration.zero, () {
      start();
    });
    widget.active(back);
    back.stream.listen((event) {
      if (event) {
        controller.reverse();
      } else {
        Future.delayed(widget.delay ?? Duration.zero, () {
          start();
        });
      }
    });
  }

  @override
  void setState(VoidCallback fn) {
    super.setState(fn);
  }

  start() {
    controller.forward();
  }

  @override
  void dispose() {
    controller.stop();
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimateFadeOut(
      animation: tween.animate(CurvedAnimation(parent: controller, curve: Curves.easeInOut)),
      tween: tween,
      child: widget.child,
    );
  }
}

class AnimateFadeOut extends AnimatedWidget {
  const AnimateFadeOut({Key? key, required Animation<double> animation, required this.child, required this.tween}) : super(key: key, listenable: animation);
  final Tween<double> tween;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final animation = listenable as Animation<double>;
    return Opacity(
      opacity: (1 * animation.value),
      child: Transform.translate(
        offset: Offset(0, -100 + (100 * animation.value)),
        child: child,
      ),
    );
  }
}

class FadeOutBottomAnimation extends StatefulWidget {
  final Widget child;
  final Duration? delay;
  final Function(StreamController<bool>) active;
  const FadeOutBottomAnimation({Key? key, required this.child, this.delay, required this.active}) : super(key: key);

  @override
  State<FadeOutBottomAnimation> createState() => FadeOutBottomAnimationState();
}

class FadeOutBottomAnimationState extends State<FadeOutBottomAnimation> with TickerProviderStateMixin {
  StreamController<bool> back = StreamController<bool>();
  final tween = Tween(begin: 0.0, end: 1.0);
  late AnimationController controller;
  @override
  void initState() {
    super.initState();
    controller = AnimationController(vsync: this, duration: const Duration(milliseconds: 500), reverseDuration: const Duration(milliseconds: 500));

    Future.delayed(widget.delay ?? Duration.zero, () {
      start();
    });
    widget.active(back);
    back.stream.listen((event) {
      if (event) {
        controller.reverse();
      } else {
        Future.delayed(widget.delay ?? Duration.zero, () {
          start();
        });
      }
    });
  }

  @override
  void setState(VoidCallback fn) {
    super.setState(fn);
  }

  start() {
    controller.forward();
  }

  @override
  void dispose() {
    controller.stop();
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimateFadeOutBottom(
      animation: tween.animate(CurvedAnimation(parent: controller, curve: Curves.easeInOut)),
      tween: tween,
      child: widget.child,
    );
  }
}

class AnimateFadeOutBottom extends AnimatedWidget {
  const AnimateFadeOutBottom({Key? key, required Animation<double> animation, required this.child, required this.tween}) : super(key: key, listenable: animation);
  final Tween<double> tween;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final animation = listenable as Animation<double>;
    return Opacity(
      opacity: (1 * animation.value),
      child: Transform.translate(
        offset: Offset(0, 100 - (100 * animation.value)),
        child: child,
      ),
    );
  }
}
