import 'package:pencilo/data/custom_widget/show_images_view.dart';
import 'package:pencilo/data/custom_widget/show_youtube_video.dart';
import 'package:pencilo/model/subjects_model.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

import '../../../controller/student_home_view_controller.dart';
import '../../../data/consts/const_import.dart';
import '../../../data/consts/images.dart';
import '../../../data/custom_widget/app_logo_widget.dart';
import '../../../data/custom_widget/custom_media_query.dart';

class AnswerView extends StatelessWidget {
  final SubjectModel myData;

  AnswerView({super.key, required this.myData});

  final StudentHomeViewController controller = Get.put(StudentHomeViewController());


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Padding(
        padding: const EdgeInsets.only(left: 16.0, right: 16),
        child: ListView(
          children: [
            Align(alignment: Alignment.centerLeft,child: AppLogoWidget(width: 110,height: 80,fit: BoxFit.cover,)),
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
                  final questionNumber = index + 1;
                  return Row(
                    children: [
                      Obx(() {
                        controller.currentSelectedQuestion.value;
                        return CustomCard(
                          onTap: () {
                            controller.currentSelectedQuestion.value = index;
                          },
                          borderRadius: 30,
                          width: 60,
                          border: Border.all(color: grayColor),
                          alignment: Alignment.center,
                          color: controller.currentSelectedQuestion.value == index ? Color(
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
                myData.questions![controller.currentSelectedQuestion.value],
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
                  if (selectedQuestionData.questionsImage != null && selectedQuestionData.questionsImage != "")
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
              controller.currentSelectedQuestion.value;
              final selectedQuestionData = SubjectModel.fromMap(
                myData.questions![controller.currentSelectedQuestion.value],
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

                      if(subQuestion.ans != null && subQuestion.ans!.isNotEmpty)
                      SizedBox(height: 10),
                      if(subQuestion.ans != null && subQuestion.ans!.isNotEmpty)
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
                      if (subQuestion.imgUrl != null && selectedQuestionData.questionsImage != "")
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
                      if (subQuestion.subAns != null && subQuestion.subAns!.isNotEmpty)
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            CustomText(
                              text: "Matched Columns:",
                              fontFamily: poppinsFontFamily,
                              size: 16,
                              fontWeight: FontWeight.w700,
                              color: blackColor,
                            ),
                            SizedBox(height: 10),
                            Table(
                              border: TableBorder.all(color: Colors.black, width: 1.0),
                              columnWidths: const {
                                0: FlexColumnWidth(3),
                                1: FlexColumnWidth(3),
                                2: FlexColumnWidth(3),
                                3: FlexColumnWidth(3),
                                4: FlexColumnWidth(3),
                              },
                              children: [
                                // Dynamically generate header row from first map
                                TableRow(
                                  children: [
                                    tableHeader(subQuestion.subAns![0]["Column 1"] ?? ""),
                                    tableHeader(subQuestion.subAns![0]["Column 2"] ?? ""),
                                    if (subQuestion.subAns![0].containsKey("Column 3"))
                                      tableHeader(subQuestion.subAns![0]["Column 3"] ?? ""),
                                    if (subQuestion.subAns![0].containsKey("Column 4"))
                                      tableHeader(subQuestion.subAns![0]["Column 4"] ?? ""),
                                    if (subQuestion.subAns![0].containsKey("Column 5"))
                                      tableHeader(subQuestion.subAns![0]["Column 5"] ?? ""),
                                  ],
                                ),
                                // Render remaining items as rows
                                for (var i = 1; i < subQuestion.subAns!.length; i++)
                                  TableRow(
                                    children: [
                                      tableCell(subQuestion.subAns![i]["Column 1"] ?? ""),
                                      tableCell(subQuestion.subAns![i]["Column 2"] ?? ""),
                                      if (subQuestion.subAns![i].containsKey("Column 3"))
                                        tableCell(subQuestion.subAns![i]["Column 3"] ?? ""),
                                      if (subQuestion.subAns![i].containsKey("Column 4"))
                                        tableCell(subQuestion.subAns![i]["Column 4"] ?? ""),
                                      if (subQuestion.subAns![i].containsKey("Column 5"))
                                        tableCell(subQuestion.subAns![i]["Column 5"] ?? ""),
                                    ],
                                  ),
                              ],
                            ),
                            SizedBox(height: 20),
                          ],
                        ),


                      if (subQuestion.youtubeVideoPath != null && subQuestion.youtubeVideoPath != "")
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(height: 12),
                          CustomText(
                            text: 'Tutorial Video',
                            color: blackColor,
                            fontFamily: poppinsFontFamily,
                            size: 16,
                            fontWeight: FontWeight.w700,
                          ),
                          SizedBox(height: 12),
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
                        ],
                      ),
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

  Widget tableHeader(String text) {
    return Padding(
      padding: const EdgeInsets.only(top: 4.0,bottom: 4,left: 3,right: 3),
      child: CustomText(
        text: text,
        fontWeight: FontWeight.bold,
        size: 17,
        color: bgColor,
      ),
    );
  }

  Widget tableCell(String? text) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: CustomText(
        text: text ?? '',
        color: Colors.black,
      ),
    );
  }
}

