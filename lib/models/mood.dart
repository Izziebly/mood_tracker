import 'package:flutter/material.dart';

enum Mood { happy, neutral, sad }

class MoodMeta {
  final String label;
  final String caption;
  final Color color;
  const MoodMeta(this.label, this.caption, this.color);
}

const Map<Mood, MoodMeta> moodMeta = {
  Mood.happy:   MoodMeta('Happy',   'Feeling great', Color(0xFFFFCA28)),
  Mood.neutral: MoodMeta('Neutral', 'Just okay',     Color(0xFF80DEEA)),
  Mood.sad:     MoodMeta('Sad',     'A bit down',    Color(0xFF7986CB)),
};

class MoodEntry {
  final Mood mood;
  final DateTime time;
  const MoodEntry(this.mood, this.time);
}