import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';

class AudioPractice1 extends StatefulWidget {
  const AudioPractice1({super.key});

  @override
  State<AudioPractice1> createState() => _AudioPractice1State();
}

class _AudioPractice1State extends State<AudioPractice1> {
  final AudioPlayer _player = AudioPlayer();
  int _currentIndex = -1;
  bool _isLoading = false;
  bool _isPlaying = false;

  final List<Map<String, String>> _playList = [
    {
      "title": "Track 1",
      "url": "https://www.soundhelix.com/examples/mp3/SoundHelix-Song-1.mp3",
    },
    {
      "title": "Track 2",
      "url": "https://www.soundhelix.com/examples/mp3/SoundHelix-Song-2.mp3",
    },
  ];

  Future<void> _playAudio(int index) async {
    if (_currentIndex == index && _isPlaying) {
      await _player.pause();
      setState(() {
        _isPlaying = false;
      });
    } else {
      setState(() {
        _isLoading = true;
        _currentIndex = index;
      });

      try {
        await _player.stop();
        await _player.setSourceUrl(_playList[index]["url"]!);
        await _player.resume();
        setState(() {
          _isPlaying = true;
        });
      } catch (e) {
        print("Error playing audio: $e");
      } finally {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  void dispose() {
    _player.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Audio Playlist"),
      ),
      body: ListView.builder(
        itemCount: _playList.length,
        itemBuilder: (context, index) {
          bool isCurrent = _currentIndex == index;

          return ListTile(
            leading: isCurrent
                ? (_isLoading
                ? const SizedBox(
              width: 24,
              height: 24,
              child: CircularProgressIndicator(strokeWidth: 2),
            )
                : Icon(
              _isPlaying
                  ? Icons.pause_circle_filled
                  : Icons.play_circle_fill,
              size: 32,
            ))
                : const Icon(Icons.play_circle_outline, size: 32),
            title: Text(_playList[index]['title']!),
            onTap: () => _playAudio(index),
          );
        },
      ),
    );
  }
}
