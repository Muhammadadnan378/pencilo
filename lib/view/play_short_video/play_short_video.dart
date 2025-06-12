import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:pencilo/data/current_user_data/current_user_Data.dart';
import 'package:pencilo/data/custom_widget/custom_media_query.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';
import '../../data/consts/const_import.dart';
import '../../model/short_video_model.dart';

class PlayShortVideo extends StatefulWidget {
  @override
  _PlayShortVideoState createState() => _PlayShortVideoState();
}

class _PlayShortVideoState extends State<PlayShortVideo> {
  final ShortVideoController ctrl = Get.put(ShortVideoController());
  late YoutubePlayerController _ytController;

  @override
  void initState() {
    super.initState();

    // Setup page listener to track watched videos and mark them in Firestore
    ctrl.pageController.addListener(() {
      final page = ctrl.pageController.page?.round() ?? 0;
      if (page < ctrl.videoList.length) {
        final vid = ctrl.videoList[page].videoId;
        if (!ctrl.sessionWatchedVideos.contains(vid)) {
          ctrl.sessionWatchedVideos.add(vid);
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

  @override
  void dispose() {
    _ytController.dispose();
    ctrl.pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: StreamBuilder<QuerySnapshot>(
        stream:
        FirebaseFirestore.instance.collection("youtube_short_videos").snapshots(),
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

          if (filtered.isEmpty) {
            return const Center(child: CustomText(text: "No new videos. Come back later!",size: 18,));
          }

          // Build videoList once
          ctrl.videoList.value = filtered
              .map((d) => ShortVideoModel.fromJson(d.data() as Map<String, dynamic>))
              .toList();

          return PageView.builder(
            scrollDirection: Axis.vertical,
            controller: ctrl.pageController,
            itemCount: ctrl.videoList.length,
            itemBuilder: (_, idx) {
              final video = ctrl.videoList[idx];
              final initialVid = YoutubePlayer.convertUrlToId(video.videoUrl) ?? '';

              _ytController = YoutubePlayerController(
                initialVideoId: initialVid,
                flags: const YoutubePlayerFlags(
                  autoPlay: true,
                  mute: false,
                  loop: true,
                ),
              );

              // Handle likes
              if (video.isLiked.contains(CurrentUserData.uid)) {
                ctrl.isLiked(true);
              } else {
                ctrl.isLiked(false);
              }

              return Stack(
                children: [
                  Center(
                    child: SizedBox(
                      width: SizeConfig.screenWidth,
                      height: SizeConfig.screenHeight * 0.7,
                      child: YoutubePlayer(
                        controller: _ytController,
                        bottomActions: const [
                          CurrentPosition(),
                          ProgressBar(isExpanded: true),
                          RemainingDuration(),
                          PlaybackSpeedButton(),
                        ],
                      ),
                    ),
                  ),
                  // Up/Down navigation
                  Positioned(
                    right: 20,
                    top: 10,
                    bottom: 0,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        IconButton(
                          icon: const Icon(CupertinoIcons.up_arrow,
                              color: Colors.white, size: 40),
                          onPressed: () {
                            ctrl.pageController.nextPage(
                                duration: const Duration(milliseconds: 200),
                                curve: Curves.easeInOut);
                          },
                        ),
                        SizedBox(height: SizeConfig.screenHeight * 0.2),
                        IconButton(
                          icon: const Icon(CupertinoIcons.down_arrow,
                              color: Colors.white, size: 40),
                          onPressed: () {
                            ctrl.pageController.previousPage(
                                duration: const Duration(milliseconds: 200),
                                curve: Curves.easeInOut);
                          },
                        ),
                      ],
                    ),
                  ),
                  // Like / Comment / Share buttons
                  Align(
                    alignment: Alignment.bottomRight,
                    child: Padding(
                      padding:
                      const EdgeInsets.only(right: 10, bottom: 40),
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
                              size: 31,
                            ),
                            onPressed: () async {
                              final liked = ctrl.isLiked.value;
                              ctrl.isLiked(!liked);
                              await FirebaseFirestore.instance
                                  .collection("youtube_short_videos")
                                  .doc(video.videoId)
                                  .update({
                                "isLiked": liked
                                    ? FieldValue.arrayRemove(
                                    [CurrentUserData.uid])
                                    : FieldValue.arrayUnion(
                                    [CurrentUserData.uid])
                              });
                            },
                          )),
                          const SizedBox(height: 16),
                          IconButton(
                            icon: const Icon(Icons.comment,
                                size: 31, color: Colors.white),
                            onPressed: () {
                              ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                      content: Text("Comment clicked!")));
                            },
                          ),
                          const SizedBox(height: 16),
                          IconButton(
                            icon: const Icon(Icons.share,
                                size: 31, color: Colors.white),
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
          );
        },
      ),
    );
  }
}


class ShortVideoController extends GetxController{
  RxBool isPlay = false.obs;
  RxBool isLiked = false.obs;
  RxBool showPlayPause = false.obs;
  PageController pageController = PageController();
  RxList<ShortVideoModel> videoList = <ShortVideoModel>[].obs;
  late List<YoutubePlayerController> controllers;
  RxList<String> sessionWatchedVideos = <String>[].obs;


  @override
  void dispose() {
    pageController.dispose();
    super.dispose();
  }

  /// **Share video on WhatsApp**
  Future<void> shareOnWhatsApp(String videoUrl) async {
    final videoId = YoutubePlayer.convertUrlToId(videoUrl);
    final thumbnailUrl = "https://img.youtube.com/vi/$videoId/0.jpg";

    final message = Uri.encodeComponent(
        "🎬 Check out this video!\n\n"
            "🖼️ [Thumbnail Image]\n\n"
            "🔗 $videoUrl"
    );

    final whatsappUrl = "https://wa.me/?text=$message";

    if (await canLaunchUrl(Uri.parse(whatsappUrl))) {
      await launchUrl(
          Uri.parse(whatsappUrl), mode: LaunchMode.externalApplication);
    } else {
      print("Could not launch WhatsApp");
    }
  }
}

// class PlayShortVideo extends StatelessWidget {
//   PlayShortVideo({super.key});
//
//   final ShortVideoController shortVideoController = Get.put(
//       ShortVideoController());
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: StreamBuilder<QuerySnapshot>(
//         stream: FirebaseFirestore.instance.collection("youtube_short_videos").snapshots(),
//         builder: (context, snapshot) {
//           if(snapshot.connectionState == ConnectionState.waiting){
//             return Center(child: CircularProgressIndicator(),);
//           }
//           if(snapshot.hasError){
//             return Center(child: Text("Error: ${snapshot.error}"),);
//           }
//           if(!snapshot.hasData || snapshot.data!.docs.isEmpty){
//             return Center(child: Text("No data available"),);
//           }
//           var data = snapshot.data!.docs;
//           return PageView.builder(
//             scrollDirection: Axis.vertical,
//             controller: shortVideoController.pageController,
//             physics: const ClampingScrollPhysics(),
//             itemCount: data.length,
//             onPageChanged: shortVideoController.onPageChanged,
//             itemBuilder: (context, index) {
//               final video = ShortVideoModel.fromJson(data[index].data() as Map<String, dynamic>);
//               shortVideoController.videoList.add(video);
//               final controller = shortVideoController.controllers[index];
//               return Stack(
//                 children: [
//                   Container(
//                     color: Colors.black,
//                     height: double.infinity,
//                     width: double.infinity,
//                   ),
//                   //youtube video show
//                   Center(
//                     child: SizedBox(
//                       height: SizeConfig.screenHeight * 0.6,
//                       child: YoutubePlayer(
//                         controller: shortVideoController.controllers[index],
//                         showVideoProgressIndicator: true,
//                         aspectRatio: 0.5,
//                         progressIndicatorColor: Colors.redAccent,
//                       ),
//                     ),
//                   ),
//                   Container(
//                     color: Colors.grey.withAlpha(25),
//                     height: double.infinity,
//                     width: double.infinity,
//                   ),
//                   Center(
//                     child: CustomCard(
//                       width: SizeConfig.screenWidth * 0.9,
//                       height: SizeConfig.screenHeight * 0.1,
//                       child: Row(
//                         mainAxisAlignment: MainAxisAlignment.spaceAround,
//                         children: [
//                           Obx(() {
//                             return shortVideoController.showPlayPause.value
//                                 ? GestureDetector(
//                               onTap: () {
//                                 shortVideoController.seekBackward(controller);
//                               },
//                               child: Icon(
//                                 CupertinoIcons.gobackward_10,
//                                 color: Colors.white,
//                                 size: 35,
//                               ),
//                             )
//                                 : SizedBox();
//                           }),
//                           // Obx(() {
//                           //   return shortVideoController.showPlayPause.value
//                           //       ? GestureDetector(
//                           //     onTap: () {
//                           //       shortVideoController.togglePlayback(controller);
//                           //       if (!controller.value.isPlaying) {
//                           //         shortVideoController.hideTimer?.cancel();
//                           //         shortVideoController.showPlayPause(false);
//                           //       }
//                           //     },
//                           //     child: Icon(
//                           //       shortVideoController.isPlay.value
//                           //           ? CupertinoIcons.pause_circle_fill
//                           //           : CupertinoIcons.play_arrow_solid,
//                           //       color: Colors.white,
//                           //       size: 50,
//                           //     ),
//                           //   )
//                           //       : SizedBox();
//                           // }),
//                           Obx(() {
//                             return shortVideoController.showPlayPause.value
//                                 ? GestureDetector(
//                               onTap: () {
//                                 shortVideoController.seekForward(controller);
//                               },
//                               child: Icon(
//                                 CupertinoIcons.goforward_10,
//                                 color: Colors.white,
//                                 size: 35,
//                               ),
//                             )
//                                 : SizedBox();
//                           }),
//                         ],
//                       ),
//                     ),
//                   ),
//                   Positioned(
//                     left: 0,
//                     right: 0,
//                     bottom: 10,
//                     child: Obx(() {
//                       return LinearProgressIndicator(
//                         value: shortVideoController.videoProgress.value,
//                         backgroundColor: Colors.grey.withOpacity(0.5),
//                         valueColor: AlwaysStoppedAnimation<Color>(Colors.redAccent),
//                       );
//                     }),
//                   ),
//                   // Like, Share, Comment Icons
//                   Align(
//                     alignment: Alignment.bottomRight,
//                     child: Padding(
//                       padding: const EdgeInsets.only(right: 10.0,bottom: 40),
//                       child: Column(
//                         mainAxisSize: MainAxisSize.min,
//                         children: [
//                           Obx(() {
//                             shortVideoController.isLiked.value;
//                             return IconButton(
//                               icon: Icon(
//                                 shortVideoController.isLiked.value ? Icons.favorite_border : Icons.favorite,
//                                 color: shortVideoController.isLiked.value ? Colors.white : Colors.red, size: 31,),
//                               onPressed: () async {
//                                 if (!video.isLiked.contains(CurrentUserData.uid)) {
//                                   shortVideoController.isLiked(true);
//                                   FirebaseFirestore.instance.collection("youtube_short_videos").doc(video.videoId).update({"isLiked": FieldValue.arrayUnion([CurrentUserData.uid])});
//                                 } else {
//                                   shortVideoController.isLiked(false);
//                                   FirebaseFirestore.instance.collection("youtube_short_videos").doc(video.videoId).update({"isLiked": FieldValue.arrayRemove([CurrentUserData.uid])});
//                                 }
//                               },
//                             );
//                           }),
//                           const SizedBox(height: 16),
//                           IconButton(
//                             icon: const Icon(
//                               Icons.comment, color: Colors.white, size: 31,),
//                             onPressed: () {
//                               ScaffoldMessenger.of(context).showSnackBar(
//                                   SnackBar(content: Text("Comment clicked!"))
//                               );
//                             },
//                           ),
//                           const SizedBox(height: 16),
//                           IconButton(
//                             icon: const Icon(
//                               Icons.share, color: Colors.white, size: 31,),
//                             onPressed: () {
//                               shortVideoController.shareOnWhatsApp(video.videoUrl);
//                             },
//                           ),
//                         ],
//                       ),
//                     ),
//                   ),
//                 ],
//               );
//             },
//           );
//         }
//       ),
//     );
//   }
// }

// class ShortVideoController extends GetxController {
//   RxBool isPlay = false.obs;
//   RxBool showPlayPause = false.obs;
//   RxDouble videoProgress = 0.0.obs;
//   RxList<ShortVideoModel> videoList = <ShortVideoModel>[].obs;
//   RxList<YoutubePlayerController> controllers = <YoutubePlayerController>[].obs;
//   PageController pageController = PageController();
//   Timer? hideTimer;
//   RxBool isLiked = false.obs;
//
//   /// **Toggle play/pause visibility**
//   void togglePlayPause() {
//     if (showPlayPause.value) {
//       hideTimer?.cancel();
//       showPlayPause(false);
//     } else {
//       showPlayPause(true);
//       hideTimer = Timer(const Duration(seconds: 5), () {
//         showPlayPause(false);
//       });
//     }
//   }
//
//   /// **Toggle video playback**
//   void togglePlayback(YoutubePlayerController controller) {
//     if (!controller.value.isPlaying) {
//       controller.play();
//       if (!isPlay.value) isPlay(true);
//     } else {
//       controller.pause();
//       if (isPlay.value) isPlay(false);
//     }
//   }
//
//   /// **Seek backward (adjust if less than 10 seconds)**
//   void seekBackward(YoutubePlayerController controller) {
//     final currentPosition = controller.value.position;
//     final newPosition = currentPosition.inSeconds > 10
//         ? Duration(seconds: currentPosition.inSeconds - 10)
//         : Duration(seconds: 0);
//     controller.seekTo(newPosition);
//   }
//
//   /// **Seek forward**
//   void seekForward(YoutubePlayerController controller) {
//     final currentPosition = controller.value.position;
//     final newPosition = Duration(seconds: currentPosition.inSeconds + 10);
//     controller.seekTo(newPosition);
//   }
//
//   /// **Update video progress**
//   void updateProgress(Duration position, Duration totalDuration) {
//     if (totalDuration.inSeconds > 0) {
//       videoProgress.value = position.inSeconds / totalDuration.inSeconds;
//     }
//   }
//
//   /// **Handle page change for video playback**
//   void onPageChanged(int index) {
//     for (int i = 0; i < controllers.length; i++) {
//       if (i == index) {
//         controllers[i].play();
//         isPlay(true);
//       } else {
//         controllers[i].pause();
//         isPlay(false);
//       }
//     }
//   }
//
//   /// **Move to next video**
//   void nextVideo(int index) {
//     if (index == videoList.length - 1) {
//       pageController.jumpToPage(0);
//     } else {
//       pageController.nextPage(
//         duration: const Duration(milliseconds: 300),
//         curve: Curves.easeInOut,
//       );
//     }
//   }
//
//   /// **Share video on WhatsApp**
//   Future<void> shareOnWhatsApp(String videoUrl) async {
//     final videoId = YoutubePlayer.convertUrlToId(videoUrl);
//     final thumbnailUrl = "https://img.youtube.com/vi/$videoId/0.jpg";
//
//     final message = Uri.encodeComponent(
//         "🎬 Check out this video!\n\n"
//             "🖼️ [Thumbnail Image]\n\n"
//             "🔗 $videoUrl"
//     );
//
//     final whatsappUrl = "https://wa.me/?text=$message";
//
//     if (await canLaunchUrl(Uri.parse(whatsappUrl))) {
//       await launchUrl(
//           Uri.parse(whatsappUrl), mode: LaunchMode.externalApplication);
//     } else {
//       print("Could not launch WhatsApp");
//     }
//   }
// }


// class PlayShortVideo extends StatefulWidget {
//   const PlayShortVideo({super.key});
//
//   @override
//   State<PlayShortVideo> createState() => _PlayShortVideoState();
// }

// class _PlayShortVideoState extends State<PlayShortVideo> {
//   late List<YoutubePlayerController> _controllers;
//   final List<String> _videoLinks = [];
//   final PageController _pageController = PageController();
//
//   @override
//   void initState() {
//     super.initState();
//     _controllers = [];
//     _fetchVideoLinks();
//   }
//
//   Future<void> _fetchVideoLinks() async {
//     final snapshot = await FirebaseFirestore.instance.collection('youtube_short_videos').get();
//     final videoLinks = snapshot.docs.map((doc) {
//       return (doc['videoUrl'] as List<dynamic>)
//           .map((url) => url as String)
//           .toList();
//     }).expand((x) => x).toList();
//
//     for (var videoLink in videoLinks) {
//       final youtubeController = YoutubePlayerController(
//         initialVideoId: YoutubePlayer.convertUrlToId(videoLink) ?? '',
//         flags: const YoutubePlayerFlags(
//           autoPlay: true,  // Video starts playing automatically
//           mute: false,     // Sound is enabled
//           hideControls: false,  // Show default YouTube controls
//           controlsVisibleAtStart: true, // Controls appear at start
//           showLiveFullscreenButton: false, // Hide fullscreen button
//         ),
//       );
//
//       _controllers.add(youtubeController);
//     }
//
//     setState(() {
//       _videoLinks.addAll(videoLinks);
//     });
//   }
//
//   @override
//   void dispose() {
//     for (var controller in _controllers) {
//       controller.dispose();
//     }
//     super.dispose();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: blackColor,
//       body: _videoLinks.isEmpty
//           ? const Center(child: CircularProgressIndicator())
//           : PageView.builder(
//         scrollDirection: Axis.vertical,
//         controller: _pageController,
//         physics: const ClampingScrollPhysics(),
//         itemCount: _videoLinks.length,
//         itemBuilder: (context, index) {
//           final controller = _controllers[index];
//
//           return Stack(
//             children: [
//               // Video Player
//               YoutubePlayer(
//                 controller: controller,
//                 aspectRatio: 0.5,
//                 showVideoProgressIndicator: true,
//                 progressIndicatorColor: Colors.redAccent,
//                 onEnded: (data) {
//                   if (index == _videoLinks.length - 1) {
//                     _pageController.jumpToPage(0);
//                   } else {
//                     _pageController.nextPage(
//                       duration: const Duration(milliseconds: 300),
//                       curve: Curves.easeInOut,
//                     );
//                   }
//                 },
//               ),
//               // Like, Comment, Share Buttons
//               Positioned(
//                 right: 16,
//                 bottom: 50,
//                 child: Column(
//                   mainAxisSize: MainAxisSize.min,
//                   children: [
//                     IconButton(
//                       icon: const Icon(Icons.favorite_border, color: Colors.white, size: 31,),
//                       onPressed: () {
//                         // Handle like action
//                         ScaffoldMessenger.of(context).showSnackBar(
//                             SnackBar(content: Text("Liked!"))
//                         );
//                       },
//                     ),
//                     const SizedBox(height: 16),
//                     IconButton(
//                       icon: const Icon(Icons.comment, color: Colors.white, size: 31,),
//                       onPressed: () {
//                         // Handle comment action
//                         ScaffoldMessenger.of(context).showSnackBar(
//                             SnackBar(content: Text("Comment clicked!"))
//                         );
//                       },
//                     ),
//                     const SizedBox(height: 16),
//                     IconButton(
//                       icon: const Icon(Icons.share, color: Colors.white, size: 31,),
//                       onPressed: () {
//                         final videoUrl = "https://www.youtube.com/watch?v=${YoutubePlayer.convertUrlToId(_videoLinks[index])}";
//                         _shareOnWhatsApp(videoUrl);
//                       },
//                     ),
//                   ],
//                 ),
//               ),
//             ],
//           );
//         },
//       ),
//     );
//   }
//
//   void _shareOnWhatsApp(String videoUrl) async {
//     final videoId = YoutubePlayer.convertUrlToId(videoUrl);
//     final thumbnailUrl = "https://img.youtube.com/vi/$videoId/0.jpg"; // YouTube thumbnail
//
//     final message = Uri.encodeComponent(
//         "🎬 Check out this video!\n\n"
//             "🖼️ [Thumbnail Image]\n\n" // Placeholder for thumbnail
//             "🔗 $videoUrl"
//     );
//
//     final whatsappUrl = "https://wa.me/?text=$message";
//
//     if (await canLaunchUrl(Uri.parse(whatsappUrl))) {
//       await launchUrl(Uri.parse(whatsappUrl), mode: LaunchMode.externalApplication);
//     } else {
//       print("Could not launch WhatsApp");
//     }
//   }
//
// }
