import 'dart:math';
import 'package:flutter/material.dart';

class ConfettiAnimation extends StatefulWidget {
  final Duration duration;

  const ConfettiAnimation(
      {Key? key, this.duration = const Duration(seconds: 3)})
      : super(key: key);

  @override
  _ConfettiAnimationState createState() => _ConfettiAnimationState();
}

class _ConfettiAnimationState extends State<ConfettiAnimation>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  List<Confetti> confetti = [];

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this, duration: widget.duration);
    _controller.addListener(() {
      for (var c in confetti) {
        c.update();
      }
      setState(() {});
    });
    _controller.forward();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (confetti.isEmpty) {
      final size = MediaQuery.of(context).size;
      for (int i = 0; i < 50; i++) {
        confetti.add(Confetti(screenSize: size));
      }
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return CustomPaint(
          painter:
              ConfettiPainter(confetti: confetti, progress: _controller.value),
          child: Container(),
        );
      },
    );
  }
}

class Confetti {
  late double x;
  late double y;
  late Color color;
  late double size;
  late double velocity;
  late double angle;

  Confetti({required Size screenSize}) {
    reset(screenSize);
  }

  void reset(Size screenSize) {
    x = Random().nextDouble() * screenSize.width;
    y = Random().nextDouble() * screenSize.height / 2 - screenSize.height / 2;
    color = Colors.primaries[Random().nextInt(Colors.primaries.length)];
    size = Random().nextDouble() * 10 + 5;
    velocity = Random().nextDouble() * 20 + 10;
    angle = Random().nextDouble() * pi / 4 - pi / 8;
  }

  void update() {
    y += velocity;
    x += sin(angle) * velocity / 2;
  }
}

class ConfettiPainter extends CustomPainter {
  final List<Confetti> confetti;
  final double progress;

  ConfettiPainter({required this.confetti, required this.progress});

  @override
  void paint(Canvas canvas, Size size) {
    for (var c in confetti) {
      if (c.y > size.height) {
        c.reset(size);
      }
      final paint = Paint()..color = c.color.withOpacity(1 - progress);
      canvas.drawCircle(Offset(c.x, c.y), c.size, paint);
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => true;
}
