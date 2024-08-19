import 'package:flutter/material.dart';
import 'dart:math';
import 'package:audioplayers/audioplayers.dart';

class AnimatedXO extends StatefulWidget {
  final String symbol;
  final Color color;

  const AnimatedXO({super.key, required this.symbol, required this.color});

  @override
  _AnimatedXOState createState() => _AnimatedXOState();
}

class _AnimatedXOState extends State<AnimatedXO>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;
  final AudioPlayer _audioPlayer = AudioPlayer();

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 1000), // Increased to 1 second
      vsync: this,
    );
    _animation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOutQuad),
    );
  //  if (AnimatedXO.symbo) == 'X'){
    _playSoundX();
    
    _controller.forward();
  }

  void _playSoundX() async {
    await _audioPlayer.play(AssetSource('sounds/pen_writing.mp3'));
  }

  @override
  void dispose() {
    _controller.dispose();
    _audioPlayer.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        return CustomPaint(
          painter: XOPainter(
            symbol: widget.symbol,
            progress: _animation.value,
            color: widget.color,
          ),
          size: Size.infinite,
        );
      },
    );
  }
}

class XOPainter extends CustomPainter {
  final String symbol;
  final double progress;
  final Color color;
  final Random random = Random();

  XOPainter(
      {required this.symbol, required this.progress, required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    if (symbol == 'X') {
      _drawX(canvas, size);
    } else if (symbol == 'O') {
      _drawO(canvas, size);
    }
  }

  void _drawX(Canvas canvas, Size size) {
    final path1 = _createHumanLikeXPath(
      Offset(size.width * 0.2, size.height * 0.2),
      Offset(size.width * 0.8, size.height * 0.8),
    );
    final path2 = _createHumanLikeXPath(
      Offset(size.width * 0.8, size.height * 0.2),
      Offset(size.width * 0.2, size.height * 0.8),
    );

    if (progress < 0.7) {
      // Draw the first stroke
      _drawAnimatedPath(canvas, path1, 0, 0.5);
    } else {
      // Draw the first stroke completely
      _drawAnimatedPath(canvas, path1, 0, 0.6);
      // Draw the second stroke
      double randomNumberX = 0 + random.nextDouble() * 0.1;
      _drawAnimatedPath(canvas, path2, randomNumberX, 1);
    }
  }

  void _drawO(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width * 0.35;
    final path = _createHumanLikeOPath(center, radius);
    var random = Random();
    double randomNumberO = 0.9 + random.nextDouble() * 0.1;
    double randomNumberO1 = 0 + random.nextDouble() * 0.1;
    _drawAnimatedPath(canvas, path, randomNumberO1, randomNumberO);
  }

  Path _createHumanLikeXPath(Offset start, Offset end) {
    final path = Path();
    path.moveTo(start.dx, start.dy);
    const numSegments = 3;
    const baseControlOffset = 5.0;

    for (int i = 0; i < numSegments; i++) {
      final t = (i + 1) / numSegments;
      final point = Offset(
        start.dx + (end.dx - start.dx) * t,
        start.dy + (end.dy - start.dy) * t,
      );

      final controlPoint1 = Offset(
        start.dx +
            (end.dx - start.dx) * (t - 0.1) +
            (random.nextDouble() - 0.5) * baseControlOffset,
        start.dy +
            (end.dy - start.dy) * (t - 0.1) +
            (random.nextDouble() - 0.5) * baseControlOffset,
      );

      final controlPoint2 = Offset(
        start.dx +
            (end.dx - start.dx) * (t + 0.1) +
            (random.nextDouble() - 0.5) * baseControlOffset,
        start.dy +
            (end.dy - start.dy) * (t + 0.1) +
            (random.nextDouble() - 0.5) * baseControlOffset,
      );

      path.cubicTo(
        controlPoint1.dx,
        controlPoint1.dy,
        controlPoint2.dx,
        controlPoint2.dy,
        point.dx,
        point.dy,
      );
    }
    return path;
  }

  Path _createHumanLikeOPath(Offset center, double radius) {
    final path = Path();
    const startAngle = -pi / 2;
    path.moveTo(
      center.dx + radius * cos(startAngle),
      center.dy + radius * sin(startAngle),
    );

    const numSegments = 8;
    for (int i = 0; i < numSegments; i++) {
      final endAngle = startAngle + (i + 1) * 2 * pi / numSegments;
      final controlAngle1 = startAngle + (i + 0.3) * 2 * pi / numSegments;
      final controlAngle2 = startAngle + (i + 0.7) * 2 * pi / numSegments;

      final endPoint = Offset(
        center.dx + radius * cos(endAngle),
        center.dy + radius * sin(endAngle),
      );

      final controlPoint1 = Offset(
        center.dx +
            radius * 1.1 * cos(controlAngle1) +
            (random.nextDouble() - 0.5) * 5,
        center.dy +
            radius * 1.1 * sin(controlAngle1) +
            (random.nextDouble() - 0.5) * 5,
      );

      final controlPoint2 = Offset(
        center.dx +
            radius * 1.1 * cos(controlAngle2) +
            (random.nextDouble() - 0.5) * 5,
        center.dy +
            radius * 1.1 * sin(controlAngle2) +
            (random.nextDouble() - 0.5) * 5,
      );

      path.cubicTo(
        controlPoint1.dx,
        controlPoint1.dy,
        controlPoint2.dx,
        controlPoint2.dy,
        endPoint.dx,
        endPoint.dy,
      );
    }
    return path;
  }

  void _drawAnimatedPath(
      Canvas canvas, Path path, double startProgress, double endProgress) {
    double randomWidth = 10 + random.nextDouble() * 20;

    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = randomWidth
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round;

    final pathMetric = path.computeMetrics().first;
    final totalLength = pathMetric.length;

    final start = totalLength * startProgress;
    final end = totalLength *
        ((progress - startProgress) / (endProgress - startProgress));

    if (end > start) {
      final animatedPath = pathMetric.extractPath(start, end);

      // Add subtle shake effect
      canvas.save();
      final shake = sin(progress * 15) * 0.3;
      canvas.translate(shake, shake);

      // Vary stroke width slightly
      paint.strokeWidth = 10.0 + sin(progress * 25) * 1.0;

      canvas.drawPath(animatedPath, paint);
      canvas.restore();
    }
  }

  @override
  bool shouldRepaint(covariant XOPainter oldDelegate) {
    return oldDelegate.progress != progress || oldDelegate.symbol != symbol;
  }
}
