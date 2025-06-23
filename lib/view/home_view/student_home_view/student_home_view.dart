import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:pencilo/data/consts/const_import.dart';
import 'package:pencilo/data/current_user_data/current_user_Data.dart';
import 'package:pencilo/data/custom_widget/app_logo_widget.dart';
import 'package:pencilo/data/custom_widget/custom_media_query.dart';
import 'package:pencilo/db_helper/model_name.dart';
import 'package:pencilo/view/home_view/student_home_view/subject_parts_view.dart';
import 'package:rxdart/rxdart.dart';
import '../../../controller/home_controller.dart';
import '../../../controller/student_home_view_controller.dart';
import 'notification_view.dart';

class StudentHomeView extends StatelessWidget {
  final StudentHomeViewController controller = Get.put(StudentHomeViewController());

  StudentHomeView({super.key});

  @override
  Widget build(BuildContext context) {
    controller.loadBookData();
    requestNotificationPermission();
    return FutureBuilder(
      future: controller.loadBookData(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        return Stack(
          children: [
            Container(
              color: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 15),
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    SizedBox(height: SizeConfig.screenHeight * 0.08),
                    Row(
                      children: [
                        AppLogoWidget(
                          width: 130,
                          height: 90,
                          fit: BoxFit.cover,
                        ),
                        const Spacer(),
                        StreamBuilder<List<QuerySnapshot>>(
                          stream: CombineLatestStream.list([
                            FirebaseFirestore.instance
                                .collection('noticeTable').doc(CurrentUserData.schoolName).collection("students")
                                .where("division", isEqualTo: CurrentUserData.division)
                                .where("standard", isEqualTo: CurrentUserData.standard)
                                .snapshots(),
                            FirebaseFirestore.instance
                                .collection('homeWorkTable').doc(CurrentUserData.schoolName).collection("students")
                                .where("division", isEqualTo: CurrentUserData.division)
                                .where("standard", isEqualTo: CurrentUserData.standard)
                                .snapshots(),
                            FirebaseFirestore.instance
                                .collection(sellBookTableName).doc(CurrentUserData.schoolName).collection("books")
                                .where("uid", isEqualTo: CurrentUserData.uid)
                                .snapshots(),
                          ]),
                          builder: (context, snapshot) {
                            if (!snapshot.hasData) {
                              return CustomCard(
                                onTap: () {},
                                child: const Icon(Icons.notifications_rounded, size: 35),
                              );
                            }

                            final noticeSnap = snapshot.data![0];
                            final homeworkSnap = snapshot.data![1];
                            final sellBookSnap = snapshot.data![2];

                            final noticeUnwatchedCount = noticeSnap.docs.where((doc) {
                              final watchedList = List<String>.from(doc['noticeIsWatched'] ?? []);
                              return !watchedList.contains(CurrentUserData.uid);
                            }).length;

                            final homeworkUnwatchedCount = homeworkSnap.docs.where((doc) {
                              final watchedList = List<String>.from(doc['noticeIsWatched'] ?? []);
                              return !watchedList.contains(CurrentUserData.uid);
                            }).length;

                            int requestCount = 0;
                            for (var doc in sellBookSnap.docs) {
                              requestCount += (doc['requestCount'] ?? 0) as int;
                            }

                            final totalRequest = requestCount + noticeUnwatchedCount + homeworkUnwatchedCount;

                            return GestureDetector(
                              onTap: () => Get.to(NotificationView()),
                              child: Stack(
                                children: [
                                  const Icon(Icons.notifications_rounded, size: 35),
                                  if (totalRequest > 0)
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
                          },
                        ),
                      ],
                    ),
                    const SizedBox(height: 14),
                    Row(
                      children: [
                        const CustomText(
                          text: 'Subjects',
                          color: Colors.black,
                          fontFamily: 'Inter',
                          size: 22,
                          fontWeight: FontWeight.w700,
                        ),
                        const SizedBox(width: 14),
                        Obx(() {
                          return CustomCard(
                            height: 28,
                            borderRadius: 9,
                            border: Border.all(color: blackColor, width: 0.6),
                            child: Row(
                              children: [
                                const SizedBox(width: 14),
                                DropdownButton<String>(
                                  value: controller.selectedValue.value,
                                  icon: const Icon(Icons.arrow_drop_down),
                                  underline: const SizedBox(),
                                  dropdownColor: Colors.white,
                                  onChanged: (String? newValue) {
                                    if (newValue != null) {
                                      controller.changeValue(newValue);
                                    }
                                  },
                                  items: controller.classBooksMap.keys.map((value) => DropdownMenuItem<String>(
                                    value: value,
                                    child: CustomText(
                                      text: value,
                                      fontFamily: 'Poppins',
                                      size: 16,
                                      color: blackColor,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ))
                                      .toList(),
                                ),
                              ],
                            ),
                          );
                        }),
                      ],
                    ),
                    const SizedBox(height: 10),
                    SizedBox(
                      height: SizeConfig.screenHeight * 0.7,
                      child: Obx(() {
                        final currentClassBooks = controller.classBooksMap[controller.selectedValue.value] ?? [];
                        final booksName = controller.classBooksMapName[controller.selectedValue.value] ?? [];
                        return ListView.builder(
                          itemCount: currentClassBooks.length,
                          padding: EdgeInsets.zero,
                          shrinkWrap: true,
                          physics: const BouncingScrollPhysics(),
                          itemBuilder: (context, index) {
                            return Padding(
                              padding: const EdgeInsets.only(bottom: 10.0),
                              child: CustomCard(
                                onTap: () {
                                  Get.to(SubjectPartsView(
                                    subject: currentClassBooks[index],
                                    colors: controller.curvedCardColors[index % controller.curvedCardColors.length],
                                    bgColor: controller.bGCardColors[index % controller.bGCardColors.length],
                                    subjectName: booksName[index],
                                  ));
                                },
                                width: double.infinity,
                                height: 147,
                                borderRadius: 12,
                                color: controller.curvedCardColors[index % controller.curvedCardColors.length],
                                child: Stack(
                                  children: [
                                    Align(
                                      alignment: Alignment.bottomCenter,
                                      child: ClipRRect(
                                        borderRadius: const BorderRadius.only(
                                          bottomLeft: Radius.circular(10),
                                          bottomRight: Radius.circular(10),
                                        ),
                                        child: Image.asset(
                                          controller.curvedImages[index % controller.curvedImages.length],
                                          width: double.infinity,
                                          height: 80,
                                          fit: BoxFit.cover,
                                        ),
                                      ),
                                    ),
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
                                            color: Colors.white,
                                          ),
                                          const CustomText(
                                            text: 'Parts 1-4',
                                            fontWeight: FontWeight.w400,
                                            size: 12,
                                            color: Colors.white,
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
          ],
        );
      },
    );
  }
}
