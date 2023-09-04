import 'dart:io';

import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

class VideoPlayerView extends StatefulWidget {
  final File videoFile;
  const VideoPlayerView({super.key, required this.videoFile});

  @override
  State<VideoPlayerView> createState() => _VideoPlayerViewState();
}

class _VideoPlayerViewState extends State<VideoPlayerView> {
  late VideoPlayerController _controller;

  @override
  void initState() {
    super.initState();
    _controller = VideoPlayerController.file(widget.videoFile)
      ..initialize().then((_) {
        setState(() {});
      });
  }

  void _playPause() {
    setState(() {
      if (_controller.value.isPlaying) {
        _controller.pause();
      } else {
        _controller.play();
      }
    });
  }

  void _restart() {
    setState(() {
      _controller.seekTo(const Duration(seconds: 0));
    });
  }

  void _skipForward() {
    setState(() {
      _controller
          .seekTo(_controller.value.position + const Duration(seconds: 2));
    });
  }

  void _skipBackward() {
    setState(() {
      _controller
          .seekTo(_controller.value.position - const Duration(seconds: 2));
    });
  }

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: _controller.value.isInitialized
            ? Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  SizedBox(
                    height: MediaQuery.of(context).size.height * 0.9,
                    child: AspectRatio(
                      aspectRatio: _controller.value.aspectRatio,
                      child: VideoPlayer(_controller),
                    ),
                  ),
                  // SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      IconButton(
                        icon: const Icon(Icons.arrow_back_ios),
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                      ),
                      IconButton(
                        icon: const Icon(Icons.fast_rewind),
                        onPressed: _skipBackward,
                      ),
                      IconButton(
                        icon: Icon(_controller.value.isPlaying
                            ? Icons.pause
                            : Icons.play_arrow),
                        onPressed: _playPause,
                      ),
                      IconButton(
                        icon: const Icon(Icons.stop),
                        onPressed: () {
                          setState(() {
                            _controller.pause();
                            _controller.seekTo(const Duration(seconds: 0));
                          });
                        },
                      ),
                      IconButton(
                        icon: const Icon(Icons.replay),
                        onPressed: _restart,
                      ),
                      IconButton(
                        icon: const Icon(Icons.fast_forward),
                        onPressed: _skipForward,
                      ),
                    ],
                  ),
                ],
              )
            : const CircularProgressIndicator(),
      ),
    );
  }
}
