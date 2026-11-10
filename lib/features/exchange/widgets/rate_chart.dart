import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../../data/models/exchange_rate.dart';

/// The rate line chart: dotted gridlines with value captions down the left, a
/// smoothed blue line with a fading fill beneath it, a dot at the latest
/// point, and sparse date captions along the bottom.
///
/// Hand-drawn rather than pulling in a charting package — it is one series
/// with no interaction, and this keeps full control of the board's styling.
class RateChart extends StatelessWidget {
  final List<RatePoint> points;
  final double height;

  const RateChart({super.key, required this.points, this.height = 190});

  @override
  Widget build(BuildContext context) {
    if (points.length < 2) {
      return SizedBox(
        height: height,
        child: const Center(
          child: Text('No rate history',
              style: TextStyle(color: AppColors.textGrey, fontSize: 13)),
        ),
      );
    }
    return SizedBox(
      height: height,
      width: double.infinity,
      child: CustomPaint(painter: _RateChartPainter(points)),
    );
  }
}

class _RateChartPainter extends CustomPainter {
  final List<RatePoint> points;
  _RateChartPainter(this.points);

  static const _leftGutter = 46.0;
  static const _bottomGutter = 24.0;
  static const _gridLines = 4;

  @override
  void paint(Canvas canvas, Size size) {
    final values = points.map((p) => p.value).toList();
    var min = values.reduce((a, b) => a < b ? a : b);
    var max = values.reduce((a, b) => a > b ? a : b);
    if (max - min < 0.0001) {
      // A flat series would divide by zero; give it some room.
      min -= 1;
      max += 1;
    }
    // Round the bounds outward so the gridline captions are tidy numbers.
    final step = _niceStep((max - min) / (_gridLines - 1));
    min = (min / step).floorToDouble() * step;
    max = min + step * (_gridLines - 1);

    final plot = Rect.fromLTRB(
      _leftGutter,
      4,
      size.width,
      size.height - _bottomGutter,
    );

    _paintGrid(canvas, plot, min, step);
    _paintSeries(canvas, plot, min, max);
    _paintDateLabels(canvas, plot, size);
  }

  void _paintGrid(Canvas canvas, Rect plot, double min, double step) {
    final grid = Paint()
      ..color = AppColors.divider
      ..strokeWidth = 1;

    for (var i = 0; i < _gridLines; i++) {
      final value = min + step * i;
      final y = plot.bottom - (plot.height / (_gridLines - 1)) * i;
      _dottedLine(canvas, Offset(plot.left, y), Offset(plot.right, y), grid);
      _caption(canvas, _fmtAxis(value), Offset(plot.left - 8, y),
          align: TextAlign.right, anchorRight: true);
    }
  }

  void _paintSeries(Canvas canvas, Rect plot, double min, double max) {
    final dx = plot.width / (points.length - 1);
    double yFor(double v) =>
        plot.bottom - ((v - min) / (max - min)) * plot.height;

    final coords = [
      for (var i = 0; i < points.length; i++)
        Offset(plot.left + dx * i, yFor(points[i].value)),
    ];

    // Catmull-Rom-ish smoothing: a cubic through each pair using the
    // midpoints as control handles.
    final line = Path()..moveTo(coords.first.dx, coords.first.dy);
    for (var i = 0; i < coords.length - 1; i++) {
      final a = coords[i];
      final b = coords[i + 1];
      final cx = (a.dx + b.dx) / 2;
      line.cubicTo(cx, a.dy, cx, b.dy, b.dx, b.dy);
    }

    final fill = Path.from(line)
      ..lineTo(coords.last.dx, plot.bottom)
      ..lineTo(coords.first.dx, plot.bottom)
      ..close();

    canvas.drawPath(
      fill,
      Paint()
        ..shader = LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            AppColors.chartLine.withValues(alpha: 0.26),
            AppColors.chartLine.withValues(alpha: 0.0),
          ],
        ).createShader(plot),
    );

    canvas.drawPath(
      line,
      Paint()
        ..color = AppColors.chartLine
        ..strokeWidth = 3
        ..strokeCap = StrokeCap.round
        ..strokeJoin = StrokeJoin.round
        ..style = PaintingStyle.stroke,
    );

    // The latest point carries a dot.
    canvas.drawCircle(
        coords.last, 5, Paint()..color = AppColors.chartLine);
  }

  void _paintDateLabels(Canvas canvas, Rect plot, Size size) {
    final dx = plot.width / (points.length - 1);
    for (var i = 0; i < points.length; i++) {
      final label = points[i].label;
      if (label.isEmpty) continue;
      _caption(canvas, label,
          Offset(plot.left + dx * i, size.height - _bottomGutter + 6),
          align: TextAlign.center, centre: true);
    }
  }

  void _dottedLine(Canvas canvas, Offset a, Offset b, Paint paint) {
    const dash = 3.0;
    const gap = 4.0;
    var x = a.dx;
    while (x < b.dx) {
      canvas.drawLine(
          Offset(x, a.dy), Offset((x + dash).clamp(a.dx, b.dx), b.dy), paint);
      x += dash + gap;
    }
  }

  void _caption(Canvas canvas, String text, Offset at,
      {TextAlign align = TextAlign.left,
      bool anchorRight = false,
      bool centre = false}) {
    final tp = TextPainter(
      text: TextSpan(
        text: text,
        style: const TextStyle(color: AppColors.textGrey, fontSize: 11),
      ),
      textAlign: align,
      textDirection: TextDirection.ltr,
    )..layout();
    var dx = at.dx;
    if (anchorRight) dx -= tp.width;
    if (centre) dx -= tp.width / 2;
    final dy = anchorRight ? at.dy - tp.height / 2 : at.dy;
    tp.paint(canvas, Offset(dx, dy));
  }

  /// Rounds a raw step up to 1, 2 or 5 times a power of ten.
  static double _niceStep(double raw) {
    if (raw <= 0) return 1;
    final magnitude =
        1.0 * (raw.abs() < 1 ? 1 : 1) * _pow10((raw.abs()).floorLog10());
    final normalised = raw / magnitude;
    final nice = normalised <= 1
        ? 1.0
        : normalised <= 2
            ? 2.0
            : normalised <= 5
                ? 5.0
                : 10.0;
    return nice * magnitude;
  }

  static double _pow10(int e) {
    var v = 1.0;
    for (var i = 0; i < e.abs(); i++) {
      v *= 10;
    }
    return e < 0 ? 1 / v : v;
  }

  static String _fmtAxis(double v) {
    final s = v.round().toString();
    return s.replaceAllMapped(RegExp(r'(\d)(?=(\d{3})+$)'), (m) => '${m[1]},');
  }

  @override
  bool shouldRepaint(covariant _RateChartPainter old) =>
      old.points != points;
}

extension on double {
  int floorLog10() {
    var v = abs();
    var e = 0;
    if (v >= 1) {
      while (v >= 10) {
        v /= 10;
        e++;
      }
    } else if (v > 0) {
      while (v < 1) {
        v *= 10;
        e--;
      }
    }
    return e;
  }
}
