import 'package:flutter/material.dart';

class CustomPageRoute extends PageRouteBuilder {
  final Widget child;
  final String transition;
  CustomPageRoute({required this.child, this.transition = "scale"})
      : super(
            transitionDuration: Duration(
                milliseconds:
                    transition == "slide left" || transition == "slide right"
                        ? 700
                        : 500),
            pageBuilder: (context, animation, secondaryAnimation) => child);

  @override
  Widget buildTransitions(BuildContext context, Animation<double> animation,
      Animation<double> secondaryAnimation, Widget child) {
    if (transition == "slide right") {
      return SlideTransition(
        position: Tween<Offset>(begin: const Offset(-1, 0), end: Offset.zero)
            .animate(animation),
        child: child,
      );
    } else if (transition == "slide left") {
      return SlideTransition(
        position: Tween<Offset>(begin: const Offset(2, 0), end: Offset.zero)
            .animate(animation),
        child: child,
      );
    } else if (transition == "slide up") {
      return SlideTransition(
        position: Tween<Offset>(begin: const Offset(0, 2), end: Offset.zero)
            .animate(animation),
        child: child,
      );
    } else {
      return ScaleTransition(
        scale: animation,
        child: child,
      );
    }
  }
}
