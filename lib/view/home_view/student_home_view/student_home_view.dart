import 'package:flutter/cupertino.dart';
import 'package:pencilo/data/consts/const_import.dart';
import 'package:pencilo/data/custom_widget/custom_media_query.dart';
import 'package:pencilo/view/home_view/student_home_view/subject_parts_view.dart';
import '../../../controller/student_home_view_controller.dart';
import '../../../data/consts/images.dart';
import 'add_subjects.dart';

class StudentHomeView extends StatelessWidget {
  HomeViewController controller = Get.put(HomeViewController());
  StudentHomeView({super.key});

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
      "Geography"
    ],
    '10th': [
      "Hindi",
    ]
  };

  @override
  Widget build(BuildContext context) {
    return Container(
      color: whiteColor,
      child: Padding(
        padding: const EdgeInsets.only(left: 15.0, right: 15),
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
                IconButton(
                  onPressed: () {},
                  icon: Icon(
                    Icons.notifications_rounded,
                    size: 25,
                  ),
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
                          Get.to(SubjectPartsView(
                            subject: currentClassBooks[index],
                            colors: controller.curvedCardColors[index],
                            bgColor: controller.bGCardColors[index],
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
                                    text: currentClassBooks[index],
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
    );
  }
}
