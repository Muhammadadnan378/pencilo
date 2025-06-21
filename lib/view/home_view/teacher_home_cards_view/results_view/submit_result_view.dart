import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:pencilo/data/custom_widget/custom_dropdown.dart';
import 'package:pencilo/data/custom_widget/custom_text_field.dart';
import 'package:pencilo/view/home_view/teacher_home_cards_view/results_view/result_view.dart';
import '../../../../controller/teacher_home_result_controller.dart';
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

  final ResultController controller = Get.find<ResultController>();

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
            Padding(
              padding: const EdgeInsets.only(left: 10.0, right: 10),
              child: CustomCard(
                height: 35,
                borderRadius: 5,
                color: Color(0xff9AC3FF),
                child: Padding(
                  padding: const EdgeInsets.only(left: 5.0, right: 10),
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
                        padding: const EdgeInsets.only(left: 10.0, right: 25),
                        child: Column(
                          children: [
                            GestureDetector(
                              onTap: () {
                                controller.totalTheoryMarksController.clear();
                                controller.totalPracticalMarksController
                                    .clear();
                                controller.getStudentMarks(
                                  subjectId: resultSubjectId,
                                  studentUid: student.studentUid!,
                                  div: controller.selectedDivision.value,
                                  std: controller.selectedStandard.value,
                                  subjectName: controller.getSubjectNameList[0],
                                );
                                controller.theoryMarks.value =
                                controller.getPracticalMarksList[0];
                                controller.practicalMarks.value =
                                controller.getMarksList[0];
                                controller.selectedSubject.value =
                                controller.getSubjectNameList[0];
                                _showAddClassDialog(
                                  context,
                                  controller,
                                  rollNo,
                                  student.studentName!,
                                  resultSubjectId,
                                  student.studentUid!,
                                  studentData,
                                  index,
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
                                      child: CustomText(
                                        text: "${rollNo <= 9 ? "0${student
                                            .rollNo}" : student.rollNo}",
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
      ResultController controller,
      int rollNo,
      String studentName,
      String resultSubjectId,
      String studentUid,
      List studentData,
      int currentIndex,) {
    controller.getStudentMarks(
      subjectId: resultSubjectId,
      studentUid: studentUid,
      div: controller.selectedDivision.value,
      std: controller.selectedStandard.value,
      subjectName: controller.selectedSubject.value,
    );

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
                    return Padding(
                      padding: EdgeInsets.all(16.0),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              CustomText(text: studentName,
                                size: 24,
                                fontWeight: FontWeight.bold,
                                color: blackColor,),
                              GestureDetector(onTap: () => Get.back(),
                                  child: Icon(Icons.cancel_outlined, size: 30,))
                            ],
                          ),
                          CustomText(text: 'Roll No: ${rollNo <= 9
                              ? "0$rollNo"
                              : rollNo}', size: 18, color: Colors.grey),
                          SizedBox(height: 10),

                          CustomText(text: 'Select Subject',
                              size: 16,
                              color: Colors.black),
                          CustomDropdown(
                            subjects: controller.getSubjectNameList,
                            selectedValue: controller.selectedSubject,
                            dropdownTitle: controller.selectedSubject.value,
                            onSelected: (value) async {
                              controller.selectedSubject.value = value;

                              // Find and print the index of the selected subject
                              int selectedIndex = controller.getSubjectNameList
                                  .indexOf(value);

                              await controller.getStudentMarks(
                                subjectId: resultSubjectId,
                                studentUid: studentUid,
                                div: controller.selectedDivision.value,
                                std: controller.selectedStandard.value,
                                subjectName: controller.selectedSubject.value,
                              );
                              if (controller.getMarksList.isNotEmpty) {
                                controller.theoryMarks.value =
                                controller.getMarksList[selectedIndex];
                              } else {
                                controller.theoryMarks.value = '';
                              }

                              if (controller.getPracticalMarksList.isNotEmpty) {
                                controller.practicalMarks.value =
                                controller.getPracticalMarksList[selectedIndex];
                              } else {
                                controller.practicalMarks.value = '';
                              }
                            },

                          ),
                          Obx(() {
                            return controller.theoryMarks.value.isNotEmpty
                                ? CustomText(
                                text: 'Theory Marks out of ${controller.theoryMarks.value}',
                                size: 16,
                                color: Colors.black)
                                : SizedBox();
                          }),
                          CustomTextFormField(
                            controller: controller.totalTheoryMarksController,
                            keyboardType: TextInputType.number,
                            contentPadding: EdgeInsets.only(left: 10),
                          ),
                          SizedBox(height: 10),
                          Obx(() {
                            return controller.practicalMarks.value.isNotEmpty
                                ? CustomText(
                                text: 'Practical Marks ${controller
                                    .practicalMarks.value}',
                                size: 16,
                                color: Colors.black)
                                : SizedBox();
                          }),
                          SizedBox(
                            height: 50,
                            child: CustomTextFormField(
                              controller: controller
                                  .totalPracticalMarksController,
                              keyboardType: TextInputType.number,
                              contentPadding: EdgeInsets.only(left: 10),
                            ),
                          ),
                          SizedBox(height: 10),
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              if (currentIndex > 0)
                                CustomCard(
                                  onTap: () async {
                                    Navigator.pop(context);
                                    final prev = AttendanceModel.fromMap(
                                        studentData[currentIndex - 1]
                                            .data() as Map<String, dynamic>);
                                    _showAddClassDialog(
                                        context,
                                        controller,
                                        int.tryParse(prev.rollNo ?? '0') ?? 0,
                                        prev.studentName ?? '',
                                        resultSubjectId,
                                        prev.studentUid ?? '',
                                        studentData,
                                        currentIndex - 1);
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
                              if (currentIndex == studentData.length - 1)
                              Obx(() {
                                return controller.isSavedSubjectMarks.value
                                    ? Center(child: CircularProgressIndicator())
                                    : CustomCard(
                                  onTap: () async {
                                    if (controller.totalTheoryMarksController.text.isEmpty) {
                                      Get.snackbar("Notice", "Theory marks cannot be empty", backgroundColor: Colors.red, colorText: Colors.white);
                                      return;
                                    }
                                    int theory = int.tryParse(controller.totalTheoryMarksController.text) ?? 0;
                                    int practical = int.tryParse(controller.totalPracticalMarksController.text) ?? 0;
                                    if(theory > int.tryParse(controller.theoryMarks.value)! || practical > int.tryParse(controller.practicalMarks.value)!){
                                      Get.snackbar("Error", "The Marks cannot be greater than out of Marks",backgroundColor: Colors.red, colorText: Colors.white);
                                      controller.isSavedSubjectMarks(false);
                                      return;
                                    }
                                    controller.isSavedSubjectMarks(true);
                                    await controller.submitResult(
                                      studentName: studentName,
                                      subjectName: controller.selectedSubject.value,
                                      studentUid: studentUid,
                                      div: controller.selectedDivision.value,
                                      std: controller.selectedStandard.value,
                                      rollNo: rollNo.toString(),
                                      totalSubjectMarks: int.tryParse(controller.theoryMarks.value)! + int.tryParse(controller.practicalMarks.value)!,
                                    );
                                    controller.isSavedSubjectMarks(false);
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
                              if (currentIndex < studentData.length - 1)
                                Obx(() {
                                  return controller.isSavedSubjectMarks.value
                                      ? Center(child: CircularProgressIndicator())
                                      :  CustomCard(
                                    onTap: () async {
                                      if (controller.totalTheoryMarksController.text.isEmpty) {
                                        Get.snackbar("Notice", "Theory marks cannot be empty", backgroundColor: Colors.red, colorText: Colors.white);
                                        return;
                                      }
                                      if (currentIndex < studentData.length - 1) {
                                        int theory = int.tryParse(controller.totalTheoryMarksController.text) ?? 0;
                                        int practical = int.tryParse(controller.totalPracticalMarksController.text) ?? 0;
                                        if (theory > int.tryParse(controller.theoryMarks.value)! || practical > int.tryParse(controller.practicalMarks.value)!) {
                                          Get.snackbar("Error", "The Marks cannot be greater than out of Marks", backgroundColor: Colors.red, colorText: Colors.white);
                                          controller.isSavedSubjectMarks(false);
                                          return;
                                        }
                                        controller.isSavedSubjectMarks(true);
                                        await controller.submitResult(
                                          studentName: studentName,
                                          subjectName: controller.selectedSubject.value,
                                          studentUid: studentUid,
                                          div: controller.selectedDivision.value,
                                          std: controller.selectedStandard.value,
                                          rollNo: rollNo.toString(),
                                          totalSubjectMarks: int.tryParse(controller.theoryMarks.value)! + int.tryParse(controller.practicalMarks.value)!,
                                        );
                                        controller.isSavedSubjectMarks(false);
                                        Navigator.pop(context);
                                        final next = AttendanceModel.fromMap(studentData[currentIndex + 1].data() as Map<String, dynamic>);
                                        _showAddClassDialog(
                                          context,
                                          controller,
                                          int.tryParse(next.rollNo ?? '0') ?? 0,
                                          next.studentName ?? '',
                                          resultSubjectId,
                                          next.studentUid ?? '',
                                          studentData,
                                          currentIndex + 1,
                                        );
                                      }
                                      // else do nothing
                                    },
                                    color: Color(0xff505050),
                                    height: 35,
                                    borderRadius: 5,
                                    alignment: Alignment.center,
                                    padding: EdgeInsets.only(
                                        left: 10, right: 10),
                                    child: CustomText(text: 'Next >', size: 15),
                                  );
                                }),
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
