import 'package:flutter/cupertino.dart';
import 'package:pencilo/controller/home_view_controller.dart';
import 'package:pencilo/data/consts/const_import.dart';
import 'package:pencilo/data/custom_widget/custom_media_query.dart';

import '../../data/consts/images.dart';
import 'answer_view.dart';

class SubjectPartsView extends StatelessWidget {
  final String? subject;

  SubjectPartsView({super.key, this.subject});

  HomeViewController controller = Get.put(HomeViewController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.only(left: 15.0, right: 15),
          child: ListView(
            children: [
              SizedBox(height: SizeConfig.screenHeight * 0.04,),
              Row(
                children: [
                  Column(
                    children: [
                      CustomText(text: 'Aniket Ganesh',
                        color: blackColor,
                        fontFamily: interFontFamily,
                        size: 8,),
                      SizedBox(height: 5,),
                      CustomCard(
                        alignment: Alignment.center,
                        borderRadius: 100,
                        color: Color(0xff57A8B8),
                        width: 41,
                        height: 41,
                        child: CustomText(text: "AG",
                          size: 20,
                          color: blackColor,
                          fontFamily: nixinOneFontFamily,),
                      ),
                    ],
                  ),
                  Spacer(),
                  IconButton(onPressed: () {},
                      icon: Icon(Icons.notifications_rounded, size: 27,))
                ],
              ),
              SizedBox(height: 15,),
              Row(
                children: [
                  CustomText(text: '$subject Answer',
                    color: blackColor,
                    fontWeight: FontWeight.bold,
                    fontFamily: interFontFamily,
                    size: 18,),
                  Spacer(),
                  Obx(() =>
                  controller.isSubjectPartSearching.value == true ? SizedBox(
                    width: 154,
                    height: 36,
                    child: TextField(
                      controller: controller.searchController,
                      focusNode: controller.searchFocusNode,
                      onChanged: (query) {
                        controller.searchQuery.value = query.toLowerCase(); // Convert to lower case for case-insensitive search
                        controller.filterSubjects(); // Call the filter method
                        controller.update();  // Update UI after filtering
                      },
                      decoration: InputDecoration(
                        suffixIcon: GestureDetector(
                          onTap: () {
                            controller.isSubjectPartSearching(false);
                            controller.searchController.clear(); // Clear the search text when the cancel icon is clicked
                            controller.filterSubjects(); // Reset the list
                          },
                          child: Icon(Icons.cancel_outlined),
                        ),
                        contentPadding: EdgeInsets.only(left: 15, right: 10),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(20)),
                        ),
                      ),
                    ),
                  ) : CustomCard(
                    onTap: () {
                      controller.isSubjectPartSearching(true);
                      controller.searchFocusNode.requestFocus();
                    },
                    width: 124,
                    height: 36,
                    borderRadius: 20,
                    color: Color(0xffD9D9D9),
                    child: Row(
                      children: [
                        SizedBox(width: 14),
                        Icon(CupertinoIcons.search, size: 18, color: Color(0xff666666)),
                        SizedBox(width: 10),
                        CustomText(
                          text: 'Search',
                          color: Color(0xff666666),
                          fontFamily: poppinsFontFamily,
                          size: 12,
                          fontWeight: FontWeight.w600,
                        ),
                      ],
                    ),
                  ),
                  )
                ]
              ),
              SizedBox(height: 15,),
              // Part 1
              Row(
                children: [
                  CustomText(text: 'Part 1',
                    color: blackColor,
                    fontWeight: FontWeight.bold,
                    fontFamily: interFontFamily,
                    size: 18,),
                  Spacer(),
                  Row(
                    children: [
                      CustomText(
                        text: 'See All',
                        color: Color(0xff57A8B8),
                        fontFamily: interFontFamily,
                        size: 13,
                        fontWeight: FontWeight.bold,
                      ),
                      Icon(Icons.navigate_next, color: Color(0xff57A8B8),
                        size: 18,
                      )
                    ],
                  ),
                ],
              ),
              SizedBox(height: 10,),
            // ListView to display filtered subjects
              SizedBox(
                height: 160,
                child: Obx(() {
                  return ListView.builder(
                    itemCount: controller.filteredSubjectsParts.length,
                    scrollDirection: Axis.horizontal,
                    padding: EdgeInsets.zero,
                    itemBuilder: (context, index) {
                      String subjectPart = controller.filteredSubjectsParts[index];
                      int indexInList = controller.subjectParts.indexOf(subjectPart); // Get the index of the subject part
                      String subjectName = controller.chapterNames[indexInList]; // Corresponding subject name

                      return Padding(
                        padding: const EdgeInsets.only(right: 10, bottom: 10),
                        child: CustomCard(
                          onTap: () {
                            Get.to(AnswerView(subject: subjectPart)); // Navigate to answer view with the subject part
                          },
                          width: 126,
                          height: 200,
                          color: Colors.grey[200],
                          borderRadius: 12,
                          boxShadow: [
                            BoxShadow(color: grayColor, blurRadius: 5, offset: Offset(0, 3)),
                          ],
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              ClipRRect(
                                borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
                                child: Image.asset(
                                  mathImage,  // Placeholder image
                                  height: 100,
                                  width: double.infinity,
                                  fit: BoxFit.cover,
                                ),
                              ),
                              const SizedBox(height: 8),
                              Padding(
                                padding: const EdgeInsets.only(left: 6.0),
                                child: CustomText(
                                  text: subjectPart,  // Display the subject part (e.g., Part 1)
                                  fontWeight: FontWeight.w600,
                                  size: 14,
                                  color: blackColor,
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(left: 6.0),
                                child: CustomText(
                                  text: subjectName,  // Display the subject name (e.g., Mathematics)
                                  fontWeight: FontWeight.w300,
                                  size: 10,
                                  color: blackColor,
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
              SizedBox(
                width: SizeConfig.screenWidth * 0.8,
                child: Divider(
                  color: Color(0xffe6e2e2),
                ),
              ),
              SizedBox(height: 15,),
              //Part 2
              Row(
                children: [
                  CustomText(text: 'Part 1',
                    color: blackColor,
                    fontWeight: FontWeight.bold,
                    fontFamily: interFontFamily,
                    size: 18,),
                  Spacer(),
                  Row(
                    children: [
                      CustomText(
                        text: 'See All',
                        color: Color(0xff57A8B8),
                        fontFamily: interFontFamily,
                        size: 13,
                        fontWeight: FontWeight.bold,
                      ),
                      Icon(Icons.navigate_next, color: Color(0xff57A8B8),
                        size: 18,
                      )
                    ],
                  ),
                ],
              ),
              SizedBox(height: 10,),
              SizedBox(
                height: 160,
                child: Obx(() {
                  return ListView.builder(
                    itemCount: controller.filteredSubjectsParts.length,
                    scrollDirection: Axis.horizontal,
                    padding: EdgeInsets.zero,
                    itemBuilder: (context, index) {
                      String subjectPart = controller.filteredSubjectsParts[index];
                      int indexInList = controller.subjectParts.indexOf(subjectPart); // Get the index of the subject part
                      String subjectName = controller.chapterNames[indexInList]; // Corresponding subject name

                      return Padding(
                        padding: const EdgeInsets.only(right: 10, bottom: 10),
                        child: CustomCard(
                          onTap: () {
                            Get.to(AnswerView(subject: subjectPart)); // Navigate to answer view with the subject part
                          },
                          width: 126,
                          height: 200,
                          color: Colors.grey[200],
                          borderRadius: 12,
                          boxShadow: [
                            BoxShadow(color: grayColor, blurRadius: 5, offset: Offset(0, 3)),
                          ],
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              ClipRRect(
                                borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
                                child: Image.asset(
                                  mathImage,  // Placeholder image
                                  height: 100,
                                  width: double.infinity,
                                  fit: BoxFit.cover,
                                ),
                              ),
                              const SizedBox(height: 8),
                              Padding(
                                padding: const EdgeInsets.only(left: 6.0),
                                child: CustomText(
                                  text: subjectPart,  // Display the subject part (e.g., Part 1)
                                  fontWeight: FontWeight.w600,
                                  size: 14,
                                  color: blackColor,
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(left: 6.0),
                                child: CustomText(
                                  text: subjectName,  // Display the subject name (e.g., Mathematics)
                                  fontWeight: FontWeight.w300,
                                  size: 10,
                                  color: blackColor,
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
              SizedBox(
                width: SizeConfig.screenWidth * 0.8,
                child: Divider(
                  color: Color(0xffe6e2e2),
                ),
              ),
              SizedBox(height: 15,),
              //Part 3
              Row(
                children: [
                  CustomText(text: 'Part 1',
                    color: blackColor,
                    fontWeight: FontWeight.bold,
                    fontFamily: interFontFamily,
                    size: 18,),
                  Spacer(),
                  Row(
                    children: [
                      CustomText(
                        text: 'See All',
                        color: Color(0xff57A8B8),
                        fontFamily: interFontFamily,
                        size: 13,
                        fontWeight: FontWeight.bold,
                      ),
                      Icon(Icons.navigate_next, color: Color(0xff57A8B8),
                        size: 18,
                      )
                    ],
                  ),
                ],
              ),
              SizedBox(height: 10,),
              SizedBox(
                height: 160,
                child: Obx(() {
                  return ListView.builder(
                    itemCount: controller.filteredSubjectsParts.length,
                    scrollDirection: Axis.horizontal,
                    padding: EdgeInsets.zero,
                    itemBuilder: (context, index) {
                      String subjectPart = controller.filteredSubjectsParts[index];
                      int indexInList = controller.subjectParts.indexOf(subjectPart); // Get the index of the subject part
                      String subjectName = controller.chapterNames[indexInList]; // Corresponding subject name

                      return Padding(
                        padding: const EdgeInsets.only(right: 10, bottom: 10),
                        child: CustomCard(
                          onTap: () {
                            Get.to(AnswerView(subject: subjectPart)); // Navigate to answer view with the subject part
                          },
                          width: 126,
                          height: 200,
                          color: Colors.grey[200],
                          borderRadius: 12,
                          boxShadow: [
                            BoxShadow(color: grayColor, blurRadius: 5, offset: Offset(0, 3)),
                          ],
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              ClipRRect(
                                borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
                                child: Image.asset(
                                  mathImage,  // Placeholder image
                                  height: 100,
                                  width: double.infinity,
                                  fit: BoxFit.cover,
                                ),
                              ),
                              const SizedBox(height: 8),
                              Padding(
                                padding: const EdgeInsets.only(left: 6.0),
                                child: CustomText(
                                  text: subjectPart,  // Display the subject part (e.g., Part 1)
                                  fontWeight: FontWeight.w600,
                                  size: 14,
                                  color: blackColor,
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(left: 6.0),
                                child: CustomText(
                                  text: subjectName,  // Display the subject name (e.g., Mathematics)
                                  fontWeight: FontWeight.w300,
                                  size: 10,
                                  color: blackColor,
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
              SizedBox(
                width: SizeConfig.screenWidth * 0.8,
                child: Divider(
                  color: Color(0xffe6e2e2),
                ),
              ),
              SizedBox(height: 15,)
            ],
          ),
        ),
      ),
    );
  }
}
