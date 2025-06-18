import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:pencilo/data/custom_widget/custom_text_field.dart';
import 'package:pencilo/view/home_view/teacher_home_cards_view/results_view/result_view.dart';
import '../../../../data/consts/const_import.dart';
import '../../../../data/current_user_data/current_user_Data.dart';
import '../../../../data/custom_widget/custom_media_query.dart';
import '../../../../db_helper/model_name.dart';
import '../../../../model/attendance_model.dart';
import '../../../../model/result_subjects_model.dart';

class SubmitResultView extends StatelessWidget {
  final String resultSubjectId;

  SubmitResultView({
    super.key,
    required this.resultSubjectId,
  });

  final SchoolController controller = Get.find<SchoolController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text('Result of ${controller.selectedStandard.value} ${controller
            .selectedDivision.value}'),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.only(left: 10.0, right: 10),
        physics: BouncingScrollPhysics(),
        child: Column(
          children: [
            Row(
              children: [
                Icon(Icons.info_rounded, color: Colors.grey[300],),
                SizedBox(width: 14,),
                CustomText(
                  text: "Click on student name", color: blackColor, size: 16,)
              ],
            ),
            SizedBox(height: 15,),
            CustomCard(
              height: 35,
              borderRadius: 5,
              color: Color(0xff9AC3FF),
              child: Padding(
                padding: const EdgeInsets.only(left: 5.0, right: 5),
                child: Row(
                    children: [
                      SizedBox(width: 15,),
                      CustomText(text: "Name",
                        size: 14,
                        fontWeight: FontWeight.w700,
                        color: blackColor,),
                      Spacer(),
                      CustomText(text: "Roll No.",
                        size: 14,
                        fontWeight: FontWeight.w700,
                        color: blackColor,),
                      SizedBox(width: 15,),

                    ]
                ),
              ),
            ),
            SizedBox(height: 10,),
            StreamBuilder<QuerySnapshot>(
                stream: FirebaseFirestore.instance.collection(
                    studentAttendanceTableName)
                    .doc(CurrentUserData.schoolName).collection("students")
                    .where(
                    "division", isEqualTo: controller.selectedDivision.value)
                    .where(
                    "standard", isEqualTo: controller.selectedStandard.value)
                    .snapshots(),
                builder: (context, studentSnapshot) {
                  if (studentSnapshot.connectionState ==
                      ConnectionState.waiting) {
                    return Center(child: CircularProgressIndicator(),);
                  }
                  if (studentSnapshot.hasError) {
                    return Center(child: CustomText(
                      text: "Error something went is wrong!!",
                      color: blackColor,));
                  }
                  if (studentSnapshot.data!.docs.isEmpty) {
                    return Center(child: CustomText(
                      text: "No students found!!", color: blackColor,));
                  }
                  var studentData = studentSnapshot.data!.docs;


                  // Get and sort data by rollNo
                  studentData.sort((a, b) {
                    int rollA = int.tryParse(a['rollNo'].toString()) ?? 0;
                    int rollB = int.tryParse(b['rollNo'].toString()) ?? 0;
                    return rollA.compareTo(rollB);
                  });
                  return ListView.builder(
                    shrinkWrap: true,
                    itemCount: studentData.length,
                    physics: NeverScrollableScrollPhysics(),
                    itemBuilder: (context, index) {
                      var student = AttendanceModel.fromMap(
                          studentData[index].data() as Map<String, dynamic>);
                      int rollNo = int.tryParse(student.rollNo.toString()) ?? 0;
                      return Padding(
                        padding: const EdgeInsets.only(left: 5.0, right: 5),
                        child: Column(
                          children: [
                            GestureDetector(
                              onTap: () {
                                controller.marksController.clear();
                                controller.practicalMarksController.clear();
                                controller.getStudentMarks(
                                  subjectId: resultSubjectId,
                                  studentUid: student.studentUid!,
                                  div: controller.selectedDivision.value,
                                  std: controller.selectedStandard.value,
                                  subjectName: controller.getSubjectNameList[0],
                                );
                                _showAddClassDialog(
                                  context,
                                  controller,
                                  rollNo,
                                  student.studentName!,
                                  resultSubjectId,
                                  student.studentUid!,
                                );
                              },
                              child: Row(
                                  children: [
                                    SizedBox(width: 15,),
                                    CustomText(text: "${student.studentName}",
                                      size: 14,
                                      fontWeight: FontWeight.w700,
                                      color: blackColor,),
                                    Spacer(),
                                    CustomCard(
                                      borderRadius: 5,
                                      padding: EdgeInsets.only(left: 10,
                                          right: 10,
                                          top: 5,
                                          bottom: 5),
                                      alignment: Alignment.center,
                                      color: Color(0xffD9D9D9),
                                      child: CustomText(text: "${rollNo <= 9
                                          ? "0${student.rollNo}"
                                          : student.rollNo}",
                                        size: 14,
                                        fontWeight: FontWeight.w700,
                                        color: blackColor,),
                                    ),
                                    SizedBox(width: 15,),

                                  ]
                              ),
                            ),
                            Divider(),
                          ],
                        ),
                      );
                    },
                  );
                }
            )
          ],
        ),
      ),
    );
  }

  void _showAddClassDialog(BuildContext context,
      SchoolController controller,
      int rollNo,
      String studentName,
      String resultSubjectId,
      String studentUid,
      ) {
    int currentIndex = 0;
    showDialog(
      context: context,

      builder: (context) {
        return Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CustomCard(
              width: SizeConfig.screenWidth * 0.95,
              color: whiteColor,
              child: Material(
                color: Colors.transparent,
                child: StatefulBuilder(
                  builder: (context, setState) {
                    final subjects = controller.getSubjectNameList;
                    final marks = controller.getMarksList;
                    final practicals = controller.getPracticalMarksList;

                    final subjectName = subjects.isNotEmpty && currentIndex < subjects.length ? subjects[currentIndex] : '';
                    final markText = marks.isNotEmpty && currentIndex < marks.length ? marks[currentIndex] : '';
                    final practicalText = practicals.isNotEmpty && currentIndex < practicals.length ? practicals[currentIndex] : '';

                    return Padding(
                      padding: EdgeInsets.all(16.0),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(studentName, style: TextStyle(
                              fontSize: 24, fontWeight: FontWeight.bold)),
                          Text('Roll No: ${rollNo <= 9 ? "0$rollNo" : rollNo}',
                              style: TextStyle(
                                  fontSize: 18, color: Colors.grey)),
                          Text('Subject: $subjectName', style: TextStyle(
                              fontSize: 18, color: Colors.grey)),
                          SizedBox(height: 16),

                          CustomText(text: 'Marks out of $markText',
                              size: 16,
                              color: Colors.black),
                          CustomTextFormField(
                            controller: controller.marksController,
                            keyboardType: TextInputType.number,
                            contentPadding: EdgeInsets.only(left: 10),
                          ),
                          SizedBox(height: 16),

                          CustomText(text: 'Practical Marks $practicalText',
                              size: 16,
                              color: Colors.black),
                          SizedBox(
                            height: 50,
                            child: CustomTextFormField(
                              controller: controller.practicalMarksController,
                              keyboardType: TextInputType.number,
                              contentPadding: EdgeInsets.only(left: 10),
                            ),
                          ),
                          SizedBox(height: 16),

                          Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              if (currentIndex > 0)
                                CustomCard(
                                  onTap: () async {
                                    setState(() => currentIndex--); // First update index
                                    final newSubjectName = controller.getSubjectNameList[currentIndex];
                                    await controller.getStudentMarks(
                                      subjectId: resultSubjectId,
                                      studentUid: studentUid,
                                      div: controller.selectedDivision.value,
                                      std: controller.selectedStandard.value,
                                      subjectName: newSubjectName,
                                    );
                                  },
                                  color: Color(0xffFF6060),
                                  height: 35,
                                  borderRadius: 5,
                                  alignment: Alignment.center,
                                  padding: EdgeInsets.only(left: 10, right: 10),
                                  child: CustomText(
                                      text: '< Previous', size: 15),
                                ),
                              SizedBox(width: 10,),
                              Obx(() {
                                controller.isSavedSubjectMarks.value;
                                return controller.isSavedSubjectMarks.value ? Center(child: CircularProgressIndicator()) : CustomCard(
                                  onTap: () async {
                                    controller.isSavedSubjectMarks(true);
                                    final newSubjectName = controller.getSubjectNameList[currentIndex];
                                    controller.submitResult(
                                      studentName: studentName,
                                      subjectName: newSubjectName,
                                      studentUid: studentUid,
                                      div: controller.selectedDivision.value,
                                      std: controller.selectedStandard.value,
                                      rollNo: rollNo.toString(),
                                      totalMarks: markText
                                    );
                                  },
                                  color: blackColor,
                                  height: 35,
                                  borderRadius: 5,
                                  alignment: Alignment.center,
                                  padding: EdgeInsets.only(left: 10, right: 10),
                                  child: CustomText(text: 'Save', size: 15),
                                );
                              }),
                              SizedBox(width: 10,),
                              if (currentIndex < subjects.length - 1)
                                CustomCard(
                                  onTap: () async {
                                    setState(() => currentIndex++); // First update index
                                    final newSubjectName = controller
                                        .getSubjectNameList[currentIndex];
                                    await controller.getStudentMarks(
                                      subjectId: resultSubjectId,
                                      studentUid: studentUid,
                                      div: controller.selectedDivision.value,
                                      std: controller.selectedStandard.value,
                                      subjectName: newSubjectName,
                                    );
                                  },
                                  color: Color(0xff505050),
                                  height: 35,
                                  borderRadius: 5,
                                  alignment: Alignment.center,
                                  padding: EdgeInsets.only(left: 10, right: 10),
                                  child: CustomText(text: 'Next >', size: 15),
                                ),
                            ],
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),
            )
          ],
        );
      },
    );
  }


}
