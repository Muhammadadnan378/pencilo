import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:pencilo/data/consts/const_import.dart';
import 'package:pencilo/data/current_user_data/current_user_Data.dart';
import 'package:pencilo/data/custom_widget/custom_media_query.dart';
import 'package:pencilo/db_helper/model_name.dart';
import 'package:pencilo/view/home_view/student_home_view/subject_parts_view.dart';
import 'package:rxdart/rxdart.dart';
import '../../../add_methods/add_methods_class.dart';
import '../../../admin_views/add_short_video.dart';
import '../../../controller/home_controller.dart';
import '../../../controller/student_home_view_controller.dart';
import '../../../data/consts/images.dart';
import '../../../local_notification_practice/notifiaction_practice_view.dart';
import 'notification_view.dart';

class StudentHomeView extends StatelessWidget {
  final StudentHomeViewController controller = Get.put(StudentHomeViewController());
  StudentHomeView({super.key});
  final interstitialAdService = InterstitialAdService();
  final rewardedAdService = RewardedAdService();
  final appOpenAdService = AppOpenAdService(); // Optional if you plan to use it here
  // Updated Data structure to hold more random books for each class
  final Map<String, List<String>> classBooksMap = {
    '4th': [
      "Hindi",
    ],
    '5th': [
      "English",
    ],
    '6th': [
      "History",
    ],
    '7th': [
      "Science",
    ],
    '8th': [
      "Maths",
    ],
    '9th': [
      "Geography",
      "History_9th",
      "Science_9th",
      "Political_science_9th",
      "Mathematics_2_9th",
    ],
    '10th': [
      "Marathi",
    ]
  };

  final Map<String, List<String>> classBooksMapName = {
    '4th': [
      "Hindi",
    ],
    '5th': [
      "English",
    ],
    '6th': [
      "History",
    ],
    '7th': [
      "Science",
    ],
    '8th': [
      "Maths",
    ],
    '9th': [
      "Geography",
      "History",
      "Science",
      "Political Science",
      "Mathematics-2",
    ],
    '10th': [
      "Marathi",
    ]
  };

