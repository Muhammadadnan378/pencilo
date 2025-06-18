import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:pencilo/data/current_user_data/current_user_Data.dart';
import 'package:pencilo/data/custom_widget/custom_dropdown.dart';
import 'package:pencilo/data/custom_widget/custom_media_query.dart';
import 'package:pencilo/db_helper/model_name.dart';
import 'package:rxdart/rxdart.dart';

import '../../../controller/profile_controller.dart';
import '../../../data/consts/const_import.dart';
import '../../../model/result_subjects_model.dart';

class ProfileExamResultView extends StatefulWidget {
  ProfileExamResultView({super.key});

  @override
  State<ProfileExamResultView> createState() => _ProfileExamResultViewState();
}

class _ProfileExamResultViewState extends State<ProfileExamResultView> {
  final ProfileController controller = Get.put(ProfileController());

  Future<void> fetchSchoolData() async {
    debugPrint("fetchSchoolData");
    DocumentSnapshot schoolData = await FirebaseFirestore.instance
        .collection(schoolTableName)
        .doc(CurrentUserData.schoolName)
        .get();

    if (schoolData.exists) {
      // get school logo
      controller.schoolLogoImage.value = schoolData['schoolLogo'];
      controller.schoolWebLink.value = schoolData['websiteLink'];
      controller.schoolContactNumber.value = schoolData['contactNumber'];
      controller.schoolAddress.value = schoolData['schoolAddress'];
      controller.schoolName.value = schoolData['schoolName'];
      controller.schoolClassTeacherSignatureImage.value =
      schoolData['classTeacherSignature'];
      controller.schoolPrincipleSignatureImage.value =
      schoolData['principalSignature'];
    } else {
      controller.clearAllFields();
      debugPrint("no school logo");
    }

    QuerySnapshot subjectsData = await FirebaseFirestore.instance
        .collection(resultSubjectsTableName)
        .doc(CurrentUserData.schoolName)
        .collection(controller.selectedYear.value).where(
        "standard", isEqualTo: controller.selectedStandard.value).where(
        "division", isEqualTo: controller.selectedDivision.value)
        .get();

    if (subjectsData.docs.isNotEmpty) {
      String subjectId = subjectsData.docs[0].id;
      QuerySnapshot studentData = await FirebaseFirestore.instance
          .collection(resultSubjectsTableName)
          .doc(CurrentUserData.schoolName)
          .collection(controller.selectedYear.value)
          .doc(subjectId).collection("studentsSubject")
          .doc(
          "${controller.selectedStandard.value}${controller.selectedDivision
              .value}")
          .collection("studentResults")
          .where("studentUid", isEqualTo: CurrentUserData.uid).get();

      if (studentData.docs.isNotEmpty) {
        controller.studentName.value = studentData.docs[0]['studentName'];
        controller.studentRollNo.value = studentData.docs[0]['rollNo'];
        controller.studentDivStd.value =
        "${studentData.docs[0]['standard']} ${studentData.docs[0]['division']}";

        controller.resultDoc.value = studentData;
        for (var item in studentData.docs) {
          var resultData = ResultModel.fromMap(
              item.data() as Map<String, dynamic>);
          if (resultData.term == "Midterm") {
            debugPrint("Mid Term");
          } else {
            debugPrint("Final Term");
          }
        }
      } else {
        debugPrint("no student data");
        debugPrint("CurrentUserData.uid: ${CurrentUserData.uid}");
        controller.studentName.value = "";
        controller.studentRollNo.value = "";
        controller.studentDivStd.value = "";
        controller.resultDoc.value = null;
      }
    } else {
      controller.studentName.value = "";
      controller.studentRollNo.value = "";
      controller.studentDivStd.value = "";
      controller.resultDoc.value = null;
    }
  }

