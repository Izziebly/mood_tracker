import 'package:flutter/material.dart';
import '../models/mood.dart';
import '../painters/mood_face_painter.dart';

class SelectorCard extends StatelessWidget {
  final Mood mood;
  final bool isSelected;
  final VoidCallback onTap;

  const SelectorCard({
    super.key,
    required this.mood,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final m = moodMeta[mood]!;

    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 220),
        curve: Curves.easeOut,
        margin: const EdgeInsets.only(right: 12, top: 2, bottom: 2),
        width: 108,
        decoration: BoxDecoration(
          color: isSelected
              ? m.color.withValues(alpha: 0.18)
              : const Color(0xFF13132A),
          borderRadius: BorderRadius.circular(22),
          border: Border.all(
            color: isSelected ? m.color : m.color.withValues(alpha: 0.22),
            width: isSelected ? 1.5 : 1.0,
          ),
          // Glow effect only appears when this mood is selected
          boxShadow: isSelected
              ? [BoxShadow(
                  color: m.color.withValues(alpha: 0.30),
                  blurRadius: 16,
                  spreadRadius: 1,
                )]
              : null,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Face scales up slightly when selected
            AnimatedScale(
              scale: isSelected ? 1.12 : 1.0,
              duration: const Duration(milliseconds: 220),
              child: SizedBox(
                width: 66,
                height: 66,
                child: CustomPaint(painter: MoodFacePainter(mood)),
              ),
            ),
            const SizedBox(height: 9),
            AnimatedDefaultTextStyle(
              duration: const Duration(milliseconds: 220),
              style: TextStyle(
                fontSize: 12,
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
                color: isSelected ? m.color : Colors.white70,
              ),
              child: Text(m.label),
            ),
          ],
        ),
      ),
    );
  }
}