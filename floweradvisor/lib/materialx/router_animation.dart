import 'package:flutter/material.dart' show AnimatedWidget, Animation, BuildContext, CurvedAnimation, Curves, FadeTransition, Key, Offset, PageRouteBuilder, Route, SlideTransition, Transform, Tween, Widget;

Route slideRight({page}) {
  return PageRouteBuilder(
    pageBuilder: (context, animation, secondaryAnimation) => page,
    transitionDuration: const Duration(milliseconds: 500),
    reverseTransitionDuration: const Duration(milliseconds: 500),
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      var begin = const Offset(1.2, 0.0);
      var end = Offset.zero;
      var curve = Curves.easeOut;

      var tween = Tween(begin: begin, end: end);
      var curvedAnimation = CurvedAnimation(
        parent: animation,
        curve: curve,
      );

      return SlideTransition(
        position: tween.animate(curvedAnimation),
        child: child,
      );
    },
  );
}

Route fadeIn({page}) {
  return PageRouteBuilder(
    pageBuilder: (context, animation, secondaryAnimation) => page,
    transitionDuration: const Duration(milliseconds: 400),
    reverseTransitionDuration: const Duration(milliseconds: 400),
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      var begin = 0.0;
      var end = 1.0;
      var curve = Curves.easeInOut;

      var tween = Tween(begin: begin, end: end);
      var curvedAnimation = CurvedAnimation(
        parent: animation,
        curve: curve,
      );

      return FadeTransition(
        opacity: tween.animate(curvedAnimation),
        child: child,
      );
    },
  );
}

class AnimateTransition extends AnimatedWidget {
  static final _tansisi = Tween<double>(begin: 0, end: -100);
  final Widget child;
  const AnimateTransition({Key? key, required Animation<double> animation, required this.child}) : super(key: key, listenable: animation);
  @override
  Widget build(BuildContext context) {
    final animation = listenable as Animation<double>;
    return Transform.translate(
      offset: Offset(_tansisi.evaluate(animation), 0),
      child: child,
    );
  }
}

class AnimateRotation extends AnimatedWidget {
  const AnimateRotation({Key? key, required Animation<double> animation, required this.child, required this.angle}) : super(key: key, listenable: animation);
  final Tween<double> angle;
  final Widget child;
  @override
  Widget build(BuildContext context) {
    final animation = listenable as Animation<double>;
    return Transform.rotate(
      angle: angle.evaluate(animation),
      child: child,
    );
  }
}

class AnimateLoading extends AnimatedWidget {
  const AnimateLoading({Key? key, required Animation<double> animation, required this.child, required this.tween}) : super(key: key, listenable: animation);
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
