import 'package:flutter/material.dart';
import 'package:stress_relief_app/screens/meditation_library.dart';
import 'package:stress_relief_app/screens/progress_tracker.dart';
import 'package:stress_relief_app/screens/exercise_library.dart';
import 'package:stress_relief_app/screens/settings_screen.dart';
import 'dart:async';

class ChatMessage {
  final String text;
  final bool isUser;
  ChatMessage({required this.text, required this.isUser});
}

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final List<ChatMessage> _messages = [];
  final ScrollController _scrollController = ScrollController();
  bool _isChatVisible = false;

  @override
  void initState() {
    super.initState();
    _isChatVisible = true;
    _showInitialPrompt();
  }

  void _handleEmotion(String emotion) {
    setState(() {
      _messages.add(ChatMessage(text: "I'm feeling $emotion", isUser: true));
    });
    _getBotResponse(emotion);
    _scrollToBottom();
  }

  void _getBotResponse(String emotion) {
    String response = '';
    switch (emotion.toLowerCase()) {
      case 'stressed':
        response =
            "I notice you're feeling stressed. I recommend trying our 'Calm Breath' meditation session. Would you like to start?";
        break;
      case 'sad':
        response =
            'I understand you\'re feeling down. Our "Mindful Joy" meditation might help lift your spirits. Shall we begin?';
        break;
      case 'depressed':
        response =
            'I hear you. Let\'s try our "Light in Darkness" meditation session to help you feel better. Ready to begin?';
        break;
      case 'happy':
        response =
            "Wonderful! Let's maintain that positive energy with our 'Gratitude' meditation. Ready to start?";
        break;
    }

    setState(() {
      _messages.add(ChatMessage(text: response, isUser: false));
    });
  }

  Widget _buildEmotionButton(String emotion, Color color) {
    return SizedBox(
      height: 36,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: color,
          padding: EdgeInsets.symmetric(horizontal: 8),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
        ),
        onPressed: () => _handleEmotion(emotion),
        child: Text(
          emotion.toUpperCase(),
          style: TextStyle(
              color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }

  void _scrollToBottom() {
    Timer(const Duration(milliseconds: 100), () {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  void _showInitialPrompt() {
    String initialMessage = "Hello! How are you feeling today? let me know.";
    setState(() {
      _messages.add(ChatMessage(text: initialMessage, isUser: false));
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        title: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Image.asset(
              'assets/images/logo.png',
              height: 40,  // Increased from 32 to 40
              fit: BoxFit.contain,
            ),
            const SizedBox(width: 8),
            const Text('Stress Relief'),
          ],
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.settings),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => SettingsScreen()),
              );
            },
          ),
        ],
      ),
      body: Stack(
        children: [
          // Main Content
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _buildFeatureButton(
                  'Meditation Library',
                  Icons.self_improvement,
                  () => Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => MeditationLibrary())),
                ),
                const SizedBox(height: 20),
                _buildFeatureButton(
                  'Exercise Library',
                  Icons.fitness_center,
                  () => Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => ExerciseLibrary())),
                ),
                const SizedBox(height: 20),
                _buildFeatureButton(
                  'Progress Tracker',
                  Icons.track_changes,
                  () => Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => ProgressTracker())),
                ),
              ],
            ),
          ),
          // Chat Interface
          if (_isChatVisible)
            Positioned(
              bottom: 80,
              right: 20,
              width: 300,
              height: 400,
              child: Card(
                elevation: 8,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
                child: Column(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: Colors.blue[100],
                        borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(15),
                          topRight: Radius.circular(15),
                        ),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Chat with mood bot',
                            style: TextStyle(
                              color: Colors.blue[900],
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          IconButton(
                            icon: const Icon(Icons.close),
                            onPressed: () =>
                                setState(() => _isChatVisible = false),
                          ),
                        ],
                      ),
                    ),
                    Expanded(
                      child: ListView.builder(
                        controller: _scrollController,
                        padding: const EdgeInsets.all(8),
                        itemCount: _messages.length,
                        itemBuilder: (context, index) {
                          return _buildMessage(_messages[index]);
                        },
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 4, vertical: 8),
                      child: Wrap(
                        spacing: 4,
                        runSpacing: 8,
                        alignment: WrapAlignment.center,
                        children: [
                          _buildEmotionButton('happy', Colors.green[400]!),
                          _buildEmotionButton('sad', Colors.blue[400]!),
                          _buildEmotionButton('stressed', Colors.orange[400]!),
                          _buildEmotionButton('depressed', Colors.purple[400]!),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.blue[100],
        child: Icon(
          _isChatVisible ? Icons.chat : Icons.chat_bubble_outline,
          color: Colors.blue[900],
        ),
        onPressed: () {
          setState(() {
            _isChatVisible = !_isChatVisible;
            if (_isChatVisible && _messages.isEmpty) {
              _showInitialPrompt(); // Replace _getBotResponse("") with this
            }
          });
        },
      ),
    );
  }

  Widget _buildMessage(ChatMessage message) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 5),
      child: Row(
        mainAxisAlignment:
            message.isUser ? MainAxisAlignment.end : MainAxisAlignment.start,
        children: [
          Container(
            constraints: BoxConstraints(maxWidth: 250),
            padding: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
            decoration: BoxDecoration(
              color: message.isUser ? Colors.blue[100] : Colors.white,
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 2,
                  offset: Offset(0, 1),
                ),
              ],
            ),
            child: Text(
              message.text,
              style: TextStyle(
                color: Colors.blue[900],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFeatureButton(String title, IconData icon, VoidCallback onTap) {
    return Container(
      width: 200,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          padding: EdgeInsets.symmetric(vertical: 15),
          backgroundColor: Colors.blue[100],
          foregroundColor: Colors.blue[900],
          elevation: 3,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
        ),
        onPressed: onTap,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon),
            SizedBox(width: 10),
            Text(title),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }
}