  @override
  Widget build(BuildContext context) {
    requestNotificationPermission();
    return Stack(
      children: [
        Container(
          color: whiteColor,
          child: Padding(
            padding: const EdgeInsets.only(left: 15.0, right: 15),
            child: SingleChildScrollView(
              child: Column(
                children: [
                  SizedBox(height: SizeConfig.screenHeight * 0.08),
                  Row(
                    children: [
                      // Display user's current location
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
                      StreamBuilder<List<QuerySnapshot>>(
                        stream: CombineLatestStream.list([
                          FirebaseFirestore.instance
                              .collection(noticeTableName)
                              .where("division", isEqualTo: CurrentUserData.division)
                              .where("standard", isEqualTo: CurrentUserData.standard)
                              .snapshots(),
                          FirebaseFirestore.instance
                              .collection(homeWorkTableName)
                              .where("division", isEqualTo: CurrentUserData.division)
                              .where("standard", isEqualTo: CurrentUserData.standard)
                              .snapshots(),
                          FirebaseFirestore.instance
                              .collection(sellBookTableName)
                              .where("uid",isEqualTo: CurrentUserData.uid)
                              .snapshots(),
                        ]),
                          builder: (context, snapshot) {
                            if (snapshot.connectionState == ConnectionState.waiting) {
                              return IconButton(
                                onPressed: () {},
                                icon: const Icon(Icons.notifications_rounded, size: 25),
                              );
                            }

                            if (!snapshot.hasData || snapshot.hasError) {
                              return IconButton(
                                onPressed: () {
                                  Get.to(NotificationView());
                                },
                                icon: const Icon(Icons.notifications_rounded, size: 25),
                              );
                            }

                            final noticeSnap = snapshot.data![0];
                            final homeworkSnap = snapshot.data![1];
                            final sellBookSnap = snapshot.data![2];

                            // Calculate unwatched notice count
                            final noticeUnwatchedCount = noticeSnap.docs.where((doc) {
                              final watchedList = List<String>.from(doc['noticeIsWatched'] ?? []);
                              return !watchedList.contains(CurrentUserData.uid);
                            }).length;

                            // Calculate unwatched homework count
                            final homeworkUnwatchedCount = homeworkSnap.docs.where((doc) {
                              final watchedList = List<String>.from(doc['noticeIsWatched'] ?? []);
                              return !watchedList.contains(CurrentUserData.uid);
                            }).length;

                            // Get requestCount from sellBook table
                            int requestCount = 0;
                            for (var doc in sellBookSnap.docs) {
                              requestCount += (doc['requestCount'] ?? 0) as int;
                            }

                            // Total notifications
                            final totalRequest = requestCount + noticeUnwatchedCount + homeworkUnwatchedCount;

                            return GestureDetector(
                              onTap: () {
                                Get.to(NotificationView());
                              },
                              child: Stack(
                                children: [
                                  const Icon(Icons.notifications_rounded, size: 35),
                                  if (totalRequest != 0)
                                    Positioned(
                                      right: 2,
                                      child: CustomCard(
                                        width: 13,
                                        height: 13,
                                        alignment: Alignment.center,
                                        color: const Color(0xff9AC3FF),
                                        borderRadius: 30,
                                        child: CustomText(text: "$totalRequest", size: 8),
                                      ),
                                    ),
                                ],
                              ),
                            );
                          }
                      ),
                    ],
                  ),
                  SizedBox(height: 14),
                  Row(
                    children: [
                      CustomText(
                        text: 'Subjects',
                        color: blackColor,
                        fontFamily: interFontFamily,
                        size: 22,
                        fontWeight: FontWeight.w700,
                      ),
                      SizedBox(width: 14),
                      Obx(() {
                        return CustomCard(
                          height: 28,
                          borderRadius: 9,
                          border: Border.all(color: bgColor, width: 0.3),
                          child: Row(
                            children: [
                              SizedBox(width: 14),
                              // Dropdown button to select class
                              DropdownButton<String>(

                                value: controller.selectedValue.value,
                                icon: Icon(Icons.arrow_drop_down),
                                underline: SizedBox(),
                                dropdownColor: whiteColor,
                                onChanged: (String? newValue) {
                                  if (newValue != null) {
                                    controller.changeValue(newValue);
                                  }
                                },
                                items: <String>[
                                  '4th',
                                  '5th',
                                  '6th',
                                  '7th',
                                  '8th',
                                  '9th',
                                  '10th',
                                ].map<DropdownMenuItem<String>>((String value) {
                                  return DropdownMenuItem<String>(
                                    value: value,
                                    child: CustomText(
                                      text: value,
                                      fontFamily: poppinsFontFamily,
                                      size: 16,
                                      color: bgColor,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  );
                                }).toList(),
                              ),
                            ],
                          ),
                        );
                      }),
                    ],
                  ),
                  SizedBox(height: 10),
                  // Update the list view based on the selected class
                  SizedBox(
                    height: SizeConfig.screenHeight * 0.7,
                    child: Obx(() {
                      // Get books based on selected class
                      List<String> currentClassBooks = classBooksMap[controller.selectedValue.value] ?? [];
                      List<String> booksName = classBooksMapName[controller.selectedValue.value] ?? [];
                      return ListView.builder(
                        itemCount: currentClassBooks.length,
                        padding: EdgeInsets.zero,
                        shrinkWrap: true,
                        physics: BouncingScrollPhysics(),
                        itemBuilder: (context, index) {
                          return Padding(
                            padding: const EdgeInsets.only(bottom: 10.0),
                            child: CustomCard(
                              onTap: () {
                                Future.delayed(Duration.zero, () {
                                  // controller.showInterstitialAd(); // Automatically show on view load
                                  /// controller.showRewardedAd(); // Automatically show on view load
                                });
                                Get.to(SubjectPartsView(
                                  subject: currentClassBooks[index],
                                  colors: controller.curvedCardColors[index],
                                  bgColor: controller.bGCardColors[index],
                                  subjectName: booksName[index],
                                ));
                              },
                              width: double.infinity,
                              height: 147,
                              borderRadius: 12,
                              color: controller.curvedCardColors[index],
                              child: Stack(
                                children: [
                                  Align(
                                    alignment: Alignment.bottomCenter,
                                    child: ClipRRect(
                                      borderRadius: const BorderRadius.only(
                                          bottomLeft: Radius.circular(10),
                                          bottomRight: Radius.circular(10)),
                                      child: Image.asset(
                                        controller.curvedImages[index],
                                        width: double.infinity,
                                        height: 80,
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                  ),
                                  // Subject Name and Parts
                                  Positioned(
                                    left: 12,
                                    top: 5,
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        CustomText(
                                          text: booksName[index],
                                          fontWeight: FontWeight.w600,
                                          size: 18,
                                          color: whiteColor,
                                        ),
                                        CustomText(
                                          text: 'Parts 1-4',
                                          fontWeight: FontWeight.w400,
                                          size: 12,
                                          color: whiteColor,
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      );
                    }),
                  ),
                ],
              ),
            ),
          ),
        ),
        // Positioned(
        //   bottom: 0,
        //     child: GoogleAdWidget(adType: AdType.interstitial)
        // ),
        // Positioned(
        //   bottom: 0,
        //   left: 0,
        //   right: 0,
        //   child: GoogleAddBannerWidget(
        //     adSize: AdSize.banner,
        //   ),
        // ),
      ],
    );
  }
}
