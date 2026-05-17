import 'package:flutter/material.dart';
import '../models/mood.dart';
import '../widgets/selector_card.dart';
import '../widgets/timeline_card.dart';

class MoodTrackerScreen extends StatefulWidget {
  const MoodTrackerScreen({super.key});

  @override
  State<MoodTrackerScreen> createState() => _MoodTrackerScreenState();
}

class _MoodTrackerScreenState extends State<MoodTrackerScreen> {
  final _entries = <MoodEntry>[];
  Mood? _selected;

  // Only the last 7 entries, newest first
  List<MoodEntry> get _recent {
    final src = _entries.length > 7
        ? _entries.sublist(_entries.length - 7)
        : List<MoodEntry>.from(_entries);
    return src.reversed.toList();
  }

  void _log(Mood mood) {
    setState(() {
      _entries.add(MoodEntry(mood, DateTime.now()));
      _selected = mood;
    });
  }

  String get _greeting {
    final h = DateTime.now().hour;
    if (h < 12) return 'GOOD MORNING';
    if (h < 17) return 'GOOD AFTERNOON';
    return 'GOOD EVENING';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0B0B18),
      body: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 500),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildHeader(),
                _buildMoodPicker(),
                if (_selected != null) _buildLoggedBadge(),
                const Spacer(),
                _buildTimeline(),
                const SizedBox(height: 30),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // ── Header ─────────────────────────────────────────────────────────────────

  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 36, 24, 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            _greeting,
            style: TextStyle(
              fontSize: 11,
              color: Colors.white.withValues(alpha: 0.38),
              letterSpacing: 1.8,
            ),
          ),
          const SizedBox(height: 7),
          const Text(
            'How are you feeling today?',
            style: TextStyle(
              fontSize: 27,
              fontWeight: FontWeight.w700,
              color: Colors.white,
              height: 1.22,
            ),
          ),
          const SizedBox(height: 26),
        ],
      ),
    );
  }

  // ── Mood Picker ────────────────────────────────────────────────────────────

  Widget _buildMoodPicker() {
    return SizedBox(
      height: 150,
      child: ListView(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 20),
        children: Mood.values
            .map((m) => SelectorCard(
                  mood: m,
                  isSelected: _selected == m,
                  onTap: () => _log(m),
                ))
            .toList(),
      ),
    );
  }

  // ── Logged Badge ───────────────────────────────────────────────────────────

  Widget _buildLoggedBadge() {
    final m = moodMeta[_selected!]!;
    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 14, 24, 0),
      child: AnimatedSwitcher(
        duration: const Duration(milliseconds: 300),
        child: Row(
          key: ValueKey(_selected),
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 7,
              height: 7,
              decoration:
                  BoxDecoration(color: m.color, shape: BoxShape.circle),
            ),
            const SizedBox(width: 10),
            Text(
              'Logged: ${m.label} — ${m.caption}',
              style: TextStyle(
                color: m.color,
                fontSize: 12.5,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ── Timeline ───────────────────────────────────────────────────────────────

  Widget _buildTimeline() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(24, 0, 24, 14),
          child: Row(
            children: [
              const Text(
                'Mood History',
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                ),
              ),
              const Spacer(),
              Text(
                '${_recent.length} / 7',
                style: TextStyle(
                  fontSize: 11,
                  color: Colors.white.withValues(alpha: 0.28),
                ),
              ),
            ],
          ),
        ),
        SizedBox(
          height: 136,
          child: _recent.isEmpty
              ? Center(
                  child: Text(
                    'Tap any mood above to start tracking',
                    style: TextStyle(
                      color: Colors.white.withValues(alpha: 0.25),
                      fontSize: 13,
                    ),
                  ),
                )
              : ListView.builder(
                  scrollDirection: Axis.horizontal,
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  itemCount: _recent.length,
                  itemBuilder: (_, i) => TimelineCard(entry: _recent[i]),
                ),
        ),
      ],
    );
  }
}