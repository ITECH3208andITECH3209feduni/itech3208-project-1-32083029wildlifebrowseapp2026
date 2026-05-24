import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import 'package:shared_preferences/shared_preferences.dart';

class OnboardingVideosScreen extends StatefulWidget {

  final Map<String, dynamic> user;

  const OnboardingVideosScreen({
    super.key,
    required this.user,
  });

  @override
  State<OnboardingVideosScreen> createState() =>
      _OnboardingVideosScreenState();
}

class _OnboardingVideosScreenState extends State<OnboardingVideosScreen> {
  final List<Map<String, String>> videos = [
    {
      'title': 'Personal Protective Equipment (PPE)',
      'description':
          'Before starting any browse collection, it is important to prepare yourself properly. This video explains how to use appropriate protective equipment and assess the surrounding environment to reduce risks and work safely.',
      'path': 'assets/videos/ppe.mp4',
    },
    {
      'title': 'Plant Photography Guidelines',
      'description':
          'Clear and accurate photographs are essential for identifying suitable browse. This video demonstrates how to take proper photos of the plant so that important details can be captured for review and communication.',
      'path': 'assets/videos/photography.mp4',
    },
    {
      'title': 'Camellia Extraction Training',
      'description':
          'This training video provides guidance on how to safely and correctly extract camellia. It focuses on proper handling methods to maintain quality while supporting safe collection practices.',
      'path': 'assets/videos/camellia.mp4',
    },
    {
      'title': 'Eucalypt Branch Collection',
      'description':
          'This video introduces the correct approach to selecting and extracting eucalypt branches. It explains safe and suitable collection methods to support wildlife feeding requirements.',
      'path': 'assets/videos/Eucalypt.mp4',
    },
  ];

  VideoPlayerController? _controller;
  int currentIndex = 0;
  bool isLoading = true;
  bool hasHandledVideoEnd = false;

  @override
  void initState() {
    super.initState();
    _loadVideo();
  }

  Future<void> _loadVideo() async {
    setState(() {
      isLoading = true;
      hasHandledVideoEnd = false;
    });

    if (_controller != null) {
      _controller!.removeListener(_videoListener);
      await _controller!.dispose();
    }

    _controller = VideoPlayerController.asset(
      videos[currentIndex]['path']!,
    );

    await _controller!.initialize();
    _controller!.addListener(_videoListener);
    await _controller!.play();

    if (!mounted) return;

    setState(() {
      isLoading = false;
    });
  }

  void _videoListener() {
    if (_controller == null || !_controller!.value.isInitialized) return;

    final bool isFinished =
        _controller!.value.position >= _controller!.value.duration &&
        !_controller!.value.isPlaying;

    if (isFinished && !hasHandledVideoEnd) {
      hasHandledVideoEnd = true;
      _nextVideo();
    }
  }

  Future<void> _nextVideo() async {
    if (currentIndex < videos.length - 1) {
      setState(() {
        currentIndex++;
      });
      await _loadVideo();
    } else {
      if (!mounted) return;

       final prefs = await SharedPreferences.getInstance();
       final route =
      prefs.getString('after_agreement_route') ?? '/request-board';

      Navigator.pushReplacementNamed(
       context,
       route,
       arguments: widget.user,
     );
    }
  }

  void _togglePlayPause() {
    if (_controller == null || !_controller!.value.isInitialized) return;

    setState(() {
      if (_controller!.value.isPlaying) {
        _controller!.pause();
      } else {
        _controller!.play();
      }
    });
  }

  @override
  void dispose() {
    _controller?.removeListener(_videoListener);
    _controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final currentVideo = videos[currentIndex];

    return Scaffold(
      appBar: AppBar(
        title: Text('Training Video ${currentIndex + 1} of ${videos.length}'),
        centerTitle: true,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              Card(
                elevation: 3,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(18),
                  child: Column(
                    children: [
                      Text(
                        currentVideo['title']!,
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 12),
                      Text(
                        currentVideo['description']!,
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          fontSize: 15,
                          height: 1.5,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 18),
              Expanded(
                child: Center(
                  child: isLoading
                      ? const CircularProgressIndicator()
                      : (_controller != null &&
                              _controller!.value.isInitialized)
                          ? ClipRRect(
                              borderRadius: BorderRadius.circular(14),
                              child: AspectRatio(
                                aspectRatio: _controller!.value.aspectRatio,
                                child: VideoPlayer(_controller!),
                              ),
                            )
                          : const Text(
                              'Video could not be loaded.',
                              style: TextStyle(fontSize: 16),
                            ),
                ),
              ),
              const SizedBox(height: 18),
              LinearProgressIndicator(
                value: (currentIndex + 1) / videos.length,
                minHeight: 8,
              ),
              const SizedBox(height: 10),
              Text(
                'Progress: ${currentIndex + 1} / ${videos.length}',
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 18),
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton(
                      onPressed: isLoading ? null : _togglePlayPause,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        child: Text(
                          _controller != null &&
                                  _controller!.value.isInitialized &&
                                  _controller!.value.isPlaying
                              ? 'Pause'
                              : 'Play',
                          style: const TextStyle(fontSize: 16),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: isLoading ? null : _nextVideo,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        child: Text(
                          currentIndex == videos.length - 1
                              ? 'Finish'
                              : 'Next',
                          style: const TextStyle(fontSize: 16),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}