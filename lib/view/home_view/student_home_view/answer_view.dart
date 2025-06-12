import 'package:pencilo/data/custom_widget/show_images_view.dart';
import 'package:pencilo/data/custom_widget/show_youtube_video.dart';
import 'package:pencilo/model/subjects_model.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

import '../../../controller/student_home_view_controller.dart';
import '../../../data/consts/const_import.dart';
import '../../../data/consts/images.dart';
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
                                TableRow(
                                  children: [
                                    tableHeader('Column I'),
                                    tableHeader('Column II'),
                                    if (subQuestion.subAns != null && subQuestion.subAns!.any((item) => item.containsKey("Column III")))
                                      tableHeader('Column III'),
                                    if (subQuestion.subAns != null && subQuestion.subAns!.any((item) => item.containsKey("Column IV")))
                                      tableHeader('Column IV'),
                                    if (subQuestion.subAns != null && subQuestion.subAns!.any((item) => item.containsKey("Column V")))
                                      tableHeader('Column V'),
                                  ],
                                ),
                                if (subQuestion.subAns != null)
                                  for (var item in subQuestion.subAns!)
                                    TableRow(
                                      children: [
                                        tableCell(item["Column I"] ?? ""),
                                        tableCell(item["Column II"] ?? ""),
                                        if (item.containsKey("Column III"))
                                          tableCell(item["Column III"] ?? ""),
                                        if (item.containsKey("Column IV"))
                                          tableCell(item["Column IV"] ?? ""),
                                        if (item.containsKey("Column V"))
                                          tableCell(item["Column V"] ?? ""),
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

