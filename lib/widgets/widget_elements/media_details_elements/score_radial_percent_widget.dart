import 'dart:math';

import 'package:flutter/material.dart';

class ScoreRadialPercentWidget extends CustomPainter{
  final double percent;
  final Color backgroundCircleColor;
  final Color progressLineColor;
  final Color progressFreeColor;
  final double lineWidth;

  ScoreRadialPercentWidget({super.repaint, required this.percent,
    required this.backgroundCircleColor, required this.progressLineColor,
    required this.progressFreeColor, required this.lineWidth});

  @override
  void paint(Canvas canvas, Size size) {
    // final paint = Paint();
    // paint.color = Colors.amberAccent;
    // paint.style = PaintingStyle.fill;
    // //paint.strokeWidth = 5;
    // //canvas.drawCircle(Offset(size.width / 2, size.height / 2), 30, paint);
    // canvas.drawRect(Offset.zero & Size(30, 30), paint);
    final arcRect = _calculateArcsRect(size);

    _drawBackground(canvas, size);
    _drawFreeArcLine(canvas, arcRect);
    _drawProgressArcLine(canvas, arcRect);
  }

  Rect _calculateArcsRect(Size size) {
    const linesMargin = 3;
    final offset = lineWidth / 2 + linesMargin;
    final arcRect = Offset(offset, offset) &
    Size(size.width - (offset * 2), size.height - (offset * 2));
    return arcRect;
  }

  void _drawBackground(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = backgroundCircleColor
      ..style = PaintingStyle.fill;

    canvas.drawCircle(Offset(size.height / 2, size.height / 2), size.width / 2, paint);
  }

  void _drawFreeArcLine(Canvas canvas, Rect rect) {
    final paint = Paint()
      ..color = progressFreeColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = lineWidth;

    canvas.drawArc(
        rect,
        (pi * 2) * percent - (pi / 2),
        pi * 2 * (1.0 - percent),
        false,
        paint);
  }

  void _drawProgressArcLine(Canvas canvas, Rect rect) {
    final paint = Paint()
      ..color = progressLineColor
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round
      ..strokeWidth = lineWidth;

    canvas.drawArc(
        rect,
        -pi / 2,
        (pi * 2) * percent,
        false,
        paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}

class RadiantPercentWidget extends StatelessWidget {
  final Widget child;
  final double percent;
  final Color backgroundCircleColor;
  final double progressLine;
  final Color progressFreeColor;
  final double lineWidth;

  const RadiantPercentWidget({super.key, required this.child,
    required this.percent, required this.backgroundCircleColor,
    required this.progressLine, required this.progressFreeColor, required this.lineWidth});

  @override
  Widget build(BuildContext context) {
    Color progressLineColor;
    if(progressLine < 4) {
      progressLineColor = Colors.red;
    } else if(progressLine < 7) {
      progressLineColor = Colors.yellow;
    } else {
      progressLineColor = Colors.green;
    }


    return CustomPaint(
      painter: ScoreRadialPercentWidget(
        backgroundCircleColor: backgroundCircleColor,
        lineWidth: lineWidth,
        percent: percent,
        progressFreeColor: progressFreeColor,
        progressLineColor: progressLineColor,
      ),
      child: Center(child: child),
    );
  }
}

////////////////////////////////////////////////////////////////////////////////////////////////////

// class ScoreRadialPercentWidget extends CustomPainter{
//   final double percent;
//   final Color backgroundCircleColor;
//   final Color progressLineColor;
//   final Color progressFreeColor;
//   final double lineWidth;
//
//   ScoreRadialPercentWidget({super.repaint, required this.percent,
//     required this.backgroundCircleColor, required this.progressLineColor,
//     required this.progressFreeColor, required this.lineWidth});
//
//   @override
//   void paint(Canvas canvas, Size size) {
//     // final paint = Paint();
//     // paint.color = Colors.amberAccent;
//     // paint.style = PaintingStyle.fill;
//     // //paint.strokeWidth = 5;
//     // //canvas.drawCircle(Offset(size.width / 2, size.height / 2), 30, paint);
//     // canvas.drawRect(Offset.zero & Size(30, 30), paint);
//     final arcRect = _calculateArcsRect(size);
//
//     _drawBackground(canvas, size);
//     _drawFreeArcLine(canvas, arcRect);
//     _drawProgressArcLine(canvas, arcRect);
//   }
//
//   Rect _calculateArcsRect(Size size) {
//     final linesMargin = 3;
//     final offset = lineWidth / 2 + linesMargin;
//     final arcRect = Offset(offset, offset) &
//     Size(size.width - (offset * 2), size.height - (offset * 2));
//     return arcRect;
//   }
//
//   void _drawBackground(Canvas canvas, Size size) {
//     final paint = Paint()
//       ..color = backgroundCircleColor
//       ..style = PaintingStyle.fill;
//
//     canvas.drawCircle(Offset(size.height / 2, size.height / 2), size.width / 2, paint);
//   }
//
//   void _drawFreeArcLine(Canvas canvas, Rect rect) {
//     final paint = Paint()
//       ..color = progressFreeColor
//       ..style = PaintingStyle.stroke
//       ..strokeWidth = lineWidth;
//
//     canvas.drawArc(
//         rect,
//         (pi * 2) * percent - (pi / 2),
//         pi * 2 * (1.0 - percent),
//         false,
//         paint);
//   }
//
//   void _drawProgressArcLine(Canvas canvas, Rect rect) {
//     final paint = Paint()
//       ..color = progressLineColor
//       ..style = PaintingStyle.stroke
//       ..strokeCap = StrokeCap.round
//       ..strokeWidth = lineWidth;
//
//     canvas.drawArc(
//         rect,
//         -pi / 2,
//         (pi * 2) * percent,
//         false,
//         paint);
//   }
//
//   @override
//   bool shouldRepaint(covariant CustomPainter oldDelegate) {
//     return true;
//   }
// }
//
// class RadiantPercentWidget extends StatelessWidget {
//   final Widget child;
//   final double percent;
//   final Color backgroundCircleColor;
//   final Color progressLineColor;
//   final Color progressFreeColor;
//   final double lineWidth;
//
//   const RadiantPercentWidget({super.key, required this.child,
//     required this.percent, required this.backgroundCircleColor,
//     required this.progressLineColor, required this.progressFreeColor, required this.lineWidth});
//
//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       child: CustomPaint(
//         painter: ScoreRadialPercentWidget(
//           backgroundCircleColor: backgroundCircleColor,
//           lineWidth: lineWidth,
//           percent: percent,
//           progressFreeColor: progressFreeColor,
//           progressLineColor: progressLineColor,
//         ),
//         child: Center(child: child),
//       ),
//     );
//   }
// }