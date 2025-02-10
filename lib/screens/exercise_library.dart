import 'package:flutter/material.dart';
import 'package:stress_relief_app/screens/video_player_screen.dart';

class ExerciseLibrary extends StatelessWidget {
  final List<Map<String, dynamic>> exercises = [
    {
      'title': 'Mindful Walking',
      'description': 'Guided walking meditation',
      'videoUrl': 'https://www.youtube.com/watch?v=59ZnUHNwI0c',
      'icon': Icons.directions_walk
    },
    {
      'title': 'Breathing Exercise',
      'description': 'Deep breathing techniques',
      'videoUrl': 'https://www.youtube.com/watch?v=enJyOTvEn4M',
      'icon': Icons.air
    },
  ];

  ExerciseLibrary({super.key});

  Widget _buildExerciseCard(
      BuildContext context, Map<String, dynamic> exercise) {
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
        child: InkWell(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => VideoPlayerScreen(
                  youtubeUrl: exercise['videoUrl'],
                ),
              ),
            );
          },
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                exercise['icon'],
                size: 40,
                color: Colors.blue[900],
              ),
              SizedBox(height: 10),
              Text(
                exercise['title'],
                style: TextStyle(
                  color: Colors.blue[900],
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 5),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8),
                child: Text(
                  exercise['description'],
                  style: TextStyle(
                    color: Colors.blue[800],
                    fontSize: 12,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        title: Text('Exercise Library'),
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
          itemCount: exercises.length,
          itemBuilder: (context, index) {
            return _buildExerciseCard(context, exercises[index]);
          },
        ),
      ),
    );
  }
}
