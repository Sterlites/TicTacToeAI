import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import '../utils/constants.dart';
import 'login_screen.dart';

class SplashScreen extends StatefulWidget {
  static const String routeName = 'SplashScreen';

  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with TickerProviderStateMixin {
  late AnimationController _rdxController;
  late AnimationController _oController;
  late AnimationController _collisionController;
  late AnimationController _breatheController;

  @override
  void initState() {
    super.initState();
    // Initialize animation controllers
    _rdxController = AnimationController(
        duration: const Duration(milliseconds: 1500), vsync: this);
    _oController = AnimationController(
        duration: const Duration(milliseconds: 1000), vsync: this);
    _collisionController = AnimationController(
        duration: const Duration(milliseconds: 500), vsync: this);
    _breatheController = AnimationController(
        duration: const Duration(milliseconds: 1000), vsync: this)
      ..repeat(reverse: true);

    // Sequence the animations
    _rdxController
        .forward()
        .then((_) => _oController.forward())
        .then((_) => _collisionController.forward());

    // Navigate to LoginScreen after animation completes
    // RDX: Change total timer here
    Timer(const Duration(seconds: 6), () {
      Navigator.pushReplacementNamed(context, LoginScreen.routeName);
    });
  }

  @override
  void dispose() {
    _rdxController.dispose();
    _oController.dispose();
    _collisionController.dispose();
    _breatheController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppConstants.bgColor,
      body: Center(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Heroic reveal for "RDx"
            FadeTransition(
              opacity: _rdxController,
              child: SlideTransition(
                position: Tween<Offset>(
                  begin: const Offset(0, -0.5),
                  end: Offset.zero,
                ).animate(CurvedAnimation(
                    parent: _rdxController, curve: Curves.elasticOut)),
                child: Row(
                  children: [
                    Text(
                      'RD',
                      style:
                          AppConstants.customFontWhite.copyWith(fontSize: 80),
                    ),
                    AnimatedBuilder(
                      animation: _collisionController,
                      builder: (context, child) {
                        return Transform.translate(
                          offset: Offset(
                            sin(_collisionController.value * 4 * pi) * 5,
                            cos(_collisionController.value * 4 * pi) * 5 -7,
                          ),
                          child: child,
                        );
                      },
                      child: AnimatedBuilder(
                        animation: _breatheController,
                        builder: (context, child) {
                          return Transform.scale(
                            scale: 1 + _breatheController.value * 0.1,
                            child: Text(
                              'x',
                              style: AppConstants.customFontWhite.copyWith(
                                fontSize: 80,
                                shadows: [
                                  Shadow(
                                    blurRadius: 15,
                                    color: Colors.white
                                        .withOpacity(_breatheController.value),
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),
            // Bouncing and squiggling 'o'
            SlideTransition(
              position: Tween<Offset>(
                begin: const Offset(4, 0),
                end: Offset.zero,
              ).animate(CurvedAnimation(
                  parent: _oController, curve: Curves.bounceOut)),
              child: AnimatedBuilder(
                animation: _collisionController,
                builder: (context, child) {
                  return Transform.translate(
                    offset: Offset(
                      sin(_collisionController.value * 4 * pi) * 5,
                      cos(_collisionController.value * 4 * pi) * 5-7,
                    ),
                    child: child,
                  );
                },
                child: AnimatedBuilder(
                  animation: _breatheController,
                  builder: (context, child) {
                    return Transform.scale(
                      scale: 1 + _breatheController.value * 0.1,
                      child: Text(
                        'o',
                        style: AppConstants.customFontWhite.copyWith(
                          fontSize: 80,
                          shadows: [
                            Shadow(
                              blurRadius: 15,
                              color: Colors.white
                                  .withOpacity(_breatheController.value),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
