import 'package:flutter/cupertino.dart' show Widget, PageRouteBuilder, Route, Tween, Curves, CurveTween, ScaleTransition, FadeTransition;

class AppTransitions {
  static Route fadeScale(Widget page) {
    return PageRouteBuilder(
      transitionDuration: const Duration(milliseconds: 400),
      pageBuilder: (context, animation, _) => page,
      transitionsBuilder: (context, animation, _, child) {
        final fadeTween = Tween<double>(begin: 0, end: 1)
            .chain(CurveTween(curve: Curves.easeIn));
        final scaleTween = Tween<double>(begin: 0.92, end: 1)
            .chain(CurveTween(curve: Curves.easeOutCubic));

        return FadeTransition(
          opacity: animation.drive(fadeTween),
          child: ScaleTransition(
            scale: animation.drive(scaleTween),
            child: child,
          ),
        );
      },
    );
  }
}