  @override
  Widget build(BuildContext context) {
    fetchSchoolData();
    return Scaffold(
      appBar: AppBar(),
      body: SingleChildScrollView(
        physics: BouncingScrollPhysics(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 20.0, right: 20),
              child: Obx(() {
                controller.selectedYear.value;
                return CustomDropdown(
                  subjects: controller.yearsList, // <- fixed here
                  selectedValue: controller.selectedYear,
                  dropdownTitle: "Select Year",
                  onSelected: (value) async {
                    controller.selectedYear.value = value;
                    await fetchSchoolData();
                  },
                );
              }),
            ),


            Padding(
              padding: const EdgeInsets.only(left: 20.0, right: 20),
              child: Row(
                children: [
                  Obx(() {
                    controller.selectedStandard.value;
                    return Expanded(
                      child: CustomDropdown(
                        subjects: controller.standards,
                        selectedValue: controller.selectedStandard,
                        dropdownTitle: "Select Standard",
                        onSelected: (value) async {
                          controller.selectedStandard.value = value;
                          await fetchSchoolData();
                        },
                      ),
                    );
                  }),
                  SizedBox(width: 15,),
                  Obx(() {
                    controller.selectedDivision.value;
                    return Expanded(
                      child: CustomDropdown(
                        subjects: controller.divisions,
                        selectedValue: controller.selectedDivision,
                        dropdownTitle: "Select Division",
                        onSelected: (value) async {
                          controller.selectedDivision.value = value;
                          await fetchSchoolData();
                        },
                      ),
                    );
                  }),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 10.0, right: 10, top: 20),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [

                  Obx(() {
                    return controller.schoolLogoImage.value.isNotEmpty
                        ? CircleAvatar(
                      radius: 30,
                      backgroundImage: NetworkImage(
                          controller.schoolLogoImage.value),
                    ) : controller.schoolLogoImage.value.isNotEmpty
                        ? CircleAvatar(
                      radius: 30,
                      backgroundColor: Colors.grey.shade300,
                      child: CustomText(
                        text: controller.schoolName.value.isNotEmpty
                            ? controller.schoolName.value[0]
                            : "",
                        size: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    )
                        : SizedBox();
                  }),
                  SizedBox(width: 12),
                  Obx(() {
                    controller.schoolWebLink.value;
                    return controller.schoolName.value.isNotEmpty ? Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          CustomText(
                            text: controller.schoolName.value,
                            color: blackColor,
                            fontWeight: FontWeight.bold,
                            size: 17,
                          ),
                          SizedBox(height: 4),
                          CustomText(
                            text: controller.schoolWebLink.value,
                            color: Colors.blue,
                            size: 14,
                          ),
                          CustomText(
                            text: controller.schoolContactNumber.value,
                            color: Colors.grey.shade700,
                            size: 14,
                          ),
                          SizedBox(height: 8),
                          CustomText(
                            text: "Address: ${controller.schoolAddress.value}",
                            color: Colors.black87,
                            size: 13,
                            maxLines: 2,
                          ),
                        ],
                      ),
                    ) : SizedBox();
                  }),
                ],
              ),
            ),
            SizedBox(height: 20,),

