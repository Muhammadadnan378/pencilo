import 'package:flutter/material.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';
import '../consts/colors.dart';
import '../consts/const_import.dart';

class ShowYoutubeVideo extends StatelessWidget {
  final String videoUrl;

  const ShowYoutubeVideo({super.key, required this.videoUrl});

  @override
  Widget build(BuildContext context) {
    // Initialize the YouTube player controller
    YoutubePlayerController _controller = YoutubePlayerController(
      initialVideoId: YoutubePlayer.convertUrlToId(videoUrl) ?? '',
      flags: YoutubePlayerFlags(
        autoPlay: true,
        mute: false,
      ),
    );

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            Get.back();
          },
          icon: Icon(
            Icons.arrow_back,
            color: whiteColor,
          ),
        ),
        backgroundColor: Colors.black, // Dark app bar
        title: Text(
          'Video Tutorial',
          style: TextStyle(
            color: Colors.white, // White text color for contrast
          ),
        ),
        elevation: 0,
      ),
      backgroundColor: Colors.black, // Dark background
      body: Column(
        children: [
          Expanded(
            child: YoutubePlayer(
              controller: _controller,
              liveUIColor: Colors.amber,
              aspectRatio: 16 / 9, // Aspect ratio for full-screen video
            ),
          ),
        ],
      ),
    );
  }
}
