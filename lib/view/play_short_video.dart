import 'package:flutter/material.dart';
import 'package:pencilo/data/consts/images.dart';
import 'package:video_player/video_player.dart';

class PlayShortVideo extends StatefulWidget {
  const PlayShortVideo({super.key});

  @override
  State<PlayShortVideo> createState() => _PlayShortVideoState();
}

class _PlayShortVideoState extends State<PlayShortVideo> {
  final List<String> videoAssets = [video1, video2, video3];
  final List<VideoPlayerController> _controllers = [];
  final PageController _pageController = PageController();
  List<bool> _hasStarted = [];

  @override
  void initState() {
    super.initState();
    _initializeControllers();
  }

  Future<void> _initializeControllers() async {
    for (var path in videoAssets) {
      final controller = VideoPlayerController.asset(path);
      await controller.initialize();
      controller.setLooping(true);
      _controllers.add(controller);
      _hasStarted.add(false);
    }
    _controllers[0].play();
    _hasStarted[0] = true;
    setState(() {});
  }

  String _formatDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, "0");
    final hours = twoDigits(duration.inHours);
    final minutes = twoDigits(duration.inMinutes.remainder(60));
    final seconds = twoDigits(duration.inSeconds.remainder(60));
    return duration.inHours > 0 ? "$hours:$minutes:$seconds" : "$minutes:$seconds";
  }

  @override
  void dispose() {
    for (var controller in _controllers) {
      controller.dispose();
    }
    _pageController.dispose();
    super.dispose();
  }

  void _onPageChanged(int index) {
    for (int i = 0; i < _controllers.length; i++) {
      if (i == index) {
        _controllers[i].play();
        _hasStarted[i] = true;
      } else {
        _controllers[i].pause();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _controllers.isEmpty
          ? const Center(child: CircularProgressIndicator())
          : PageView.builder(
        scrollDirection: Axis.vertical,
        controller: _pageController,
        itemCount: _controllers.length,
        onPageChanged: _onPageChanged,
        itemBuilder: (context, index) {
          final controller = _controllers[index];
          return controller.value.isInitialized
              ? GestureDetector(
            onTap: () {
              setState(() {
                controller.value.isPlaying
                    ? controller.pause()
                    : controller.play();
              });
            },
            child: Stack(
              fit: StackFit.expand,
              children: [
                FittedBox(
                  fit: BoxFit.cover,
                  child: SizedBox(
                    width: controller.value.size.width,
                    height: controller.value.size.height,
                    child: VideoPlayer(controller),
                  ),
                ),
                // Use ValueListenableBuilder to track play/pause state
                ValueListenableBuilder(
                  valueListenable: controller,
                  builder: (context, VideoPlayerValue value, child) {
                    return Visibility(
                      visible: !value.isPlaying &&
                          value.position < value.duration,
                      child: const Center(
                        child: Icon(
                          Icons.play_arrow_rounded,
                          color: Colors.white70,
                          size: 64,
                        ),
                      ),
                    );
                  },
                ),
                Positioned(
                  bottom: 56,
                  right: 16,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        onPressed: () {
                          // Handle like action
                        },
                        icon: const Icon(
                          Icons.favorite,
                          color: Colors.white,
                          size: 30,
                        ),
                      ),
                      const SizedBox(height: 8),
                      IconButton(
                        onPressed: () {
                          // Handle comment action
                        },
                        icon: const Icon(
                          Icons.comment,
                          color: Colors.white,
                          size: 30,
                        ),
                      ),
                      const SizedBox(height: 8),
                      IconButton(
                        onPressed: () {
                          // Handle share action
                        },
                        icon: const Icon(
                          Icons.share,
                          color: Colors.white,
                          size: 30,
                        ),
                      ),
                    ],
                  ),
                ),
                Positioned(
                  bottom: 0,
                  left: 0,
                  right: 0,
                  child: ValueListenableBuilder(
                    valueListenable: controller,
                    builder: (context, VideoPlayerValue value, child) {
                      return Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 8),
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [
                              Colors.black.withOpacity(0.7),
                              Colors.transparent
                            ],
                            begin: Alignment.bottomCenter,
                            end: Alignment.topCenter,
                          ),
                        ),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            VideoProgressIndicator(
                              controller,
                              allowScrubbing: true,
                              padding: const EdgeInsets.symmetric(
                                  vertical: 4),
                              colors: VideoProgressColors(
                                playedColor: Colors.redAccent,
                                backgroundColor:
                                Colors.grey.withOpacity(0.4),
                                bufferedColor: Colors.white54,
                              ),
                            ),
                            Row(
                              mainAxisAlignment:
                              MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  _formatDuration(value.position),
                                  style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 12),
                                ),
                                Text(
                                  _formatDuration(value.duration),
                                  style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 12),
                                ),
                              ],
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          )
              : const Center(child: CircularProgressIndicator());
        },
      ),
    );
  }
}