            Padding(
              padding: const EdgeInsets.only(left: 12.0, right: 12),
              child: Obx(() {
                controller.studentName.value;
                controller.studentRollNo.value;
                controller.studentDivStd.value;
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    if(controller.studentName.value.isNotEmpty)
                      CustomText(
                        text: "Name: ${controller.studentName.value}",
                        color: Colors.grey.shade700,
                        fontWeight: FontWeight.w500,
                        size: 15,
                      ),
                    if(controller.studentDivStd.value.isNotEmpty)
                      CustomText(
                        text: "Class: ${controller.studentDivStd.value}",
                        color: Colors.grey.shade700,
                        fontWeight: FontWeight.w500,
                        size: 15,
                      ),
                    if(controller.studentRollNo.value.isNotEmpty)
                      CustomText(
                        text: "Roll No: ${controller.studentRollNo.value}",
                        color: Colors.grey.shade700,
                        fontWeight: FontWeight.w500,
                        size: 15,
                      ),
                  ],
                );
              }),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 10.0, right: 10),
              child: Obx(() {
                if (controller.resultDoc.value == null) return const SizedBox();

                final docs = controller.resultDoc.value!.docs;

                int midObtained = 0;
                int midMax = 0;

                int finalObtained = 0;
                int finalMax = 0;

                final midtermRows = docs
                    .map((doc) =>
                    ResultModel.fromMap(doc.data() as Map<String, dynamic>))
                    .where((model) => model.term == "Midterm")
                    .map((model) {
                  final int theory = int.tryParse(model.subjectTotalMarks ??
                      "0") ?? 0;
                  final int practical = int.tryParse(model
                      .subjectPracticalMarks ?? "0") ?? 0;
                  final int max = int.tryParse(model.totalMarks ?? "0") ?? 0;
                  final int obtained = theory + practical;

                  midObtained += obtained;
                  midMax += max;

                  final grade = controller.getGradeFromMarks(
                      obtained: obtained, max: max);

                  return TableRow(children: [
                    tableCell(model.subjectName),
                    tableCell(model.subjectTotalMarks),
                    tableCell(model.subjectPracticalMarks),
                    tableCell("$obtained"),
                    tableCell(model.totalMarks),
                    tableCell(grade),
                  ]);
                }).toList();

                final finalRows = docs
                    .map((doc) =>
                    ResultModel.fromMap(doc.data() as Map<String, dynamic>))
                    .where((model) => model.term == "Final Term")
                    .map((model) {
                  final int theory = int.tryParse(model.subjectTotalMarks ??
                      "0") ?? 0;
                  final int practical = int.tryParse(model
                      .subjectPracticalMarks ?? "0") ?? 0;
                  final int max = int.tryParse(model.totalMarks ?? "0") ?? 0;
                  final int obtained = theory + practical;

                  finalObtained += obtained;
                  finalMax += max;

                  final grade = controller.getGradeFromMarks(
                      obtained: obtained, max: max);

                  return TableRow(children: [
                    tableCell(model.subjectName),
                    tableCell(model.subjectTotalMarks),
                    tableCell(model.subjectPracticalMarks),
                    tableCell("$obtained"),
                    tableCell(model.totalMarks),
                    tableCell(grade),
                  ]);
                }).toList();

                final midPercent = midMax == 0 ? 0.0 : (midObtained / midMax) *
                    100;
                final finalPercent = finalMax == 0 ? 0.0 : (finalObtained /
                    finalMax) * 100;

                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 10),
                    const CustomText(
                      text: "Midterm Results",
                      size: 16,
                      color: blackColor,
                      fontWeight: FontWeight.bold,
                    ),
                    const SizedBox(height: 5),
                    Table(
                      border: TableBorder.all(color: Colors.black, width: 1.0),
                      columnWidths: const {
                        0: FlexColumnWidth(2),
                        1: FlexColumnWidth(2),
                        2: FlexColumnWidth(2),
                        3: FlexColumnWidth(2),
                        4: FlexColumnWidth(2),
                        5: FlexColumnWidth(2),
                      },
                      children: [
                        TableRow(children: [
                          tableHeader('Subjects'),
                          tableHeader('Theory'),
                          tableHeader('Practical'),
                          tableHeader('Total'),
                          tableHeader('Max'),
                          tableHeader('Grade'),
                        ]),
                        ...midtermRows,
                      ],
                    ),
                    const SizedBox(height: 10),
                    CustomCard(
                      padding: const EdgeInsets.all(5),
                      border: Border.all(color: blackColor, width: 0.5,),
                      width: SizeConfig.screenWidth,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          CustomText(
                            text: "Total Marks: $midObtained / $midMax",
                            size: 14,
                            color: blackColor,
                            fontWeight: FontWeight.w600,
                          ),
                          CustomText(
                            text: "Percentage: ${midPercent.toStringAsFixed(
                                2)}%",
                            size: 14,
                            color: blackColor,
                            fontWeight: FontWeight.w600,
                          ),
                          CustomText(
                            text: "Overall Grade: ${controller
                                .getGradeFromMarks(
                                obtained: midObtained, max: midMax)}",
                            size: 14,
                            color: blackColor,
                            fontWeight: FontWeight.w600,
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 20),
                    const CustomText(
                      text: "Final Results",
                      size: 16,
                      color: blackColor,
                      fontWeight: FontWeight.bold,
                    ),
                    const SizedBox(height: 5),
                    Table(
                      border: TableBorder.all(color: Colors.black, width: 1.0),
                      columnWidths: const {
                        0: FlexColumnWidth(2),
                        1: FlexColumnWidth(2),
                        2: FlexColumnWidth(2),
                        3: FlexColumnWidth(2),
                        4: FlexColumnWidth(2),
                        5: FlexColumnWidth(2),
                      },
                      children: [
                        TableRow(children: [
                          tableHeader('Subjects'),
                          tableHeader('Theory'),
                          tableHeader('Practical'),
                          tableHeader('Total'),
                          tableHeader('Max'),
                          tableHeader('Grade'),
                        ]),
                        ...finalRows,
                      ],
                    ),
                    const SizedBox(height: 10),
                    CustomCard(
                      padding: const EdgeInsets.all(5),
                      border: Border.all(color: blackColor, width: 0.5,),
                      width: SizeConfig.screenWidth,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          CustomText(
                            text: "Total Marks: $finalObtained / $finalMax",
                            size: 14,
                            color: blackColor,
                            fontWeight: FontWeight.w600,
                          ),
                          CustomText(
                            text: "Percentage: ${finalPercent.toStringAsFixed(
                                2)}%",
                            size: 14,
                            color: blackColor,
                            fontWeight: FontWeight.w600,
                          ),
                          CustomText(
                            text: "Overall Grade: ${controller
                                .getGradeFromMarks(
                                obtained: midObtained, max: finalMax)}",
                            size: 14,
                            color: blackColor,
                            fontWeight: FontWeight.w600,
                          ),
                        ],
                      ),
                    ),
                  ],
                );
              }),
            ),
            SizedBox(height: 25,),
            Obx(() {
              controller.studentDivStd.value;
              return controller.studentDivStd.value.isNotEmpty ? Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    children: [
                      if(controller.schoolClassTeacherSignatureImage.isNotEmpty)
                        Image.network(
                          "${controller.schoolClassTeacherSignatureImage}",
                          width: 120,
                          height: 120,
                        ),
                      SizedBox(height: 5,),
                      SizedBox(width: 100, child: Divider(color: blackColor,)),
                      CustomText(text: "Class Teacher",
                        color: blackColor,
                        size: 14,
                        fontWeight: FontWeight.w600,)
                    ],
                  ),

                  Column(
                    children: [
                      if(controller.schoolClassTeacherSignatureImage.isNotEmpty)
                        Image.network(
                          "${controller.schoolPrincipleSignatureImage}",
                          width: 120,
                          height: 120,
                        ),
                      SizedBox(height: 5,),
                      SizedBox(width: 100, child: Divider(color: blackColor,)),
                      CustomText(text: "Principle",
                        color: blackColor,
                        size: 14,
                        fontWeight: FontWeight.w600,)
                    ],
                  ),
                ],
              ) : SizedBox();
            }),
            SizedBox(height: SizeConfig.screenHeight * 0.06,)
          ],
        ),
      ),
    );
  }

  Widget tableHeader(String text) {
    return Padding(
      padding: const EdgeInsets.only(top: 4.0, bottom: 4, left: 3, right: 3),
      child: CustomText(
        text: text,
        fontWeight: FontWeight.bold,
        size: 13,
        maxLines: 1,
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
        maxLines: 1,
      ),
    );
  }
}

