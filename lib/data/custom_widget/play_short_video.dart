import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:pencilo/data/consts/colors.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

class PlayShortVideo extends StatefulWidget {
  const PlayShortVideo({super.key});

  @override
  State<PlayShortVideo> createState() => _PlayShortVideoState();
}

class _PlayShortVideoState extends State<PlayShortVideo> {
  late List<YoutubePlayerController> _controllers;
  final List<String> _videoLinks = [];
  final PageController _pageController = PageController();

  @override
  void initState() {
    super.initState();
    _controllers = [];
    _fetchVideoLinks();
  }

  Future<void> _fetchVideoLinks() async {
    final snapshot = await FirebaseFirestore.instance.collection('youtube_short_videos').get();
    final videoLinks = snapshot.docs.map((doc) {
      return (doc['videoUrl'] as List<dynamic>).map((url) => url as String).toList();
    }).expand((x) => x).toList();

    for (var videoLink in videoLinks) {
      final youtubeController = YoutubePlayerController(
        initialVideoId: YoutubePlayer.convertUrlToId(videoLink) ?? '',
        flags: const YoutubePlayerFlags(
          autoPlay: true,
          mute: false,
        ),
      );
      _controllers.add(youtubeController);
    }

    setState(() {
      _videoLinks.addAll(videoLinks);
    });
  }

  @override
  void dispose() {
    for (var controller in _controllers) {
      controller.dispose();
    }
    super.dispose();
  }

  void _onPageChanged(int index) {
    for (int i = 0; i < _controllers.length; i++) {
      if (i == index) {
        _controllers[i].play();
      } else {
        _controllers[i].pause();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _videoLinks.isEmpty
          ? const Center(child: CircularProgressIndicator())
          : PageView.builder(
        scrollDirection: Axis.vertical,
        controller: _pageController,
        physics: const ClampingScrollPhysics(), // Ensure smooth scrolling
        itemCount: _videoLinks.length,
        onPageChanged: _onPageChanged,
        itemBuilder: (context, index) {
          final controller = _controllers[index];

          return GestureDetector(
            onTap: () {
              setState(() {
                if (controller.value.isPlaying) {
                  controller.pause();
                } else {
                  controller.play();
                }
              });
            },
            child: Stack(
              children: [
                Container(
                  color: blackColor,
                  height: double.infinity,
                  width: double.infinity,
                ),
                Center(
                  child: YoutubePlayer(
                    controller: controller,
                    aspectRatio: 0.5,
                    showVideoProgressIndicator: true,
                    progressIndicatorColor: Colors.redAccent,
                    onEnded: (data) {
                      if (index == _videoLinks.length - 1) {
                        _pageController.jumpToPage(0);
                      } else {
                        _pageController.nextPage(
                          duration: const Duration(milliseconds: 300),
                          curve: Curves.easeInOut,
                        );
                      }
                    },
                  ),
                ),
                Container(
                  color: Colors.grey.withValues(alpha: 0.1),
                  height: double.infinity,
                  width: double.infinity,
                )
              ],
            ),
          );
        },
      ),
    );
  }
}