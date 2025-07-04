import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:pencilo/controller/student_home_view_controller.dart';
import 'package:pencilo/data/consts/const_import.dart';
import 'package:pencilo/data/custom_widget/app_logo_widget.dart';
import '../../../add_methods/add_methods_class.dart';
import '../../../data/consts/images.dart';
import '../../../data/custom_widget/custom_media_query.dart';
import '../../../model/subjects_model.dart';
import 'answer_view.dart';

class SubjectPartsView extends StatelessWidget {
  final String? subject;
  final String? subjectName;
  final Color? colors;
  final Color? bgColor;

  SubjectPartsView({super.key, this.subject, this.colors, this.bgColor, this.subjectName});
  final interstitialAdService = InterstitialAdService();
  final rewardedAdService = RewardedAdService();
  final appOpenAdService = AppOpenAdService(); // Optional if you plan to use it here
  final StudentHomeViewController controller = Get.put(StudentHomeViewController());

  // Fetch the data from GitHub
  Future<Map<String, dynamic>> fetchData() async {
    final url = 'https://raw.githubusercontent.com/Muhammadadnan378/my-json-data/main/${subject!.trim()}.json';
    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Failed to load data');
    }
  }


  @override
  Widget build(BuildContext context) {
    // interstitialAdService.loadInterstitialAd();
    /// rewardedAdService.loadRewardedAd();
    // appOpenAdService.loadAppOpenAd();
    if (subject == null) {
      return Center(child: Text("No subject selected"));
    }
    return Scaffold(
      appBar: AppBar(),
      body: Center(
        child: GetBuilder<StudentHomeViewController>(builder: (controller) {
          return Padding(
            padding: const EdgeInsets.only(left: 15.0, right: 15),
            child: ListView(
              children: [
                Align(alignment: Alignment.centerLeft,child: AppLogoWidget(width: 110,height: 80,fit: BoxFit.cover,)),
                SizedBox(height: 15,),
                CustomText(
                  text: '$subjectName Answer',
                  color: blackColor,
                  fontWeight: FontWeight.bold,
                  fontFamily: interFontFamily,
                  size: 18,),
                SizedBox(height: 15,),
                FutureBuilder<Map<String, dynamic>>(
                  future: fetchData(),
                  builder: (context, snapshot) {
                    debugPrint('Error: ${snapshot.error}');
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(child: CircularProgressIndicator());
                    } else if (snapshot.hasError) {
                      return Center(child: Text('Error: ${snapshot.error}'));
                    } else {
                      final data = snapshot.data!;
                      final listKey = data.keys.firstWhere((key) {
                        final list = data[key];
                        if (list is List) {
                          return list.any((item) => item['subjectName'] == subject);
                        }
                        return false;
                      }, orElse: () => '');

                      if (listKey.isEmpty) {
                        return Center(child: Text("No data found for $subject"));
                      }

                      final dynamic rawSubjectData = data[listKey]!.firstWhere(
                            (item) => item['subjectName'] == subject,
                        orElse: () => null,
                      );

                      if (rawSubjectData == null || rawSubjectData is! Map<String, dynamic>) {
                        return Center(child: Text("Subject data not found"));
                      }

                      final List<String> chapterParts = rawSubjectData.keys
                          .where((key) => key.startsWith("chapter part"))
                          .toList();

                      final subjectList = data[listKey];
                      if (subjectList == null || subjectList is! List) {
                        return Center(child: Text("No data available"));
                      }

                      final subjectData = subjectList.firstWhere(
                            (item) => item['subjectName'] == subject,
                        orElse: () => null,
                      );

                      if (subjectData == null || subjectData is! Map<String, dynamic>) {
                        return Center(child: Text("Subject data not found"));
                      }

                      return ListView.builder(
                        shrinkWrap: true,
                        itemCount: chapterParts.length,
                        physics: NeverScrollableScrollPhysics(),
                        itemBuilder: (context, index) {
                          final partKey = chapterParts[index];
                          final chapters = subjectData[partKey] as List<dynamic>;
                          final partIndex = index + 1;

                          return Padding(
                            padding: const EdgeInsets.only(bottom: 10.0),
                            child: Column(
                              children: [
                                Obx(() {
                                  controller.currentIndex.value;
                                  return CustomCard(
                                    onTap: () {
                                      if (controller.currentIndex.value != partIndex) {
                                        controller.currentIndex.value = partIndex;
                                      } else {
                                        controller.currentIndex.value = 0;
                                      }
                                    },
                                    alignment: Alignment.center,
                                    width: double.infinity,
                                    height: 100,
                                    color: controller.currentIndex.value == partIndex
                                        ? bgColor
                                        : whiteColor,
                                    borderRadius: 10,
                                    border: Border.all(color: blackColor),
                                    boxShadow: [
                                      BoxShadow(
                                          color: blackColor,
                                          spreadRadius: 0.5,
                                          offset: Offset(0, 4))
                                    ],
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                                      children: [
                                        CustomText(
                                          text: "Part $partIndex",
                                          size: 30,
                                          color: controller.currentIndex.value == partIndex
                                              ? whiteColor
                                              : blackColor,
                                          fontWeight: FontWeight.w500,
                                          fontFamily: GoogleFonts.spaceGrotesk().fontFamily,
                                        ),
                                        Obx(() {
                                          return controller.currentIndex.value == partIndex
                                              ? Icon(Icons.remove_circle,
                                              size: 50, color: whiteColor)
                                              : CustomCard(
                                            border: Border.all(color: blackColor),
                                            borderRadius: 50,
                                            child: Icon(
                                              CupertinoIcons.add,
                                              size: 50,
                                              color: blackColor,
                                              weight: 0.1,
                                            ),
                                          );
                                        })
                                      ],
                                    ),
                                  );
                                }),
                                Obx(() => controller.currentIndex.value == partIndex
                                    ? Padding(
                                  padding: const EdgeInsets.only(top: 10.0),
                                  child: CustomCard(
                                    color: colors,
                                    borderRadius: 10,
                                    padding: EdgeInsets.all(20),
                                    child: ListView.builder(
                                      shrinkWrap: true,
                                      physics: NeverScrollableScrollPhysics(),
                                      itemCount: chapters.length,
                                      itemBuilder: (context, index) {
                                        final chapter = SubjectModel.fromMap(chapters[index]);
                                        return GestureDetector(
                                          onTap: () {
                                            controller.currentSelectedQuestion.value = 0;
                                            // Use your navigation logic or AnswerView here
                                            Get.to(AnswerView(myData: chapter,));
                                          },
                                          child: Column(
                                            children: [
                                              Row(
                                                children: [
                                                  CustomText(
                                                    text: "${index + 1}",
                                                    size: 20,
                                                    fontWeight: FontWeight.w500,
                                                  ),
                                                  SizedBox(width: 20),
                                                  SizedBox(
                                                    width: SizeConfig.screenWidth * 0.6,
                                                    child: CustomText(
                                                      text: chapter.chapterName ?? '',
                                                      size: 14,
                                                      fontWeight: FontWeight.w500,
                                                      maxLines: 1,
                                                    ),
                                                  )
                                                ],
                                              ),
                                              Divider(
                                                color: grayColor,
                                                height: 10,
                                                thickness: 0.6,
                                              )
                                            ],
                                          ),
                                        );
                                      },
                                    ),
                                  ),
                                )
                                    : SizedBox())
                              ],
                            ),
                          );
                        },
                      );
                    }
                  },
                ),
              ],
            ),
          );
        }),
      ),
    );
  }
}
