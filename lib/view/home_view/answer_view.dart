import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:pencilo/view/show_youtube_video.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

import '../../controller/subjects_controller.dart';
import '../../data/consts/const_import.dart';
import '../../data/consts/images.dart';
import '../../data/custom_widget/custom_card.dart';
import '../../data/custom_widget/custom_media_query.dart';
import '../../data/custom_widget/custom_text_widget.dart';

class AnswerView extends StatelessWidget {
  final String? subject;

  AnswerView({super.key, this.subject});
  final SubjectsController controller = Get.put(SubjectsController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Padding(
        padding: const EdgeInsets.only(left: 16.0, right: 16),
        child: ListView(
          children: [
            Row(
              children: [
                Column(
                  children: [
                    CustomText(
                      text: 'Aniket Ganesh',
                      color: blackColor,
                      fontFamily: interFontFamily,
                      size: 8,
                    ),
                    SizedBox(height: 5),
                    CustomCard(
                      alignment: Alignment.center,
                      borderRadius: 100,
                      color: Color(0xff57A8B8),
                      width: 41,
                      height: 41,
                      child: CustomText(
                        text: "AG",
                        size: 20,
                        color: blackColor,
                        fontFamily: nixinOneFontFamily,
                      ),
                    ),
                  ],
                ),
                Spacer(),
                IconButton(
                  onPressed: () {},
                  icon: Icon(Icons.notifications_rounded, size: 25),
                ),
              ],
            ),
            SizedBox(height: 20),
            CustomText(
              text: '$subject Answer',
              color: blackColor,
              fontFamily: poppinsFontFamily,
              size: 18,
              fontWeight: FontWeight.w600,
            ),
            SizedBox(height: 10),
            CustomText(
              text: 'Chapter Name',
              color: blackColor,
              fontFamily: poppinsFontFamily,
              size: 18,
              fontWeight: FontWeight.w300,
            ),
            SizedBox(height: 10),
            CustomText(
              text: 'Q.1  What is your name?',
              color: blackColor,
              fontFamily: poppinsFontFamily,
              size: 18,
              fontWeight: FontWeight.w600,
            ),
            SizedBox(height: 10),
            RichText(
              text: TextSpan(
                style: TextStyle(
                  fontFamily: poppinsFontFamily,
                  fontSize: 16,
                  color: blackColor,
                ),
                children: [
                  TextSpan(
                    text: 'Ans: ',
                    style: TextStyle(fontWeight: FontWeight.w600),
                  ),
                  TextSpan(
                    text: 'My name is Muhammad Adnan',
                    style: TextStyle(fontWeight: FontWeight.w100),
                  ),
                ],
              ),
            ),
            SizedBox(height: 20),
            CustomText(
              text: 'Tutorial Video',
              color: blackColor,
              fontFamily: poppinsFontFamily,
              size: 16,
              fontWeight: FontWeight.w700,
            ),
            SizedBox(height: 12),
            // StreamBuilder to fetch URL from Firestore and show the video or play icon
            StreamBuilder<DocumentSnapshot>(
              stream: FirebaseFirestore.instance
                  .collection('youtube_urls')
                  .doc(controller.videoUrlUid)
                  .snapshots(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                }

                if (!snapshot.hasData || snapshot.data == null) {
                  return Center(child: Text('No data available'));
                }

                var videoUrl = snapshot.data!['videoUrl'];

                if (videoUrl != null && videoUrl.isNotEmpty) {
                  // Show thumbnail or player if URL is available
                  return GestureDetector(
                    onTap: () {
                      Get.to(ShowYoutubeVideo(
                        videoUrl: videoUrl, // Navigate to ShowYoutubeVideo
                      ));
                    },
                    child: CustomCard(
                      alignment: Alignment.center,
                      width: SizeConfig.screenWidth * 0.8,
                      height: SizeConfig.screenHeight * 0.3,
                      color: Color(0xffD9D9D9),
                      child: Stack(
                        children: [
                          Image.network(
                            "https://img.youtube.com/vi/${YoutubePlayer.convertUrlToId(videoUrl)}/0.jpg", // YouTube thumbnail
                            height: SizeConfig.screenHeight * 0.3,
                            width: SizeConfig.screenWidth * 0.8,
                            fit: BoxFit.cover,
                          ),
                          Positioned(
                            bottom: 0,
                            right: 0,
                            top: 0,
                            left: 0,
                            child: Icon(
                              Icons.play_circle,
                              size: 40,
                              color: whiteColor,
                            ),
                          )
                        ],
                      ),
                    ),
                  );
                } else {
                  // If no URL is provided, show play icon
                  return GestureDetector(
                    onTap: () {
                      Get.to(ShowYoutubeVideo(
                        videoUrl: "https://www.youtube.com/shorts/ZkfAaEKV0pk?feature=share",
                      ));
                    },
                    child: CustomCard(
                      alignment: Alignment.center,
                      width: SizeConfig.screenWidth * 0.8,
                      height: SizeConfig.screenHeight * 0.3,
                      color: Color(0xffD9D9D9),
                      child: Icon(Icons.play_circle, size: 50, color: bgColor),
                    ),
                  );
                }
              },
            ),
            SizedBox(height: 30),
            CustomText(
              text: 'Add Youtube View url',
              color: blackColor,
              fontFamily: poppinsFontFamily,
              size: 16,
            ),
            SizedBox(height: 10),
            Align(
              alignment: Alignment.center,
              child: Column(
                children: [
                  SizedBox(
                    width: 300,
                    child: TextField(
                      controller: controller.urlController,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(),
                      ),
                    ),
                  ),
                  SizedBox(height: 15),
                  CustomCard(
                    onTap: () {
                      controller.saveVideoUrl(controller.videoUrlUid); // Save the URL
                    },
                    alignment: Alignment.center,
                    borderRadius: 4,
                    width: 73,
                    height: 33,
                    color: blackColor,
                    child: CustomText(text: "Change Url", size: 13),
                  ),
                ],
              ),
            ),
            SizedBox(height: SizeConfig.screenHeight * 0.08),
          ],
        ),
      ),
    );
  }
}
