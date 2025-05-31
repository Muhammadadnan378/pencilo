import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:pencilo/controller/attendance_controller.dart';
import 'package:pencilo/data/consts/const_import.dart';
import 'package:pencilo/data/custom_widget/custom_media_query.dart';
import 'package:pencilo/db_helper/model_name.dart';

class AttendanceSubmitView extends StatelessWidget {
  final String classes;
  final String subjects;

  AttendanceSubmitView(
      {super.key, required this.classes, required this.subjects});

  final AttendanceController controller = Get.put(AttendanceController());

  @override
  Widget build(BuildContext context) {
    // controller.storeAttendanceManually();
    debugPrint("attendanceDocs: ${controller.attendanceDocs.length}");
    controller.std = classes;
    controller.div = subjects;
    debugPrint("${controller.std} ${controller.div}");
    controller.createNewAttendance();
    debugPrint("startDate: ${controller.startDate.value}");
    debugPrint("endDate: ${controller.endDate.value}");
    return Obx(() {
      final DateTime currentDate = controller.selectedDate.value;
      final String dateLabel = DateFormat('d MMMM y').format(currentDate);
      final String dateKey = "${currentDate.year}-${currentDate.month}-${currentDate.day}";
      // Helper function to format the date string
      String _formatDate(String date) {
        final parts = date.split('-');
        if (parts.length == 3) {
          final year = parts[0];
          final month = parts[1].padLeft(2, '0'); // Pad month
          final day = parts[2].padLeft(2, '0'); // Pad day
          return '$year-$month-$day';
        }
        return date; // Return original if format is unexpected
      }
      debugPrint("dateKey: $dateKey");
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
                    debugPrint("🟢 startDate: ${controller.startDate.value}");
                    debugPrint("🟢 endDate: ${controller.endDate.value}");
                    final DateTime today = DateTime.now();

                    DateTime? startDate;
                    DateTime? endDate;

                    if (controller.startDate.value.isNotEmpty) {
                      startDate = DateTime.tryParse(_formatDate(controller.startDate.value));
                    }

                    if (controller.endDate.value.isNotEmpty) {
                      endDate = DateTime.tryParse(_formatDate(controller.endDate.value));
                    }

                    DateTime? pickedDate = await showDatePicker(
                      context: context,
                      initialDate: controller.selectedDate.value,
                      firstDate: startDate ?? today,
                      lastDate: endDate ?? today.add(Duration(days: 30)), // Set a default last date if endDate is null
                    );

                    if (pickedDate != null) {
                      controller.selectedDate.value = pickedDate;
                      controller.loadAttendanceData(); // clear
                      controller.isBeforePresentList.clear();
                      controller.loadAttendanceData(); // reload
                      controller.getBeforeCurrentDayData();
                    }
                  },
                  child: Row(
                    // mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      CustomText(
                        text: "$classes $dateLabel",
                        size: 14,
                        fontWeight: FontWeight.w300,
                        color: blackColor,
                      ),
                      SizedBox(width: 5,),
                      Icon(Icons.keyboard_arrow_down_sharp, color: blackColor,size: 25,),
                    ],
                  ),
                ),
                CustomText(
                  text: "Attendance of $classes $subjects",
                  size: 16,
                  fontWeight: FontWeight.w700,
                  color: blackColor,
                ),
              ],
            ),
          ),
        ),
        body: ListView(
          physics: NeverScrollableScrollPhysics(),
          children: [
            StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance
                  .collection(attendanceRecordsTableName)
                  .doc(dateKey)
                  .collection("students").where("div", isEqualTo: classes).where("std", isEqualTo: subjects)
                  .snapshots(),
              builder: (context, snapshot) {

                if (!snapshot.hasData ||
                    snapshot.hasError ||
                    snapshot.connectionState == ConnectionState.waiting) {
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
              height: SizeConfig.screenHeight,
              child: ListView(
                physics: BouncingScrollPhysics(),
                children: [
                  StreamBuilder<QuerySnapshot>(
                    stream: FirebaseFirestore.instance
                        .collection(attendanceRecordsTableName)
                        .doc(dateKey)
                        .collection("students").where("div", isEqualTo: classes).where("std", isEqualTo: subjects)
                        .snapshots(),
                    builder: (context, attendanceSnapshot) {
                      if (!attendanceSnapshot.hasData) {
                        return Center(child: CircularProgressIndicator(),);
                      }
                      if (attendanceSnapshot.hasError) {
                        return Center(child: CustomText(
                            text: "${attendanceSnapshot.error}"),);
                      }
                      if (attendanceSnapshot.connectionState == ConnectionState.waiting) {
                        return Center(child: CircularProgressIndicator(),);
                      }
                      if (attendanceSnapshot.data!.docs.isEmpty) {
                        return Center(child: CustomText(
                          text: "No data found", color: blackColor,),);
                      }
                      var attendanceDocs = attendanceSnapshot.data!.docs;
                      for(var doc in attendanceDocs){
                        controller.isPresentList.add(doc['isPresent'] ?? false);
                      }

                      return StreamBuilder<QuerySnapshot>(
                          stream: FirebaseFirestore.instance.collection(attendanceTableName).where("div", isEqualTo: classes).where("std", isEqualTo: subjects).snapshots(),
                          builder: (context, snapshot) {
                            if (!snapshot.hasData) {
                              return Center(child: CircularProgressIndicator(),);
                            }
                            if (snapshot.hasError) {
                              return Center(child: CustomText(
                                text: "${snapshot.error}"),);
                            }
                            if (snapshot.connectionState == ConnectionState.waiting) {
                              return Center(child: CircularProgressIndicator(),);
                            }
                            if (snapshot.data!.docs.isEmpty) {
                              return Center(child: CustomText(
                                text: "No data found", color: blackColor,),);
                            }
                            final docs = snapshot.data!.docs;
                            controller.studentDocs = docs;

                            docs.sort((a, b) {
                              final aData = a.data() as Map<String, dynamic>;
                              final bData = b.data() as Map<String, dynamic>;

                              final aRoll = int.tryParse(aData['roll'].toString()) ?? 0;
                              final bRoll = int.tryParse(bData['roll'].toString()) ?? 0;

                              return aRoll.compareTo(bRoll);
                            });

                            return ListView.builder(
                              itemCount: controller.attendanceDocs.length,
                              shrinkWrap: true,
                              physics: NeverScrollableScrollPhysics(),
                              itemBuilder: (context, index) {
                                final data = docs[index].data() as Map<String, dynamic>;

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
                                                        alignment: Alignment.centerLeft,
                                                        width: SizeConfig.screenWidth * 0.27,
                                                        child: CustomText(
                                                          text: data['name'],
                                                          size: 14,
                                                          fontWeight: FontWeight.w700,
                                                          color: blackColor,
                                                        )
                                                    ),
                                                    CustomCard(
                                                      alignment: Alignment.center,
                                                      width: SizeConfig.screenWidth * 0.3,
                                                      child: CustomCard(
                                                        borderRadius: 5,
                                                        color: (index < controller.isBeforePresentList.length)
                                                            ? (!controller.isBeforePresentList[index]
                                                            ? Color(0xffFF9500)
                                                            : Color(0xffD9D9D9))
                                                            : Color(0xffD9D9D9),
                                                        child: Padding(
                                                          padding: const EdgeInsets.all(2.0),
                                                          child: CustomText(
                                                            text: data['roll'].toString(),
                                                            size: 14,
                                                            fontWeight: FontWeight.w700,
                                                            color: blackColor,
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                    Spacer(),
                                                    Obx(() {
                                                      debugPrint("object: $index");
                                                      bool present = index < controller.isPresentList.length ? controller.isPresentList[index] : false;

                                                      Color activeColor = present ? Colors.green : Color(0xffAC4444);

                                                      return GestureDetector(
                                                        onTap: () async{
                                                          controller.isPresentList[index] = !present;
                                                        },
                                                        child: AnimatedContainer(
                                                          duration: Duration(milliseconds: 300),
                                                          curve: Curves.easeInOut,
                                                          padding: EdgeInsets.symmetric(horizontal: 4, vertical: 4),
                                                          decoration: BoxDecoration(
                                                            color: Colors.white,
                                                            border: Border.all(color: activeColor, width: 2),
                                                            borderRadius: BorderRadius.circular(15),
                                                          ),
                                                          child: Row(
                                                            mainAxisSize: MainAxisSize.min,
                                                            children: [
                                                              if (!present)
                                                                AnimatedContainer(
                                                                  duration: Duration(milliseconds: 300),
                                                                  width: 20,
                                                                  height: 20,
                                                                  decoration: BoxDecoration(
                                                                    color: activeColor,
                                                                    shape: BoxShape.circle,
                                                                  ),
                                                                ),
                                                              if (!present)
                                                                SizedBox(width: 10),
                                                              AnimatedSwitcher(
                                                                duration: Duration(milliseconds: 300),
                                                                child: Text(
                                                                  !present ?  "Absent" : "Present",
                                                                  key: ValueKey(present),
                                                                  style: TextStyle(
                                                                    color: activeColor,
                                                                    fontSize: 12,
                                                                    fontWeight: FontWeight.w500,
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
                                                                    shape: BoxShape.circle,
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
                            final div = classes; // e.g. "6th"
                            final std = subjects; // You can extract this from class string if needed

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
                                controller.isAddMode.value
                                    ? TextButton(
                                  onPressed: () async {
                                    final name = controller.nameController.text.trim();
                                    final roll = controller.rollNoController.text.trim();
                                    final studentId = DateTime.now().millisecondsSinceEpoch.toString();
                                    if (name.isNotEmpty && roll.isNotEmpty) {
                                      try {
                                        Map<String,dynamic> data = {
                                          "name": name,
                                          "roll": roll,
                                          "std": std,
                                          "div": div,
                                          "isPresent": false,
                                          "createdDateTime": DateTime.now().toString(),
                                          "studentId": studentId,
                                        };
                                        await FirebaseFirestore.instance.collection("attendance_records")
                                            .doc(dateKey).collection("students").doc(studentId).set({
                                          "std": std,
                                          "div": div,
                                          "isPresent": false,
                                          "createdDateTime": studentId,
                                        });
                                        await FirebaseFirestore.instance.collection("attendance_records")
                                            .doc(dateKey).set({
                                          "createdDateTime": dateKey,
                                        });
                                        await FirebaseFirestore.instance.collection(attendanceTableName).doc(studentId).set(data).then((value) {
                                          Get.back();
                                          Get.snackbar("Success", "Student added successfully");
                                          controller.nameController.clear();
                                          controller.rollNoController.clear();
                                        },);
                                      } on FirebaseFirestore catch (e) {
                                        Get.snackbar("Error", "$e");
                                      }
                                    }
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
                  Obx(() => !controller.isSubmitMode.value ? Padding(
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
                        });
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
                  SizedBox(height: 25,),
                ],
              ),
            ),
          ],
        ),
      );
    });
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
