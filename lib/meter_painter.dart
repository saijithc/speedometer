import 'dart:math';
import 'package:flutter/material.dart';

class MeterPainter extends CustomPainter {
  final double percentage;

  MeterPainter({super.repaint, required this.percentage});
  @override
  void paint(Canvas canvas, Size size) {
    final height = size.height;
    final width = size.width;
    final centerX = width / 2;
    final centerY = height / 2;
    final center = Offset(centerX, centerY);
    final rect = Rect.fromCenter(
        center: center, width: width * 0.7, height: height * 0.7);
    final largeRect = Rect.fromCenter(
        center: center, width: width * 0.75, height: height * 0.75);
    //inner
    final paint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2
      ..color = Colors.grey;
    //outer thick
    final thickPaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 10
      ..color = Colors.grey.shade900;
    final startAngle = angleToRadian(135);
    final sweepAngle = angleToRadian(270);
    canvas.drawArc(rect, startAngle, sweepAngle, false, paint);
    canvas.drawArc(largeRect, startAngle, sweepAngle, false, thickPaint);
    final pointedSweepAngle = angleToRadian(270 * percentage / 100);
    canvas.drawArc(largeRect, startAngle, pointedSweepAngle, false,
        thickPaint..color = Colors.pink);
    final radius = width / 2;
    //lines
    for (num angle = 135; angle <= 405; angle += 4.5) {
      final start = angleToOffset(center, angle, radius * .7);
      final end = angleToOffset(center, angle, radius * .65);
      canvas.drawLine(start, end, paint);
    }
    // highlight line
    final highlight = List.generate(11, (index) => 135 + (27 * index));
    for (int i = 0; i < highlight.length; i++) {
      var angle = highlight[i];
      final start = angleToOffset(center, angle, radius * .7);
      final end = angleToOffset(center, angle, radius * .58);
      canvas.drawLine(start, end, paint);
      final tp = TextPainter(
          text: TextSpan(text: "${i * 10}"), textDirection: TextDirection.ltr);
      tp.layout();
      final textOffset = angleToOffset(center, angle, radius * .51);
      final textCenterd = Offset(
        textOffset.dx - tp.width / 2,
        textOffset.dy - tp.height / 2,
      );
      tp.paint(canvas, textCenterd);
    }
    final tp = TextPainter(
        text: TextSpan(
            text: "${percentage.toInt()}",
            style: const TextStyle(fontSize: 50),
            children: const [
              TextSpan(
                text: '\nKM/H',
                style: TextStyle(fontSize: 20),
              )
            ]),
        textAlign: TextAlign.center,
        textDirection: TextDirection.ltr);
    tp.layout();

    final textCenterd = Offset(
      center.dx - tp.width / 2,
      center.dy - tp.height / 2,
    );
    tp.paint(canvas, textCenterd);
  }

  Offset angleToOffset(Offset center, num angle, double distance) {
    final radians = angleToRadian(angle);
    final x = center.dx + distance * cos(radians);
    final y = center.dx + distance * sin(radians);
    return Offset(x, y);
  }

  double angleToRadian(num angle) {
    return angle * pi / 180;
  }

  @override
  bool shouldRepaint(MeterPainter oldDelegate) => true;

  @override
  bool shouldRebuildSemantics(MeterPainter oldDelegate) => false;
}
