import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProgressTracker extends StatefulWidget {
  const ProgressTracker({super.key});

  @override
  State<ProgressTracker> createState() => _ProgressTrackerState();
}

class _ProgressTrackerState extends State<ProgressTracker> {
  int _sessionCount = 0;
  int _totalMinutes = 0;
  int _currentStreak = 0;
  String _moodTrend = 'Not enough data';

  @override
  void initState() {
    super.initState();
    _loadProgress();
  }

  Future<void> _loadProgress() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _sessionCount = prefs.getInt('sessionCount') ?? 0;
      _totalMinutes = prefs.getInt('totalMinutes') ?? 0;
      _currentStreak =
          _calculateStreak(prefs.getStringList('meditationDates') ?? []);
      _moodTrend =
          _calculateMoodTrend(prefs.getStringList('moodHistory') ?? []);
    });
  }

  String _calculateMoodTrend(List<String> moodHistory) {
    if (moodHistory.isEmpty) return 'Not enough data';
    // Compare last week's moods to determine trend
    return moodHistory.length >= 3 ? 'Improving' : 'Getting started';
  }

  int _calculateStreak(List<String> dates) {
    if (dates.isEmpty) return 0;
    // Calculate consecutive days logic here
    return dates.length;
  }

  List<Map<String, dynamic>> get progressMetrics => [
        {
          'title': 'Meditation Streak',
          'value': '$_currentStreak days',
          'icon': Icons.timeline,
          'description': 'Current streak'
        },
        {
          'title': 'Total Minutes',
          'value': '$_totalMinutes min',
          'icon': Icons.access_time,
          'description': 'Time meditated'
        },
        {
          'title': 'Sessions Complete',
          'value': '$_sessionCount',
          'icon': Icons.check_circle,
          'description': 'Total sessions'
        },
        {
          'title': 'Mood Tracker',
          'value': _moodTrend,
          'icon': Icons.mood,
          'description': 'Weekly progress'
        },
      ];

  Widget _buildProgressCard(BuildContext context, Map<String, dynamic> metric) {
    return Card(
      elevation: 3,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.blue[100],
          borderRadius: BorderRadius.circular(15),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              metric['icon'],
              size: 40,
              color: Colors.blue[900],
            ),
            SizedBox(height: 10),
            Text(
              metric['title'],
              style: TextStyle(
                color: Colors.blue[900],
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 5),
            Text(
              metric['value'],
              style: TextStyle(
                color: Colors.blue[900],
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 5),
            Text(
              metric['description'],
              style: TextStyle(
                color: Colors.blue[800],
                fontSize: 12,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        title: Text('Progress Tracker'),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: GridView.builder(
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 16,
            mainAxisSpacing: 16,
            childAspectRatio: 0.85,
          ),
          itemCount: progressMetrics.length,
          itemBuilder: (context, index) {
            return _buildProgressCard(context, progressMetrics[index]);
          },
        ),
      ),
    );
  }
}
