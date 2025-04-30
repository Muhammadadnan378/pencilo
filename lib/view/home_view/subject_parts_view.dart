import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pencilo/controller/home_view_controller.dart';
import 'package:pencilo/data/consts/const_import.dart';
import 'package:pencilo/data/custom_widget/custom_media_query.dart';

import '../../data/consts/images.dart';
import '../../model/subjects_model.dart';
import 'answer_view.dart';

class SubjectPartsView extends StatelessWidget {
  final String? subject;
  final Color? colors;
  final Color? bgColor;

  SubjectPartsView({super.key, this.subject, this.colors, this.bgColor});

  HomeViewController controller = Get.put(HomeViewController());

  @override
  Widget build(BuildContext context) {
    if (subject == null) {
      return Center(child: Text("No subject selected"));
    }
    return Scaffold(
      appBar: AppBar(),
      body: Center(
        child: GetBuilder<HomeViewController>(builder: (controller) {
          return Padding(
            padding: const EdgeInsets.only(left: 15.0, right: 15),
            child: ListView(
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
                SizedBox(height: 15,),
                CustomText(
                  text: '$subject Answer',
                  color: blackColor,
                  fontWeight: FontWeight.bold,
                  fontFamily: interFontFamily,
                  size: 18,),
                SizedBox(height: 15,),
                StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
                  stream: controller.getSubjects('subjects',subject!.trim()),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return Center(child: CircularProgressIndicator());
                    }

                    if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                      return SizedBox();
                    }

                    final subjects = snapshot.data!.docs;

                    // For simplicity, let's assume you want to show subjectParts for the first subject
                    for(var subjectData in subjects){
                      print(subjectData.data());
                    }

                    final subjectData = subjects.first.data();
                    final dynamic partsRaw = subjectData['subjectParts'];
                    final int subjectParts = partsRaw is String ? int.tryParse(partsRaw) ?? 0 : (partsRaw ?? 0);
                    final mySubjectData = SubjectModel.fromSubject(subjectData);

                    print("Parts ${mySubjectData.subjectParts}");
                    print("Parts $subjectParts");
                    print("Parts $partsRaw");

                    return ListView.builder(
                      shrinkWrap: true,
                      itemCount: subjectParts,
                      physics: NeverScrollableScrollPhysics(),
                      itemBuilder: (context, index) {
                        final partIndex = index + 1;
                        return Padding(
                          padding: const EdgeInsets.only(bottom: 10.0),
                          child: Column(
                            children: [
                              Obx(() {
                                controller.currentIndex.value;
                                return CustomCard(
                                    alignment: Alignment.center,
                                    width: double.infinity,
                                    height: 100,
                                    color: controller.currentIndex.value
                                        == partIndex
                                        ? bgColor : whiteColor,
                                    borderRadius: 10,
                                    border: Border.all(color: blackColor),
                                    boxShadow: [
                                      BoxShadow(
                                          color: blackColor,
                                          spreadRadius: 0.5,
                                          offset: Offset(0, 4)
                                      )
                                    ],
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment
                                          .spaceAround,
                                      children: [
                                        CustomText(text: "Part $partIndex",
                                          size: 30,
                                          color: controller.currentIndex.value
                                          == partIndex ? whiteColor : blackColor,
                                          fontWeight: FontWeight.w500,
                                          fontFamily: GoogleFonts.spaceGrotesk().fontFamily,),
                                        Obx(() {
                                          controller.currentIndex.value;
                                          return InkWell(onTap: () {
                                            if (controller.currentIndex.value != partIndex) {
                                              controller.currentIndex.value = partIndex;
                                            } else {
                                              controller.currentIndex.value = 0;
                                            }
                                          }, child: controller.currentIndex
                                                  .value
                                                  == partIndex
                                                  ? Icon(Icons.remove_circle,
                                                size: 50,
                                                color: whiteColor,
                                              ) : CustomCard(
                                                border: Border.all(color: blackColor),
                                                borderRadius: 50,
                                                child: Icon(
                                                  CupertinoIcons.add,
                                                  size: 50,
                                                  color: blackColor,
                                                  weight: 0.1,
                                                ),
                                              ));
                                        })
                                      ],
                                    )
                                );
                              }),
                              Obx(() =>
                              controller.currentIndex.value == partIndex
                                  ? StreamBuilder(
                                stream: controller.getChapter("Subject part $partIndex", subject!.trim()),
                                builder: (context, snapshot) {
                                  if (snapshot.connectionState == ConnectionState.waiting) {
                                    return Center(child: CircularProgressIndicator());
                                  }

                                  if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                                    return Padding(
                                      padding: const EdgeInsets.symmetric(horizontal: 16),
                                      child: SizedBox(),
                                    );
                                  }

                                  final List<SubjectModel> myData = snapshot.data!.docs
                                      .map((doc) => SubjectModel.fromChapter(doc.data()))
                                      .toList();
                                  // var myData = snapshot.data!.docs;

                                  return Padding(
                                    padding: const EdgeInsets.only(top: 10.0),
                                    child: CustomCard(
                                      color: colors,
                                      borderRadius: 10,
                                      padding: EdgeInsets.all(20),
                                      child: ListView.builder(
                                        shrinkWrap: true,
                                        itemCount: myData.length,
                                        itemBuilder: (context, index) {
                                          var chapterName = myData[index].chapterName;
                                          final chapterIndex = index + 1;
                                          return GestureDetector(
                                            onTap: () {
                                              Get.to(AnswerView(
                                                myData: myData[index],));
                                              },
                                            child: Column(
                                              children: [
                                                Row(
                                                    children: [
                                                      CustomText(
                                                        text: "$chapterIndex",
                                                        size: 20,
                                                        fontWeight: FontWeight.w500,),
                                                      SizedBox(width: 20,),
                                                      CustomText(
                                                        text: "$chapterName",
                                                        size: 14,
                                                        fontWeight: FontWeight.w500,)
                                                    ]
                                                ),
                                                Divider(color: grayColor,
                                                  height: 10,
                                                  thickness: 0.6,)
                                              ],
                                            ),
                                          );
                                        },),
                                    ),
                                  );
                                },) : SizedBox(),)
                            ],
                          ),
                        );

                        //   ;StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
                        //   stream: controller.getChapter("Subject part $partIndex", subject!.trim()),
                        //   builder: (context, snapshot) {
                        //     if (snapshot.connectionState == ConnectionState.waiting) {
                        //       return Center(child: CircularProgressIndicator());
                        //     }
                        //
                        //     if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                        //       return Padding(
                        //         padding: const EdgeInsets.symmetric(horizontal: 16),
                        //         child: Text("No chapters found"),
                        //       );
                        //     }
                        //
                        //     final chapters = snapshot.data!.docs;
                        //
                        //     return ListView.builder(
                        //       shrinkWrap: true,
                        //       physics: NeverScrollableScrollPhysics(),
                        //       itemCount: chapters.length,
                        //       itemBuilder: (context, index) {
                        //         final chapter = chapters[index].data();
                        //
                        //         return ListTile(
                        //           title: Text(chapter['chapterName'] ?? 'No Chapter Name'),
                        //           subtitle: Text(chapter['ans'] ?? 'No Answer'),
                        //         );
                        //       },
                        //     );
                        //   },
                        // );
                        // CustomText(text: "Part ${index + 1} of $subjectName ($subjectId)",color: blackColor,);
                      },
                    );
                  },
                )

                // // Part 1
                // Row(
                //   children: [
                //     CustomText(text: 'Part 1',
                //       color: blackColor,
                //       fontWeight: FontWeight.bold,
                //       fontFamily: interFontFamily,
                //       size: 18,),
                //     Spacer(),
                //     Row(
                //       children: [
                //         CustomText(
                //           text: 'See All',
                //           color: Color(0xff57A8B8),
                //           fontFamily: interFontFamily,
                //           size: 13,
                //           fontWeight: FontWeight.bold,
                //         ),
                //         Icon(Icons.navigate_next, color: Color(0xff57A8B8),
                //           size: 18,
                //         )
                //       ],
                //     ),
                //   ],
                // ),
                // SizedBox(height: 10,),
                // // ListView to display filtered subjects
                // SizedBox(
                //   height: 160,
                //   child: StreamBuilder(
                //       stream: FirebaseFirestore.instance
                //           .collection('part_answer_table')
                //           .snapshots(),
                //       builder: (context, snapshot) {
                //         if (snapshot.connectionState ==
                //             ConnectionState.waiting) {
                //           return Center(child: CircularProgressIndicator());
                //         }
                //
                //         if (!snapshot.hasData || snapshot.data == null) {
                //           return Center(child: Text('No data available'));
                //         }
                //
                //         var data = snapshot.data!.docs;
                //
                //         // Filter the data based on the search query
                //         var filteredData = data.where((doc) {
                //           var chapter = SubjectModel.fromJson(doc.data());
                //           var searchQuery = controller.searchController.text
                //               .toLowerCase();
                //           return chapter.chapterName!.toLowerCase().contains(
                //               searchQuery) ||
                //               chapter.chapterPart!.toLowerCase().contains(searchQuery);
                //         }).toList();
                //
                //         return ListView.builder(
                //           itemCount: filteredData.length,
                //           scrollDirection: Axis.horizontal,
                //           padding: EdgeInsets.zero,
                //           itemBuilder: (context, index) {
                //             // Convert Firestore document to SubjectModel
                //             var chapter = SubjectModel.fromJson(
                //                 filteredData[index].data());
                //
                //             return Padding(
                //               padding: const EdgeInsets.only(
                //                   right: 10, bottom: 10),
                //               child: CustomCard(
                //                 onTap: () {
                //                   Get.to(AnswerView(
                //                     myData: chapter,)); // Navigate to answer view with the subject part
                //                 },
                //                 width: 126,
                //                 height: 200,
                //                 color: Colors.grey[200],
                //                 borderRadius: 12,
                //                 boxShadow: [
                //                   BoxShadow(color: grayColor,
                //                       blurRadius: 5,
                //                       offset: Offset(0, 3)),
                //                 ],
                //                 child: Column(
                //                   crossAxisAlignment: CrossAxisAlignment.start,
                //                   children: [
                //                     ClipRRect(
                //                       borderRadius: const BorderRadius.vertical(
                //                           top: Radius.circular(12)),
                //                       child: Image.asset(
                //                         mathImage, // Placeholder image
                //                         height: 100,
                //                         width: double.infinity,
                //                         fit: BoxFit.cover,
                //                       ),
                //                     ),
                //                     const SizedBox(height: 8),
                //                     Padding(
                //                       padding: const EdgeInsets.only(left: 6.0),
                //                       child: CustomText(
                //                         text: chapter.chapterPart!,
                //                         // Display the subject part (e.g., Part 1)
                //                         fontWeight: FontWeight.w600,
                //                         size: 14,
                //                         color: blackColor,
                //                       ),
                //                     ),
                //                     Padding(
                //                       padding: const EdgeInsets.only(left: 6.0),
                //                       child: CustomText(
                //                         text: chapter.chapterName!,
                //                         // Display the subject name (e.g., Mathematics)
                //                         fontWeight: FontWeight.w300,
                //                         size: 10,
                //                         color: blackColor,
                //                       ),
                //                     ),
                //                   ],
                //                 ),
                //               ),
                //             );
                //           },
                //         );
                //       }
                //   ),
                // ),
                // SizedBox(
                //   width: SizeConfig.screenWidth * 0.8,
                //   child: Divider(
                //     color: Color(0xffe6e2e2),
                //   ),
                // ),
                // SizedBox(height: 15,),
                // //Part 2
                // Row(
                //   children: [
                //     CustomText(text: 'Part 1',
                //       color: blackColor,
                //       fontWeight: FontWeight.bold,
                //       fontFamily: interFontFamily,
                //       size: 18,),
                //     Spacer(),
                //     Row(
                //       children: [
                //         CustomText(
                //           text: 'See All',
                //           color: Color(0xff57A8B8),
                //           fontFamily: interFontFamily,
                //           size: 13,
                //           fontWeight: FontWeight.bold,
                //         ),
                //         Icon(Icons.navigate_next, color: Color(0xff57A8B8),
                //           size: 18,
                //         )
                //       ],
                //     ),
                //   ],
                // ),
                // SizedBox(height: 10,),
                // SizedBox(
                //   height: 160,
                //   child: StreamBuilder(
                //       stream: FirebaseFirestore.instance
                //           .collection('part_answer_table')
                //           .snapshots(),
                //       builder: (context, snapshot) {
                //         if (snapshot.connectionState ==
                //             ConnectionState.waiting) {
                //           return Center(child: CircularProgressIndicator());
                //         }
                //
                //         if (!snapshot.hasData || snapshot.data == null) {
                //           return Center(child: Text('No data available'));
                //         }
                //
                //         var data = snapshot.data!.docs;
                //
                //         // Filter the data based on the search query
                //         var filteredData = data.where((doc) {
                //           var chapter = SubjectModel.fromJson(doc.data());
                //           var searchQuery = controller.searchController.text
                //               .toLowerCase();
                //           return chapter.chapterName!.toLowerCase().contains(
                //               searchQuery) ||
                //               chapter.chapterPart!.toLowerCase().contains(searchQuery);
                //         }).toList();
                //
                //         return ListView.builder(
                //           itemCount: filteredData.length,
                //           scrollDirection: Axis.horizontal,
                //           padding: EdgeInsets.zero,
                //           itemBuilder: (context, index) {
                //             // Convert Firestore document to SubjectModel
                //             var chapter = SubjectModel.fromJson(
                //                 filteredData[index].data());
                //
                //             return Padding(
                //               padding: const EdgeInsets.only(
                //                   right: 10, bottom: 10),
                //               child: CustomCard(
                //                 onTap: () {
                //                   Get.to(AnswerView(
                //                     myData: chapter,)); // Navigate to answer view with the subject part
                //                 },
                //                 width: 126,
                //                 height: 200,
                //                 color: Colors.grey[200],
                //                 borderRadius: 12,
                //                 boxShadow: [
                //                   BoxShadow(color: grayColor,
                //                       blurRadius: 5,
                //                       offset: Offset(0, 3)),
                //                 ],
                //                 child: Column(
                //                   crossAxisAlignment: CrossAxisAlignment.start,
                //                   children: [
                //                     ClipRRect(
                //                       borderRadius: const BorderRadius.vertical(
                //                           top: Radius.circular(12)),
                //                       child: Image.asset(
                //                         mathImage, // Placeholder image
                //                         height: 100,
                //                         width: double.infinity,
                //                         fit: BoxFit.cover,
                //                       ),
                //                     ),
                //                     const SizedBox(height: 8),
                //                     Padding(
                //                       padding: const EdgeInsets.only(left: 6.0),
                //                       child: CustomText(
                //                         text: chapter.chapterPart!,
                //                         // Display the subject part (e.g., Part 1)
                //                         fontWeight: FontWeight.w600,
                //                         size: 14,
                //                         color: blackColor,
                //                       ),
                //                     ),
                //                     Padding(
                //                       padding: const EdgeInsets.only(left: 6.0),
                //                       child: CustomText(
                //                         text: chapter.chapterName!,
                //                         // Display the subject name (e.g., Mathematics)
                //                         fontWeight: FontWeight.w300,
                //                         size: 10,
                //                         color: blackColor,
                //                       ),
                //                     ),
                //                   ],
                //                 ),
                //               ),
                //             );
                //           },
                //         );
                //       }
                //   ),
                // ),
                // SizedBox(
                //   width: SizeConfig.screenWidth * 0.8,
                //   child: Divider(
                //     color: Color(0xffe6e2e2),
                //   ),
                // ),
                // SizedBox(height: 15,),
                // //Part 3
                // Row(
                //   children: [
                //     CustomText(text: 'Part 1',
                //       color: blackColor,
                //       fontWeight: FontWeight.bold,
                //       fontFamily: interFontFamily,
                //       size: 18,),
                //     Spacer(),
                //     Row(
                //       children: [
                //         CustomText(
                //           text: 'See All',
                //           color: Color(0xff57A8B8),
                //           fontFamily: interFontFamily,
                //           size: 13,
                //           fontWeight: FontWeight.bold,
                //         ),
                //         Icon(Icons.navigate_next, color: Color(0xff57A8B8),
                //           size: 18,
                //         )
                //       ],
                //     ),
                //   ],
                // ),
                // SizedBox(height: 10,),
                // SizedBox(
                //   height: 160,
                //   child: StreamBuilder(
                //       stream: FirebaseFirestore.instance
                //           .collection('part_answer_table')
                //           .snapshots(),
                //       builder: (context, snapshot) {
                //         if (snapshot.connectionState ==
                //             ConnectionState.waiting) {
                //           return Center(child: CircularProgressIndicator());
                //         }
                //
                //         if (!snapshot.hasData || snapshot.data == null) {
                //           return Center(child: Text('No data available'));
                //         }
                //
                //         var data = snapshot.data!.docs;
                //
                //         // Filter the data based on the search query
                //         var filteredData = data.where((doc) {
                //           var chapter = SubjectModel.fromJson(doc.data());
                //           var searchQuery = controller.searchController.text
                //               .toLowerCase();
                //           return chapter.chapterName!.toLowerCase().contains(
                //               searchQuery) ||
                //               chapter.chapterPart!.toLowerCase().contains(searchQuery);
                //         }).toList();
                //
                //         return ListView.builder(
                //           itemCount: filteredData.length,
                //           scrollDirection: Axis.horizontal,
                //           padding: EdgeInsets.zero,
                //           itemBuilder: (context, index) {
                //             // Convert Firestore document to SubjectModel
                //             var chapter = SubjectModel.fromJson(
                //                 filteredData[index].data());
                //
                //             return Padding(
                //               padding: const EdgeInsets.only(
                //                   right: 10, bottom: 10),
                //               child: CustomCard(
                //                 onTap: () {
                //                   Get.to(AnswerView(
                //                     myData: chapter,)); // Navigate to answer view with the subject part
                //                 },
                //                 width: 126,
                //                 height: 200,
                //                 color: Colors.grey[200],
                //                 borderRadius: 12,
                //                 boxShadow: [
                //                   BoxShadow(color: grayColor,
                //                       blurRadius: 5,
                //                       offset: Offset(0, 3)),
                //                 ],
                //                 child: Column(
                //                   crossAxisAlignment: CrossAxisAlignment.start,
                //                   children: [
                //                     ClipRRect(
                //                       borderRadius: const BorderRadius.vertical(
                //                           top: Radius.circular(12)),
                //                       child: Image.asset(
                //                         mathImage, // Placeholder image
                //                         height: 100,
                //                         width: double.infinity,
                //                         fit: BoxFit.cover,
                //                       ),
                //                     ),
                //                     const SizedBox(height: 8),
                //                     Padding(
                //                       padding: const EdgeInsets.only(left: 6.0),
                //                       child: CustomText(
                //                         text: chapter.chapterPart!,
                //                         // Display the subject part (e.g., Part 1)
                //                         fontWeight: FontWeight.w600,
                //                         size: 14,
                //                         color: blackColor,
                //                       ),
                //                     ),
                //                     Padding(
                //                       padding: const EdgeInsets.only(left: 6.0),
                //                       child: CustomText(
                //                         text: chapter.chapterName!,
                //                         // Display the subject name (e.g., Mathematics)
                //                         fontWeight: FontWeight.w300,
                //                         size: 10,
                //                         color: blackColor,
                //                       ),
                //                     ),
                //                   ],
                //                 ),
                //               ),
                //             );
                //           },
                //         );
                //       }
                //   ),
                // ),
                // SizedBox(
                //   width: SizeConfig.screenWidth * 0.8,
                //   child: Divider(
                //     color: Color(0xffe6e2e2),
                //   ),
                // ),
                // SizedBox(height: 15,)
              ],
            ),
          );
        }),
      ),
    );
  }
}
