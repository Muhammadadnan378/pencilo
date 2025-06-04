import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
import 'package:pencilo/data/current_user_data/current_user_Data.dart';
import 'package:pencilo/db_helper/model_name.dart';

import '../data/consts/const_import.dart';
import '../model/attendance_model.dart';

class AttendanceController extends GetxController {


  final standardsList = ['4th', '5th', '6th', '7th', '8th', '9th', '10th'];
  final divisionsList = ['A', 'B', 'C', 'D', 'E', 'F', 'G', 'H', 'I', 'J'];
  TextEditingController nameController = TextEditingController();
  TextEditingController rollNoController = TextEditingController();
  Rx<DateTime> selectedDate = DateTime.now().obs;
  Rx<String> startDate = "".obs;
  Rx<String> endDate = "".obs;
  String div = "";
  String std = "";
  RxInt presentCount = 0.obs;
  RxInt absentCount = 0.obs;
  RxBool isAddMode = true.obs;
  RxBool isSubmitMode = false.obs;
  RxList<bool> isPresentList = <bool>[].obs;
  RxList<bool> beforeIsPresentList = <bool>[].obs;

  // RxList<String> docIds = <String>[].obs;
  List<QueryDocumentSnapshot> attendanceDocs = [];
  List<QueryDocumentSnapshot> studentDocs = [];

  String formatDateWithSuffix(DateTime date) {
    int day = date.day;
    String suffix = "th";

    if (!(day >= 11 && day <= 13)) {
      switch (day % 10) {
        case 1:
          suffix = "st";
          break;
        case 2:
          suffix = "nd";
          break;
        case 3:
          suffix = "rd";
          break;
      }
    }

    String monthYear = DateFormat('MMM yyyy').format(date); // e.g. "Jun 2025"
    return "$day$suffix $monthYear";
  }


  void markAll(bool value) {
    for (int i = 0; i < isPresentList.length; i++) {
      isPresentList[i] = value;
    }
  }

  final List<Color> bgColors = [
    Color(0xff44AC47),
    Color(0xff2A26FF),
    Color(0xff4488AC),
    Color(0xff4465AC),
    Color(0xffAC4444),
    Color(0xffAC9E44),
  ];

  //Add student in attendance
  Future<void> addStudent() async {
    //Add new student in fireStore
    String name = nameController.text.trim();
    String rollNo = rollNoController.text.trim();
    String date = DateFormat('dd-MM-yyyy').format(selectedDate.value);
    String uid = DateTime
        .now()
        .millisecondsSinceEpoch
        .toString();

    QuerySnapshot querySnapshot = await FirebaseFirestore.instance.collection(
        studentAttendanceTableName).doc(CurrentUserData.schoolName).collection(
        "students").where(
        "schoolName", isEqualTo: CurrentUserData.schoolName).where(
        "rollNo", isEqualTo: rollNo).get();

    if (querySnapshot.docs.isNotEmpty) {
      Get.back();
      Get.snackbar(
          "Error", "Roll No. already exist", backgroundColor: blackColor,
          colorText: whiteColor);
      return;
    }

    AttendanceModel attendanceModel = AttendanceModel(
      studentUid: uid,
      studentName: name,
      rollNo: rollNo,
      dateTime: date,
      division: div,
      standard: std,
      schoolName: CurrentUserData.schoolName,
    );
    try {
      await FirebaseFirestore.instance
          .collection(studentAttendanceTableName)
          .doc(CurrentUserData.schoolName)
          .collection("students")
          .doc(uid)
          .set(attendanceModel.addStudent());
    } catch (e) {
      Get.back();
      Get.snackbar(
          "Error", "$e", backgroundColor: whiteColor, colorText: Colors.red);
    }
    Get.back();
    Get.snackbar(
        "Success", "Student Successfully Added", backgroundColor: blackColor,
        colorText: whiteColor);
  }

