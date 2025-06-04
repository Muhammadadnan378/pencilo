import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:pencilo/controller/attendance_controller.dart';
import 'package:pencilo/data/consts/const_import.dart';
import 'package:pencilo/data/custom_widget/custom_media_query.dart';
import 'package:pencilo/db_helper/model_name.dart';
import '../../../../data/current_user_data/current_user_Data.dart';
import '../../../../model/attendance_model.dart';

class AttendanceSubmitView extends StatelessWidget {
  final String division;
  final String standard;

  AttendanceSubmitView(
      {super.key, required this.division, required this.standard});

  final AttendanceController controller = Get.put(
      AttendanceController());

  @override
  Widget build(BuildContext context) {
    debugPrint("startDate: ${controller.startDate.value}");
    controller.showPreviousAfterAttendance();
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Color(0xff9AC3FF),
        title: Padding(
          padding: const EdgeInsets.only(left: 40.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              GestureDetector(
                onTap: () async {
                  DateTime? pickedDate = await showDatePicker(
                    context: context,
                    initialDate: controller.selectedDate.value,
                    firstDate: DateTime(2000), // Fallback to a safe default
                    lastDate: DateTime
                        .now(), // Limits selection to today and before
                  );
                  if (pickedDate != null) {
                    controller.selectedDate.value = pickedDate;
                    controller.showPreviousAfterAttendance();
                  }
                },
                child: Row(
                  children: [
                    Obx(() {
                      controller.selectedDate.value;
                      return CustomText(
                        text: controller.formatDateWithSuffix(
                            controller.selectedDate.value),
                        size: 14,
                        fontWeight: FontWeight.w300,
                        color: blackColor,
                      );
                    }),
                    SizedBox(width: 5,),
                    Icon(Icons.keyboard_arrow_down_sharp, color: blackColor,
                      size: 25,),
                  ],
                ),
              ),
              CustomText(
                text: "Attendance of $standard '$division'",
                size: 16,
                fontWeight: FontWeight.w700,
                color: blackColor,
              ),
            ],
          ),
        ),
      ),
      body: Obx(() {
        String date = DateFormat('dd-MM-yyyy').format(
            controller.selectedDate.value);
        // final String dateKey = "${currentDate.year}-${currentDate.month}-${currentDate.day}";
        return ListView(
          physics: NeverScrollableScrollPhysics(),
          children: [
            StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance
                  .collection(attendanceRecordsTableName)
                  .doc(CurrentUserData.schoolName)
                  .collection("students")
                  .doc(date)
                  .collection("studentsAttendance")
                  .where("division", isEqualTo: division)
                  .where("standard", isEqualTo: standard)
                  .snapshots(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return presentAbsentCards();
                }
                final docs = snapshot.data!.docs;

                controller.attendanceDocs = docs;

                int present = 0;
                int absent = 0;

                for (var doc in docs) {
                  final data = doc.data() as Map<String, dynamic>;
                  if (data['isPresent'] == true) {
                    present++;
                  } else {
                    absent++;
                  }
                }
                controller.presentCount.value = present;
                controller.absentCount.value = absent;

                return presentAbsentCards();
              },
            ),
            SizedBox(height: 15,),
            Center(child: CustomText(text: "Review or edit Attendance",
              size: 16,
              fontWeight: FontWeight.w700,
              color: blackColor,)),
            SizedBox(height: 10,),
            Row(
              children: [
                SizedBox(width: 15),
                GestureDetector(
                  onTapDown: (TapDownDetails details) async {
                    final RenderBox overlay = Overlay
                        .of(context)
                        .context
                        .findRenderObject() as RenderBox;

                    final selected = await showMenu<String>(
                      context: context,
                      position: RelativeRect.fromRect(
                        details.globalPosition & const Size(40, 40),
                        // touch area
                        Offset.zero & overlay.size, // full screen
                      ),
                      items: [
                        PopupMenuItem(
                          value: 'present',
                          child: Row(
                            children: [
                              Icon(Icons.check_circle, color: Colors.green),
                              SizedBox(width: 10),
                              Text("Mark all Present"),
                            ],
                          ),
                        ),
                        PopupMenuItem(
                          value: 'absent',
                          child: Row(
                            children: [
                              Icon(Icons.cancel, color: Colors.red),
                              SizedBox(width: 10),
                              Text("Mark all Absent"),
                            ],
                          ),
                        ),
                      ],
                    );

                    if (selected == 'present') {
                      controller.markAll(true);
                      // Optional: trigger next step
                    } else if (selected == 'absent') {
                      controller.markAll(false);
                      // Optional: trigger next step
                    }
                  },
                  child: CustomCard(
                    borderRadius: 5,
                    color: Color(0xffE8E8E8),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              CustomText(
                                text: "Select All",
                                size: 10,
                                fontWeight: FontWeight.w200,
                                color: blackColor,
                              ),
                              CustomText(
                                text: "Present",
                                size: 16,
                                fontWeight: FontWeight.w700,
                                color: blackColor,
                              ),
                            ],
                          ),
                          SizedBox(width: 5),
                          Icon(Icons.keyboard_arrow_down_outlined),
                        ],
                      ),
                    ),
                  ),
                ),
                SizedBox(width: 10),
                CustomCard(
                  color: Color(0xffE8E8E8),
                  height: 40,
                  width: 30,
                  borderRadius: 5,
                  alignment: Alignment.center,
                  child: Icon(Icons.arrow_forward_ios, size: 15),
                ),
              ],
            ),
            SizedBox(height: 10,),
            Padding(
              padding: const EdgeInsets.only(left: 7.0, right: 7),
              child: CustomCard(
                height: 35,
                borderRadius: 5,
                color: Color(0xff9AC3FF),
                child: Padding(
                  padding: const EdgeInsets.only(left: 20.0, right: 20),
                  child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        CustomText(text: "Name",
                          size: 14,
                          fontWeight: FontWeight.w700,
                          color: blackColor,),
                        CustomText(text: "Roll No.",
                          size: 14,
                          fontWeight: FontWeight.w700,
                          color: blackColor,),
                        CustomText(text: "Status",
                          size: 14,
                          fontWeight: FontWeight.w700,
                          color: blackColor,),
                      ]
                  ),
                ),
              ),
            ),
            SizedBox(height: 10,),
            CustomCard(
              height: SizeConfig.screenHeight * 0.7,
              child: ListView(
                physics: BouncingScrollPhysics(),
                children: [
                  StreamBuilder<QuerySnapshot>(
                      stream: FirebaseFirestore.instance.collection(
                          studentAttendanceTableName).doc(CurrentUserData
                          .schoolName).collection("students").where(
                          "division", isEqualTo: division).where(
                          "standard", isEqualTo: standard).snapshots(),
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

                        controller.studentDocs = studentData;
                        return ListView.builder(
                          itemCount: studentData.length,
                          shrinkWrap: true,
                          physics: NeverScrollableScrollPhysics(),
                          itemBuilder: (context, index) {
                            var student = AttendanceModel.fromMap(
                                studentData[index].data() as Map<String,
                                    dynamic>);
                            debugPrint("Roll No: ${student.rollNo}");
                            return Padding(
                              padding: const EdgeInsets.only(bottom: 10.0),
                              child: Column(
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.only(
                                          left: 10.0, right: 15),
                                      child: Column(
                                        children: [
                                          Row(
                                              children: [
                                                SizedBox(width: 10,),
                                                CustomCard(
                                                    alignment: Alignment
                                                        .centerLeft,
                                                    width: SizeConfig
                                                        .screenWidth * 0.27,
                                                    child: CustomText(
                                                      text: student
                                                          .studentName ?? "",
                                                      size: 14,
                                                      fontWeight: FontWeight
                                                          .w700,
                                                      color: blackColor,
                                                    )
                                                ),
                                                Obx(() {
                                                  controller.beforeIsPresentList;
                                                  return CustomCard(
                                                    alignment: Alignment.center,
                                                    width: SizeConfig.screenWidth * 0.3,
                                                    child: CustomCard(
                                                      borderRadius: 5,
                                                      color: controller.beforeIsPresentList.isNotEmpty && controller.beforeIsPresentList[index] == false
                                                          ? Color(0xffFF9500)
                                                          : Color(0xffD9D9D9),
                                                      child: Padding(
                                                        padding: const EdgeInsets.all(2.0),
                                                        child: CustomText(
                                                          text: student.rollNo ?? "",
                                                          size: 14,
                                                          fontWeight: FontWeight.w700,
                                                          color: blackColor,
                                                        ),
                                                      ),
                                                    ),

                                                  );
                                                }),
                                                Spacer(),
                                                Obx(() {
                                                  controller.isPresentList;
                                                  bool present = controller
                                                      .isPresentList
                                                      .isNotEmpty &&
                                                      controller.isPresentList
                                                          .length ==
                                                          studentData.length
                                                      ? controller
                                                      .isPresentList[index]
                                                      : false;
                                                  Color activeColor = present
                                                      ? Colors.green
                                                      : Color(0xffAC4444);

                                                  return GestureDetector(
                                                    onTap: () async {
                                                      controller
                                                          .isPresentList[index] =
                                                      !present;
                                                    },
                                                    child: AnimatedContainer(
                                                      duration: Duration(
                                                          milliseconds: 300),
                                                      curve: Curves.easeInOut,
                                                      padding: EdgeInsets
                                                          .symmetric(
                                                          horizontal: 4,
                                                          vertical: 4),
                                                      decoration: BoxDecoration(
                                                        color: Colors.white,
                                                        border: Border.all(
                                                            color: activeColor,
                                                            width: 2),
                                                        borderRadius: BorderRadius
                                                            .circular(15),
                                                      ),
                                                      child: Row(
                                                        mainAxisSize: MainAxisSize
                                                            .min,
                                                        children: [
                                                          if (!present)
                                                            AnimatedContainer(
                                                              duration: Duration(
                                                                  milliseconds: 300),
                                                              width: 20,
                                                              height: 20,
                                                              decoration: BoxDecoration(
                                                                color: activeColor,
                                                                shape: BoxShape
                                                                    .circle,
                                                              ),
                                                            ),
                                                          if (!present)
                                                            SizedBox(width: 10),
                                                          AnimatedSwitcher(
                                                            duration: Duration(
                                                                milliseconds: 300),
                                                            child: Text(
                                                              !present
                                                                  ? "Absent"
                                                                  : "Present",
                                                              key: ValueKey(
                                                                  present),
                                                              style: TextStyle(
                                                                color: activeColor,
                                                                fontSize: 12,
                                                                fontWeight: FontWeight
                                                                    .w500,
                                                              ),
                                                            ),
                                                          ),
                                                          if (present)
                                                            SizedBox(width: 10),
                                                          if (present)
                                                            AnimatedContainer(
                                                              duration: Duration(
                                                                  milliseconds: 300),
                                                              width: 20,
                                                              height: 20,
                                                              decoration: BoxDecoration(
                                                                color: activeColor,
                                                                shape: BoxShape
                                                                    .circle,
                                                              ),
                                                            ),
                                                        ],
                                                      ),
                                                    ),
                                                  );
                                                }),
                                              ]
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.only(
                                                left: 20.0, right: 20, top: 2),
                                            child: Divider(),
                                          )
                                        ],
                                      ),
                                    ),
                                  ]
                              ),
                            );
                          },
                        );
                      }
                  ),
                  SizedBox(height: 30,),
                  Padding(
                    padding: const EdgeInsets.only(left: 35.0, right: 35),
                    child: CustomCard(
                      alignment: Alignment.center,
                      borderRadius: 11,
                      width: double.infinity,
                      height: 38,
                      color: blackColor,
                      onTap: () {
                        showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            final div = division; // e.g. "6th"
                            final std = standard; // You can extract this from class string if needed
                            return AlertDialog(
                              title: Text("Add Student"),
                              content: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  TextField(
                                    controller: controller.nameController,
                                    decoration: InputDecoration(
                                        labelText: "Student Name"),
                                  ),
                                  TextField(
                                    controller: controller.rollNoController,
                                    decoration: InputDecoration(
                                        labelText: "Roll Number"),
                                    keyboardType: TextInputType.number,
                                  ),
                                  CustomText(text: "STD: $std, DIV: $div",
                                    color: blackColor,
                                    size: 16,
                                    fontWeight: FontWeight.bold,),
                                ],
                              ),
                              actions: [
                                Obx(() =>
                                controller.isAddMode.value ? TextButton(
                                  onPressed: () async {
                                    controller.addStudent().then((value) {
                                      controller.showPreviousAfterAttendance();
                                    },);
                                  },
                                  child: Text("Add"),
                                )
                                    : const SizedBox(
                                  width: 18,
                                  height: 18,
                                  child: CircularProgressIndicator(
                                      strokeWidth: 2),
                                ))
                              ],
                            );
                          },
                        );
                      },
                      child: CustomText(
                        text: "Add Students",
                        size: 14,
                        fontWeight: FontWeight.w700,
                        fontFamily: GoogleFonts
                            .spaceGrotesk()
                            .fontFamily,
                      ),
                    ),
                  ),
                  SizedBox(height: 10,),
                  Obx(() =>
                  !controller.isSubmitMode.value ? Padding(
                    padding: const EdgeInsets.only(left: 35.0, right: 35),
                    child: CustomCard(
                      alignment: Alignment.center,
                      borderRadius: 11,
                      width: double.infinity,
                      height: 38,
                      color: blackColor,
                      onTap: () {
                        controller.isSubmitMode(true);
                        controller.submitAttendance().then((value) {
                          controller.isSubmitMode(false);
                        },);
                      },
                      child: CustomText(
                        text: "Confirm & Submit attendance",
                        size: 14,
                        fontWeight: FontWeight.w700,
                        fontFamily: GoogleFonts
                            .spaceGrotesk()
                            .fontFamily,
                      ),
                    ),
                  ) : Center(child: CircularProgressIndicator())),
                  SizedBox(height: 100,)
                ],
              ),
            ),
          ],
        );
      },),
    );
  }

  Stack presentAbsentCards() {
    return Stack(
      children: [
        CustomCard(
          color: Color(0xff9AC3FF),
          height: 22,
          width: double.infinity,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CustomCard(
              height: 62,
              width: 62,
              color: Color(0xff528270),
              onTap: () {},
              alignment: Alignment.center,
              borderRadius: 3,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Obx(() =>
                      CustomText(
                        text: "${controller.presentCount.value}",
                        color: whiteColor,
                        size: 18,
                        fontWeight: FontWeight.w800,
                      )),
                  CustomText(
                    text: "Present",
                    color: whiteColor,
                    size: 12,
                    fontWeight: FontWeight.w200,
                  ),
                ],
              ),
            ),
            SizedBox(width: 10),
            CustomCard(
              height: 62,
              width: 62,
              color: Color(0xff9C2E26),
              onTap: () {},
              alignment: Alignment.center,
              borderRadius: 3,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Obx(() =>
                      CustomText(
                        text: "${controller.absentCount.value}",
                        color: whiteColor,
                        size: 18,
                        fontWeight: FontWeight.w800,
                      )),
                  CustomText(
                    text: "Absent",
                    color: whiteColor,
                    size: 12,
                    fontWeight: FontWeight.w200,
                  ),
                ],
              ),
            ),
          ],
        ),
      ],
    );
  }
}
