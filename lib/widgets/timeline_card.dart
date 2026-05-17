import 'package:flutter/material.dart';
import '../models/mood.dart';
import '../painters/mood_face_painter.dart';

class TimelineCard extends StatefulWidget {
  final MoodEntry entry;

  const TimelineCard({super.key, required this.entry});

  @override
  State<TimelineCard> createState() => _TimelineCardState();
}

class _TimelineCardState extends State<TimelineCard>
    with SingleTickerProviderStateMixin {
  late final AnimationController _ctrl;
  late final Animation<double> _scale;

  @override
  void initState() {
    super.initState();

    _ctrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    );

    _scale = TweenSequence<double>([
      TweenSequenceItem(
        tween: Tween(begin: 1.0, end: 1.25),
        weight: 20,
      ),
      TweenSequenceItem(
        tween: Tween(begin: 1.25, end: 0.88),
        weight: 25,
      ), 
      TweenSequenceItem(
        tween: Tween(begin: 0.88, end: 1.10),
        weight: 20,
      ),
      TweenSequenceItem(
        tween: Tween(begin: 1.10, end: 0.95),
        weight: 15,
      ),
      TweenSequenceItem(
        tween: Tween(begin: 0.95, end: 1.00), 
        weight: 20),
    ]).animate(CurvedAnimation(parent: _ctrl, curve: Curves.easeOut));
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  void _bounce() => _ctrl.forward(from: 0);

  @override
  Widget build(BuildContext context) {
    final m = moodMeta[widget.entry.mood]!;

    return GestureDetector(
      onTap: _bounce,
      child: ScaleTransition(
        scale: _scale,
        child: Container(
          width: 100,
          margin: const EdgeInsets.only(right: 12),
          decoration: BoxDecoration(
            color: const Color(0xFF13132A),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: m.color.withValues(alpha: 0.28)),
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(20),
            child: Column(
              children: [
                Container(height: 4, color: m.color),

                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(
                        width: 56,
                        height: 56,
                        child: CustomPaint(
                          painter: MoodFacePainter(widget.entry.mood),
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        _dayLabel(widget.entry.time),
                        style: TextStyle(
                          fontSize: 9.5,
                          color: Colors.white.withValues(alpha: 0.38),
                          letterSpacing: 0.6,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        _timeLabel(widget.entry.time),
                        style: TextStyle(
                          fontSize: 11,
                          color: m.color,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  String _dayLabel(DateTime t) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final entry = DateTime(t.year, t.month, t.day);
    final diff = today.difference(entry).inDays;
    if (diff == 0) return 'TODAY';
    if (diff == 1) return 'YESTERDAY';
    const days = ['SUN', 'MON', 'TUE', 'WED', 'THU', 'FRI', 'SAT'];
    return days[t.weekday % 7];
  }

  String _timeLabel(DateTime t) {
    final h = t.hour % 12 == 0 ? 12 : t.hour % 12;
    final min = t.minute.toString().padLeft(2, '0');
    return '$h:$min ${t.hour < 12 ? 'AM' : 'PM'}';
  }
}
