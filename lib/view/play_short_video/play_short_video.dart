import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:pencilo/data/current_user_data/current_user_Data.dart';
import 'package:pencilo/data/custom_widget/custom_media_query.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';
import '../../data/consts/const_import.dart';
import '../../model/short_video_model.dart';

class PlayShortVideo extends StatelessWidget {
  final ShortVideoController ctrl = Get.put(ShortVideoController());

  PlayShortVideo({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection("youtube_short_videos")
            .snapshots(),
        builder: (ctx, snap) {
          if (snap.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snap.hasError) {
            return Center(child: Text("Error: ${snap.error}"));
          }

          final docs = snap.data?.docs ?? [];

          final filtered = docs.where((doc) {
            final watched = List<String>.from(doc['isVideoWatched'] ?? []);
            final vid = doc.id;
            return !watched.contains(CurrentUserData.uid) ||
                ctrl.sessionWatchedVideos.contains(vid);
          }).toList();

          // Ensure controller only resets when needed
          if (ctrl.videoList.isEmpty || ctrl.videoList.length != filtered.length) {
            ctrl.setVideoList(filtered);
          }

          if (filtered.isEmpty) {
            return const Center(
              child: CustomText(
                  text: "No new videos. Come back later!", size: 18),
            );
          }

          return Obx(() => PageView.builder(
            physics: const NeverScrollableScrollPhysics(),
            scrollDirection: Axis.vertical,
            controller: ctrl.pageController,
            itemCount: ctrl.videoList.length,
            itemBuilder: (_, idx) {
              final video = ctrl.videoList[idx];
              final ytController = ctrl.controllers[idx];

              ctrl.checkLikedStatus(video);

              return Stack(
                children: [
                  Center(
                    child: SizedBox(
                      width: SizeConfig.screenWidth,
                      height: SizeConfig.screenHeight * 0.7,
                      child: YoutubePlayerBuilder(
                        player: YoutubePlayer(
                          controller: ytController,
                          showVideoProgressIndicator: false,
                        ),
                        builder: (context, player) => player,
                      ),
                    ),
                  ),
                  // Navigation Arrows
                  Positioned(
                    right: 20,
                    top: 10,
                    bottom: 0,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        IconButton(
                          icon: const Icon(CupertinoIcons.up_arrow,
                              color: Colors.white, size: 30),
                          onPressed: () {
                            ctrl.pageController.nextPage(
                              duration: const Duration(milliseconds: 200),
                              curve: Curves.easeInOut,
                            );
                          },
                        ),
                        SizedBox(height: SizeConfig.screenHeight * 0.2),
                        IconButton(
                          icon: const Icon(CupertinoIcons.down_arrow,
                              color: Colors.white, size: 30),
                          onPressed: () {
                            ctrl.pageController.previousPage(
                              duration: const Duration(milliseconds: 200),
                              curve: Curves.easeInOut,
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                  // Actions
                  Align(
                    alignment: Alignment.bottomRight,
                    child: Padding(
                      padding: const EdgeInsets.only(right: 10, bottom: 40),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Obx(() => IconButton(
                            icon: Icon(
                              ctrl.isLiked.value
                                  ? Icons.favorite
                                  : Icons.favorite_border,
                              color: ctrl.isLiked.value
                                  ? Colors.red
                                  : Colors.white,
                              size: 25,
                            ),
                            onPressed: () =>
                                ctrl.toggleLike(video.videoId),
                          )),
                          const SizedBox(height: 16),
                          IconButton(
                            icon: const Icon(Icons.comment,
                                size: 25, color: Colors.white),
                            onPressed: () {
                              ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                      content: Text("Comment clicked!")));
                            },
                          ),
                          const SizedBox(height: 16),
                          IconButton(
                            icon: const Icon(Icons.share,
                                size: 25, color: Colors.white),
                            onPressed: () =>
                                ctrl.shareOnWhatsApp(video.videoUrl),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              );
            },
          ));
        },
      ),
    );
  }
}

class ShortVideoController extends GetxController {
  RxBool isLiked = false.obs;
  PageController pageController = PageController();
  RxList<ShortVideoModel> videoList = <ShortVideoModel>[].obs;
  RxList<String> sessionWatchedVideos = <String>[].obs;
  List<YoutubePlayerController> controllers = [];

  @override
  void onInit() {
    super.onInit();
    pageController.addListener(() {
      final page = pageController.page?.round() ?? 0;
      if (page < videoList.length) {
        final vid = videoList[page].videoId;
        if (!sessionWatchedVideos.contains(vid)) {
          sessionWatchedVideos.add(vid);
          Future.delayed(const Duration(seconds: 3), () {
            FirebaseFirestore.instance
                .collection("youtube_short_videos")
                .doc(vid)
                .update({
              "isVideoWatched": FieldValue.arrayUnion([CurrentUserData.uid])
            });
          });
        }
      }
    });
  }

  void setVideoList(List<QueryDocumentSnapshot> docs) {
    // Dispose previous controllers
    controllers.forEach((c) => c.dispose());

    videoList.value = docs
        .map((d) => ShortVideoModel.fromJson(d.data() as Map<String, dynamic>))
        .toList();

    controllers = videoList.map((video) {
      final videoId = YoutubePlayer.convertUrlToId(video.videoUrl) ?? '';
      return YoutubePlayerController(
        initialVideoId: videoId,
        flags: const YoutubePlayerFlags(
          autoPlay: true,
          mute: false,
          hideControls: true,
          loop: true,
        ),
      );
    }).toList();
  }

  void checkLikedStatus(ShortVideoModel video) {
    isLiked.value = video.isLiked.contains(CurrentUserData.uid);
  }

  Future<void> toggleLike(String videoId) async {
    final liked = isLiked.value;
    isLiked(!liked);
    await FirebaseFirestore.instance
        .collection("youtube_short_videos")
        .doc(videoId)
        .update({
      "isLiked": liked
          ? FieldValue.arrayRemove([CurrentUserData.uid])
          : FieldValue.arrayUnion([CurrentUserData.uid])
    });
  }

  Future<void> shareOnWhatsApp(String videoUrl) async {
    final videoId = YoutubePlayer.convertUrlToId(videoUrl);
    final message = Uri.encodeComponent(
        "🎬 Check out this video!\n\n🔗 $videoUrl");
    final whatsappUrl = "https://wa.me/?text=$message";

    if (await canLaunchUrl(Uri.parse(whatsappUrl))) {
      await launchUrl(Uri.parse(whatsappUrl),
          mode: LaunchMode.externalApplication);
    } else {
      print("Could not launch WhatsApp");
    }
  }

  @override
  void onClose() {
    pageController.dispose();
    controllers.forEach((c) => c.dispose());
    super.onClose();
  }
}