  Future<void> showPreviousAfterAttendance() async {
    isPresentList.clear();
    beforeIsPresentList.clear(); // Clear previous data

    String date = DateFormat('dd-MM-yyyy').format(selectedDate.value);
    String beforeDate = DateFormat('dd-MM-yyyy')
        .format(selectedDate.value.subtract(Duration(days: 1)));

    // Fetch current attendance data
    QuerySnapshot currentAttendanceSnapshot = await FirebaseFirestore.instance
        .collection(attendanceRecordsTableName)
        .doc(CurrentUserData.schoolName)
        .collection("students")
        .doc(date)
        .collection("studentsAttendance")
        .get();

    // Fetch previous attendance data
    QuerySnapshot beforeAttendanceSnapshot = await FirebaseFirestore.instance
        .collection(attendanceRecordsTableName)
        .doc(CurrentUserData.schoolName)
        .collection("students")
        .doc(beforeDate)
        .collection("studentsAttendance")
        .get();

    // Map attendance by student ID
    Map<String, dynamic> currentAttendanceMap = {
      for (var doc in currentAttendanceSnapshot.docs) doc.id: doc.data()
    };
    Map<String, dynamic> beforeAttendanceMap = {
      for (var doc in beforeAttendanceSnapshot.docs) doc.id: doc.data()
    };

    // Sort studentDocs by rollNo
    studentDocs.sort((a, b) {
      int rollA = int.tryParse(a['rollNo'].toString()) ?? 0;
      int rollB = int.tryParse(b['rollNo'].toString()) ?? 0;
      return rollA.compareTo(rollB);
    });

    // Fill isPresentList and beforeIsPresentList
    for (var student in studentDocs) {
      final docId = student.id;

      // Current day's data
      if (currentAttendanceMap.containsKey(docId)) {
        isPresentList.add(currentAttendanceMap[docId]['isPresent'] ?? false);
      } else {
        isPresentList.add(false);
      }

      // Previous day's data
      if (beforeAttendanceMap.containsKey(docId)) {
        beforeIsPresentList.add(beforeAttendanceMap[docId]['isPresent'] ?? true);
      } else {
        beforeIsPresentList.add(true);
      }
    }

    debugPrint("✅ isPresentList: $isPresentList");
    debugPrint("🕓 beforeIsPresentList: $beforeIsPresentList");
  }

  Future<void> submitAttendance() async {
    String date = DateFormat('dd-MM-yyyy').format(selectedDate.value);

    try {
      // Set createdDateTime doc
      await FirebaseFirestore.instance
          .collection(attendanceRecordsTableName)
          .doc(CurrentUserData.schoolName)
          .collection("students")
          .doc(date)
          .set({
        "createdDateTime": date,
      });

      // Submit attendance
      for (int i = 0; i < studentDocs.length; i++) {
        var doc = studentDocs[i];
        bool isPresent = isPresentList[i];

        final docRef = FirebaseFirestore.instance
            .collection(attendanceRecordsTableName)
            .doc(CurrentUserData.schoolName)
            .collection("students")
            .doc(date)
            .collection("studentsAttendance")
            .doc(doc.id);

        try {
          DocumentSnapshot snapshot = await docRef.get();

          if (snapshot.exists) {
            await docRef.update({"isPresent": isPresent});
          } else {
            AttendanceModel attendanceModel = AttendanceModel(
              studentUid: doc['studentUid'],
              rollNo: doc['rollNo'],
              dateTime: date,
              isPresent: isPresent,
              division: div,
              standard: std,
            );
            await docRef.set(attendanceModel.submitAttendance());
          }
        } catch (e) {
          Get.snackbar("Error", "$e", backgroundColor: whiteColor,
              colorText: Colors.red);
        }
      }

      Get.snackbar("Success", "Attendance Successfully Submitted", backgroundColor: blackColor, colorText: whiteColor);
    } catch (e) {
      Get.snackbar(
          "Error", "$e", backgroundColor: whiteColor, colorText: Colors.red);
    } finally {
      isSubmitMode(false); // ✅ Always stop loading/spinner
    }
  }

}