// Padding(
// padding: const EdgeInsets.all(16.0),
// child: SingleChildScrollView(
// child: Column(
// crossAxisAlignment: CrossAxisAlignment.start,
// children: [
// Card(
// elevation: 4,
// shape: RoundedRectangleBorder(
// borderRadius: BorderRadius.circular(12),
// ),
// child: Padding(
// padding: const EdgeInsets.all(16.0),
// child: Column(
// crossAxisAlignment: CrossAxisAlignment.start,
// children: [
// Row(
// mainAxisAlignment: MainAxisAlignment.spaceBetween,
// children: [
// const Text(
// "Overall Performance",
// style: TextStyle(
// fontSize: 16,
// fontWeight: FontWeight.bold,
// ),
// ),
// Container(
// padding: const EdgeInsets.symmetric(
// horizontal: 12, vertical: 6),
// decoration: BoxDecoration(
// color: controller.getGradeColor(controller.results['grade']),
// borderRadius: BorderRadius.circular(20),
// ),
// child: Text(
// "Grade: ${controller.results['grade']}",
// style: const TextStyle(
// color: Colors.white,
// fontWeight: FontWeight.bold,
// ),
// ),
// ),
// ],
// ),
// const SizedBox(height: 16),
// LinearProgressIndicator(
// value: double.parse(controller.results['percentage']) / 100,
// backgroundColor: Colors.grey[300],
// minHeight: 10,
// borderRadius: BorderRadius.circular(5),
// ),
// const SizedBox(height: 8),
// Text(
// "Percentage: ${controller.results['percentage']}%",
// style: const TextStyle(
// fontWeight: FontWeight.bold,
// ),
// ),
// const SizedBox(height: 4),
// Text(
// "Total Marks: ${controller.results['totalMarks']} / ${controller.results['maxMarks']}",
// ),
// ],
// ),
// ),
// ),
// const SizedBox(height: 16),
// const Text(
// "Subject Breakdown",
// style: TextStyle(
// fontSize: 18,
// fontWeight: FontWeight.bold,
// ),
// ),
// const SizedBox(height: 8),
// ListView.builder(
// shrinkWrap: true,
// physics: const NeverScrollableScrollPhysics(),
// itemCount: controller.subjectMarks.length,
// itemBuilder: (context, index) {
// final subject = controller.subjectMarks[index];
// final percentage = (subject['totalMarks'] / subject['maxMarks']) * 100;
//
// return Card(
// margin: const EdgeInsets.symmetric(vertical: 8),
// elevation: 2,
// shape: RoundedRectangleBorder(
// borderRadius: BorderRadius.circular(12),
// ),
// child: Padding(
// padding: const EdgeInsets.all(12.0),
// child: Column(
// crossAxisAlignment: CrossAxisAlignment.start,
// children: [
// Row(
// children: [
// CircleAvatar(
// backgroundColor:
// subject['color'].withOpacity(0.2),
// child: Icon(subject['icon'],
// color: subject['color']),
// ),
// const SizedBox(width: 12),
// Expanded(
// child: Column(
// crossAxisAlignment: CrossAxisAlignment.start,
// children: [
// Text(
// subject['subject'],
// style: const TextStyle(
// fontWeight: FontWeight.bold,
// fontSize: 16,
// ),
// ),
// const SizedBox(height: 4),
// LinearProgressIndicator(
// value: percentage / 100,
// backgroundColor: Colors.grey[300],
// minHeight: 6,
// borderRadius: BorderRadius.circular(3),
// ),
// ],
// ),
// ),
// const SizedBox(width: 12),
// Container(
// padding: const EdgeInsets.symmetric(
// horizontal: 10, vertical: 4),
// decoration: BoxDecoration(
// color: controller.getGradeColor(subject['grade']),
// borderRadius: BorderRadius.circular(20),
// ),
// child: Text(
// subject['grade'],
// style: const TextStyle(
// color: Colors.white,
// fontWeight: FontWeight.bold,
// ),
// ),
// ),
// ],
// ),
// const SizedBox(height: 12),
// Row(
// mainAxisAlignment: MainAxisAlignment.spaceAround,
// children: [
// _buildMarkItem("Theory", subject['theoryMarks']),
// _buildMarkItem(
// "Practical", subject['practicalMarks']),
// _buildMarkItem("Total", subject['totalMarks'],
// isTotal: true),
// _buildMarkItem("Max", subject['maxMarks']),
// ],
// ),
// ],
// ),
// ),
// );
// },
// ),
// ],
// ),
// ),
// )
// Widget _buildMarkItem(String label, int value, {bool isTotal = false}) {
//   return Column(
//     children: [
//       Text(
//         label,
//         style: TextStyle(
//           fontSize: 12,
//           color: Colors.grey[600],
//         ),
//       ),
//       const SizedBox(height: 4),
//       Text(
//         value.toString(),
//         style: TextStyle(
//           fontWeight: isTotal ? FontWeight.bold : FontWeight.normal,
//           fontSize: isTotal ? 16 : 14,
//         ),
//       ),
//     ],
//   );
// }

