import 'package:flutter/material.dart';
import 'dart:math';                     
import '../models/mood.dart';   

class MoodFacePainter extends CustomPainter {
  final Mood mood;

  const MoodFacePainter(this.mood);

  Color get _color => moodMeta[mood]!.color;

  // Stroke paint — round caps give the lines a softer, drawn look
  Paint _sp(double width) => Paint()
    ..color = _color
    ..style = PaintingStyle.stroke
    ..strokeCap = StrokeCap.round
    ..strokeWidth = width;

  Paint get _fill => Paint()..color = _color;

  Paint _fop(double opacity) => Paint()..color = _color.withValues(alpha: opacity);

  @override
  void paint(Canvas canvas, Size size) {
    final c = Offset(size.width / 2, size.height / 2);
    final r = min(size.width, size.height) / 2 * 0.88;

    canvas.drawCircle(c, r, _fop(0.14));
    canvas.drawCircle(c, r, _sp(2.0));

    switch (mood) {
      case Mood.happy: _drawHappy(canvas, c, r);   break;
      case Mood.neutral: _drawNeutral(canvas, c, r); break;
      case Mood.sad: _drawSad(canvas, c, r);     break;
    }
  }

  // ── Shared: two symmetric eyes ─────────────────────────────────────────────
  void _eyes(Canvas canvas, Offset c, double r,
      {double dy = -0.20, double er = 0.08}) {
    canvas.drawCircle(Offset(c.dx - r * 0.28, c.dy + r * dy), r * er, _fill);
    canvas.drawCircle(Offset(c.dx + r * 0.28, c.dy + r * dy), r * er, _fill);
  }

  // ── HAPPY ──────────────────────────────────────────────────────────────────
  void _drawHappy(Canvas canvas, Offset c, double r) {
    _eyes(canvas, c, r);

    canvas.drawArc(
      Rect.fromCenter(
        center: Offset(c.dx, c.dy + r * 0.06),
        width: r * 0.70,
        height: r * 0.46,
      ),
      0, pi, false, _sp(2.2),
    );

    canvas.drawCircle(Offset(c.dx - r * 0.50, c.dy + r * 0.15), r * 0.16, _fop(0.18));
    canvas.drawCircle(Offset(c.dx + r * 0.50, c.dy + r * 0.15), r * 0.16, _fop(0.18));
  }

  // ── NEUTRAL ────────────────────────────────────────────────────────────────
  void _drawNeutral(Canvas canvas, Offset c, double r) {
    _eyes(canvas, c, r);

    canvas.drawLine(
      Offset(c.dx - r * 0.28, c.dy + r * 0.28),
      Offset(c.dx + r * 0.28, c.dy + r * 0.28),
      _sp(2.2),
    );

    // Left brow: angled up-outward
    canvas.drawLine(
      Offset(c.dx - r * 0.40, c.dy - r * 0.40),
      Offset(c.dx - r * 0.16, c.dy - r * 0.46),
      _sp(2.0),
    );
    // Right brow: flat and level
    canvas.drawLine(
      Offset(c.dx + r * 0.16, c.dy - r * 0.38),
      Offset(c.dx + r * 0.40, c.dy - r * 0.38),
      _sp(2.0),
    );
  }

  // ── SAD ────────────────────────────────────────────────────────────────────
  void _drawSad(Canvas canvas, Offset c, double r) {
    _eyes(canvas, c, r, dy: -0.18);

    for (final s in [-1.0, 1.0]) {
      canvas.drawLine(
        Offset(c.dx + s * r * 0.14, c.dy - r * 0.44),
        Offset(c.dx + s * r * 0.40, c.dy - r * 0.34),
        _sp(2.0),
      );
    }

    canvas.drawArc(
      Rect.fromCenter(
        center: Offset(c.dx, c.dy + r * 0.60),
        width: r * 0.54,
        height: r * 0.32,
      ),
      pi, pi, false, _sp(2.2),
    );

    // Teardrop — drawn with cubicTo
    canvas.drawPath(
      Path()
        ..moveTo(c.dx + r * 0.30, c.dy + r * 0.02)
        ..cubicTo(
          c.dx + r * 0.40, c.dy + r * 0.14,
          c.dx + r * 0.40, c.dy + r * 0.28,
          c.dx + r * 0.30, c.dy + r * 0.30,
        )
        ..cubicTo(
          c.dx + r * 0.20, c.dy + r * 0.28,
          c.dx + r * 0.20, c.dy + r * 0.14,
          c.dx + r * 0.30, c.dy + r * 0.02,
        ),
      _fop(0.45),
    );
  }
  
  // Only repaint if the mood actually changed
  @override
  bool shouldRepaint(MoodFacePainter old) => old.mood != mood;
}