import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import 'package:just_audio_background/just_audio_background.dart';

class MeditationLibrary extends StatefulWidget {
  const MeditationLibrary({super.key});

  @override
  State<MeditationLibrary> createState() => _MeditationLibraryState();
}

class _MeditationLibraryState extends State<MeditationLibrary> {
  final Map<String, String> meditationAudios = {
    'Calm Breath': 'assets/audio/calm_breath.mp3',
    'Mindful Joy': 'assets/audio/mindful_joy.mp3',
    'Light in Darkness': 'assets/audio/light_in_darkness.mp3',
    'Gratitude': 'assets/audio/gratitude.mp3',
  };

  Widget _buildMeditationCard(String title, String audioPath) {
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
          onTap: () => _playAudio(title, audioPath),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.music_note,
                size: 40,
                color: Colors.blue[900],
              ),
              SizedBox(height: 10),
              Text(
                title,
                style: TextStyle(
                  color: Colors.blue[900],
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _playAudio(String title, String audioPath) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => AudioPlayerScreen(
          title: title,
          audioPath: audioPath,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        title: Text('Meditation Library'),
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
          ),
          itemCount: meditationAudios.length,
          itemBuilder: (context, index) {
            String title = meditationAudios.keys.elementAt(index);
            String audioPath = meditationAudios.values.elementAt(index);
            return _buildMeditationCard(title, audioPath);
          },
        ),
      ),
    );
  }
}

class AudioPlayerScreen extends StatefulWidget {
  final String title;
  final String audioPath;

  const AudioPlayerScreen({
    required this.title,
    required this.audioPath,
    super.key,
  });

  @override
  State<AudioPlayerScreen> createState() => _AudioPlayerScreenState();
}

class _AudioPlayerScreenState extends State<AudioPlayerScreen> {
  late AudioPlayer _audioPlayer;
  bool _isPlaying = false;

  @override
  void initState() {
    super.initState();
    _initAudioPlayer();
  }

  Future<void> _initAudioPlayer() async {
    _audioPlayer = AudioPlayer();
    try {
      await _audioPlayer.setAudioSource(
        AudioSource.asset(
          widget.audioPath,
          tag: MediaItem(
            id: widget.audioPath,
            title: widget.title,
            artist: 'Meditation App',
            artUri: Uri.parse('asset:///assets/meditation_icon.png'),
          ),
        ),
      );
      setState(() => _isPlaying = true);
      _audioPlayer.play();
    } catch (e) {
      print("Error loading audio source: $e");
    }
  }

  String _formatDuration(Duration? duration) {
    if (duration == null) return '--:--';
    String minutes = duration.inMinutes.toString().padLeft(2, '0');
    String seconds = (duration.inSeconds % 60).toString().padLeft(2, '0');
    return '$minutes:$seconds';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        title: Text(widget.title),
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Meditation Image
            Container(
              width: 250,
              height: 250,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.blue.withOpacity(0.1),
                image: DecorationImage(
                  image: AssetImage('assets/images/meditation_icon.png'),
                  fit: BoxFit.cover,
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.blue.withOpacity(0.2),
                    blurRadius: 15,
                    spreadRadius: 5,
                  ),
                ],
              ),
            ),
            SizedBox(height: 40),

            // Title
            Text(
              widget.title,
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 30),

            // Progress Slider
            StreamBuilder<Duration?>(
              stream: _audioPlayer.positionStream,
              builder: (context, snapshot) {
                final position = snapshot.data ?? Duration.zero;
                return StreamBuilder<Duration?>(
                  stream: _audioPlayer.durationStream,
                  builder: (context, snapshot) {
                    final duration = snapshot.data ?? Duration.zero;
                    return Column(
                      children: [
                        Slider(
                          value: position.inSeconds.toDouble(),
                          min: 0,
                          max: duration.inSeconds.toDouble(),
                          onChanged: (value) {
                            _audioPlayer.seek(
                              Duration(seconds: value.toInt()),
                            );
                          },
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(_formatDuration(position)),
                              Text(_formatDuration(duration)),
                            ],
                          ),
                        ),
                      ],
                    );
                  },
                );
              },
            ),

            SizedBox(height: 20),

            // Control Buttons
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                IconButton(
                  icon: Icon(Icons.replay_10),
                  iconSize: 40,
                  onPressed: () {
                    _audioPlayer.seek(
                      Duration(seconds: _audioPlayer.position.inSeconds - 10),
                    );
                  },
                ),
                SizedBox(width: 20),
                Container(
                  width: 80,
                  height: 80,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.blue,
                  ),
                  child: IconButton(
                    icon: Icon(
                      _isPlaying ? Icons.pause : Icons.play_arrow,
                      size: 40,
                      color: Colors.white,
                    ),
                    onPressed: () {
                      if (_isPlaying) {
                        _audioPlayer.pause();
                      } else {
                        _audioPlayer.play();
                      }
                      setState(() => _isPlaying = !_isPlaying);
                    },
                  ),
                ),
                SizedBox(width: 20),
                IconButton(
                  icon: Icon(Icons.forward_10),
                  iconSize: 40,
                  onPressed: () {
                    _audioPlayer.seek(
                      Duration(seconds: _audioPlayer.position.inSeconds + 10),
                    );
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _audioPlayer.dispose();
    super.dispose();
  }
}
