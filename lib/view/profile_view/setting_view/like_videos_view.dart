import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:pencilo/data/consts/colors.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';
import '../../../data/current_user_data/current_user_Data.dart';
import '../../../data/custom_widget/show_youtube_video.dart';
import '../../../model/short_video_model.dart';
import 'package:get/get.dart';

class LikeVideosView extends StatelessWidget {
  LikeVideosView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Liked Videos'),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('youtube_short_videos')
            .where('isLiked', arrayContains: CurrentUserData.uid) // Fetch only liked videos
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return const Center(child: Text("No liked videos found."));
          }

          final likedVideos = snapshot.data!.docs.map((doc) => ShortVideoModel.fromJson(doc.data() as Map<String, dynamic>)).toList();

          return ListView.builder(
            itemCount: likedVideos.length,
            itemBuilder: (context, index) {
              final video = likedVideos[index];

              return Card(
                margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                color: whiteColor,
                child: Stack(
                  children: [
                    Column(
                      children: [
                        GestureDetector(
                          child: YoutubePlayer(
                            controller: YoutubePlayerController(
                              initialVideoId: YoutubePlayer.convertUrlToId(video.videoUrl) ?? '',
                              flags: const YoutubePlayerFlags(
                                autoPlay: false,
                                mute: false,
                                hideControls: true,
                                controlsVisibleAtStart: false,
                              ),
                            ),
                            aspectRatio: 16 / 9,
                            showVideoProgressIndicator: true,
                            progressIndicatorColor: Colors.redAccent,
                          ),
                        ),
                        ListTile(
                          title: Text("Liked Video ${index + 1}"),
                          trailing: IconButton(
                            icon: const Icon(Icons.favorite, color: Colors.red, size: 31),
                            onPressed: () {
                              FirebaseFirestore.instance.collection("youtube_short_videos").doc(video.videoId).update({
                                "isLiked": FieldValue.arrayRemove([CurrentUserData.uid])
                              });
                            },
                          ),
                        ),
                      ],
                    ),
                    Positioned(
                      bottom: 60,
                      right: 0,
                      top: 0,
                      left: 0,
                      child: IconButton(
                          onPressed: () {
                            Get.to(() => ShowYoutubeVideo(videoUrl: video.videoUrl));
                          },
                          icon: Icon(Icons.play_circle,size: 55,color: whiteColor,)
                      ),
                    )
                  ],
                ),
              );
            },
          );
        },
      ),
    );
  }
}
