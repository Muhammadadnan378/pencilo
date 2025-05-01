import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:pencilo/data/custom_widget/show_images_view.dart';
import 'package:pencilo/data/custom_widget/show_youtube_video.dart';
import 'package:pencilo/model/subjects_model.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

import '../../controller/home_view_controller.dart';
import '../../data/consts/const_import.dart';
import '../../data/consts/images.dart';
import '../../data/custom_widget/custom_card.dart';
import '../../data/custom_widget/custom_media_query.dart';
import '../../data/custom_widget/custom_text_widget.dart';

class AnswerView extends StatelessWidget {
  final SubjectModel myData;

  AnswerView({super.key, required this.myData});
  final HomeViewController controller = Get.put(HomeViewController());

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
              text: myData.chapterName ?? "",
              color: blackColor,
              fontFamily: poppinsFontFamily,
              size: 18,
              fontWeight: FontWeight.w600,
            ),
            SizedBox(height: 10),

            // Display multiple questions and answers
            myData.questions != null && myData.questions!.isNotEmpty
                ? ListView.builder(
              shrinkWrap: true,
              itemCount: myData.questions!.length,
              physics: NeverScrollableScrollPhysics(),
              itemBuilder: (context, index) {
                final questionData = SubjectModel.fromMap(myData.questions![index]);
                final questionNumber = index + 1;
                final isLastQuestion = index == myData.questions!.length - 1;
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CustomText(
                      text: "Q $questionNumber. ${questionData.question}",
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
                            text: questionData.ans ?? '',
                            style: TextStyle(fontWeight: FontWeight.w100),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 20),
                    questionData.imgUrl != null
                        ? GestureDetector(
                      onTap: () {
                        Get.to(ShowImagesView(
                            imagePaths: [questionData.imgUrl!],
                            initialIndex: 0));
                      },
                      child: Image.network(
                        questionData.imgUrl!,
                        height: 200,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) =>
                        const Icon(Icons.broken_image),
                      ),
                    )
                        : SizedBox(),
                    SizedBox(height: 12),
                    CustomText(
                      text: 'Tutorial Video',
                      color: blackColor,
                      fontFamily: poppinsFontFamily,
                      size: 16,
                      fontWeight: FontWeight.w700,
                    ),
                    SizedBox(height: 12),
                    questionData.youtubeVideoPath != null
                        ? GestureDetector(
                      onTap: () {
                        Get.to(ShowYoutubeVideo(
                          videoUrl: questionData.youtubeVideoPath!,
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
                              "https://img.youtube.com/vi/${YoutubePlayer.convertUrlToId(questionData.youtubeVideoPath!!)}/0.jpg", // YouTube thumbnail
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
                    )
                        : SizedBox(),
                    SizedBox(height: 10),
                    if (!isLastQuestion)
                      Divider(
                        color: blackColor,
                        thickness: 1,
                      ),
                    SizedBox(height: 10),
                  ],
                );
              },
            )
                : Center(
              child: CustomText(
                text: "No questions available for this chapter.",
                color: blackColor,
                fontFamily: poppinsFontFamily,
                size: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

