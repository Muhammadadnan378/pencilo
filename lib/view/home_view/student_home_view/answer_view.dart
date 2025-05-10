import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:pencilo/data/custom_widget/show_images_view.dart';
import 'package:pencilo/data/custom_widget/show_youtube_video.dart';
import 'package:pencilo/model/subjects_model.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

import '../../../controller/student_home_view_controller.dart';
import '../../../data/consts/const_import.dart';
import '../../../data/consts/images.dart';
import '../../../data/custom_widget/custom_card.dart';
import '../../../data/custom_widget/custom_media_query.dart';
import '../../../data/custom_widget/custom_text_widget.dart';

class AnswerView extends StatelessWidget {
  final SubjectModel myData;

  AnswerView({super.key, required this.myData});

  final StudentHomeViewController controller = Get.put(StudentHomeViewController());

  RxInt currentSelectedQuestion = 0.obs;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Padding(
        padding: const EdgeInsets.only(left: 16.0, right: 16),
        child: ListView(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
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
                ? SizedBox(
              height: 35,
              child: ListView.builder(
                shrinkWrap: true,
                itemCount: myData.questions!.length,
                physics: BouncingScrollPhysics(),
                scrollDirection: Axis.horizontal,
                itemBuilder: (context, index) {
                  final questionData = SubjectModel.fromMap(
                      myData.questions![index]);
                  final questionNumber = index + 1;
                  final isLastQuestion = index == myData.questions!.length - 1;
                  return Row(
                    children: [
                      Obx(() {
                        currentSelectedQuestion.value;
                        return CustomCard(
                          onTap: () {
                            currentSelectedQuestion.value = index;
                          },
                          borderRadius: 30,
                          width: 60,
                          border: Border.all(color: grayColor),
                          alignment: Alignment.center,
                          color: currentSelectedQuestion.value == index ? Color(
                              0xff57A8B8) : Colors.transparent,
                          child: CustomText(
                            text: "Q.$questionNumber",
                            color: blackColor,
                            fontFamily: poppinsFontFamily,
                            size: 18,
                            fontWeight: FontWeight.w300,
                          ),
                        );
                      }),
                      SizedBox(width: 7),
                    ],
                  );
                },
              ),
            ) : Center(
              child: CustomText(
                text: "No questions available for this chapter.",
                color: blackColor,
                fontFamily: poppinsFontFamily,
                size: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
            SizedBox(height: 15,),
            Obx(() {
              final selectedQuestionData = SubjectModel.fromMap(
                myData.questions![currentSelectedQuestion.value],
              );

              return selectedQuestionData.questionsTitle != null ? Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if(selectedQuestionData.questionsTitle != null)
                    RichText(
                      text: TextSpan(
                        style: TextStyle(
                          fontFamily: poppinsFontFamily,
                          fontSize: 16,
                          color: blackColor,
                        ),
                        children: [
                          TextSpan(
                            text: "Title: ",
                            style: TextStyle(fontWeight: FontWeight.w600),
                          ),
                          TextSpan(
                            text: selectedQuestionData.questionsTitle ?? 'N/A',
                            style: TextStyle(fontWeight: FontWeight.w400),
                          ),
                        ],
                      ),
                    ),
                  SizedBox(height: 10),
                  if (selectedQuestionData.questionsImage != null)
                    GestureDetector(
                      onTap: () {
                        Get.to(ShowImagesView(
                            imagePaths: [selectedQuestionData.questionsImage!],
                            initialIndex: 0));
                      },
                      child: Image.network(
                        selectedQuestionData.questionsImage!,
                        height: 200,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) =>
                        const Icon(Icons.broken_image),
                      ),
                    ),
                  SizedBox(height: 15),
                ],
              ) : SizedBox();
            }),
            // Display multiple questions and answers
            Obx(() {
              currentSelectedQuestion.value;
              final selectedQuestionData = SubjectModel.fromMap(
                myData.questions![currentSelectedQuestion.value],
              );

              final subQuestions = selectedQuestionData.subQuestion ?? [];

              return subQuestions.isNotEmpty
                  ? ListView.builder(
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                itemCount: subQuestions.length,
                itemBuilder: (context, index) {
                  final subQuestion = SubjectModel.fromMap(subQuestions[index]);
                  final isLastQuestion = index == subQuestions.length - 1;

                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      CustomText(
                        text: "${String.fromCharCode(65 + index)}. ${subQuestion.question}",
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
                              text: subQuestion.ans ?? '',
                              style: TextStyle(fontWeight: FontWeight.w100),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: 20),
                      if (subQuestion.imgUrl != null)
                        GestureDetector(
                          onTap: () {
                            Get.to(ShowImagesView(
                                imagePaths: [subQuestion.imgUrl!],
                                initialIndex: 0));
                          },
                          child: Image.network(
                            subQuestion.imgUrl!,
                            height: 200,
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) =>
                            const Icon(Icons.broken_image),
                          ),
                        ),
                      SizedBox(height: 12),
                      CustomText(
                        text: 'Tutorial Video',
                        color: blackColor,
                        fontFamily: poppinsFontFamily,
                        size: 16,
                        fontWeight: FontWeight.w700,
                      ),
                      SizedBox(height: 12),
                      if (subQuestion.youtubeVideoPath != null)
                        GestureDetector(
                          onTap: () {
                            Get.to(ShowYoutubeVideo(
                              videoUrl: subQuestion.youtubeVideoPath!,
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
                                  "https://img.youtube.com/vi/${YoutubePlayer.convertUrlToId(subQuestion.youtubeVideoPath!)}/0.jpg",
                                  height: SizeConfig.screenHeight * 0.3,
                                  width: SizeConfig.screenWidth * 0.8,
                                  fit: BoxFit.cover,
                                ),
                                Positioned.fill(
                                  child: Icon(
                                    Icons.play_circle,
                                    size: 40,
                                    color: whiteColor,
                                  ),
                                )
                              ],
                            ),
                          ),
                        ),
                      SizedBox(height: 10),
                      if(!isLastQuestion)
                      Divider(color: blackColor, thickness: 1),
                      SizedBox(height: 10),
                    ],
                  );
                },
              )
                  : Center(
                child: CustomText(
                  text: "No sub-questions available for this question.",
                  color: blackColor,
                  fontFamily: poppinsFontFamily,
                  size: 16,
                  fontWeight: FontWeight.w600,
                ),
              );
            }),

          ],
        ),
      ),
    );
  }
}

