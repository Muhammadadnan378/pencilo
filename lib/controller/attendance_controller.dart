import 'package:cloud_firestore/cloud_firestore.dart';
import '../data/consts/const_import.dart';
import '../data/current_user_data/current_user_Data.dart';
import '../db_helper/model_name.dart';
import '../model/attendance_model.dart';

class AttendanceController extends GetxController {

  ///Attendance view methods
  final TextEditingController classController = TextEditingController();
  final TextEditingController sectionController = TextEditingController();

  final List<Color> bgColors = [
    Color(0xff44AC47),
    Color(0xff2A26FF),
    Color(0xff4488AC),
    Color(0xff4465AC),
    Color(0xffAC4444),
    Color(0xffAC9E44),
  ];

  Future<void> createClassManually() async {
    QuerySnapshot studentSnapshot = await FirebaseFirestore.instance.collection(studentTableName).get();
    for (var doc in studentSnapshot.docs) {
      final data = doc.data() as Map<String, dynamic>;
      QuerySnapshot classSnapshot = await FirebaseFirestore.instance.collection(classesTableName).where("division", isEqualTo: data['division']).where("standard", isEqualTo: data['standard']).get();
      if (classSnapshot.docs.isEmpty) {
        AttendanceModel newStudent = AttendanceModel(
          classId: DateTime.now().millisecondsSinceEpoch.toString(),
          userId: doc.id,
          name: data['fullName'] ?? '',
          division: data['division'] ?? '',
          standard: data['standard'] ?? '',
        );
        await FirebaseFirestore.instance.collection(classesTableName).doc(doc.id).set(newStudent.toMap());
      }
    }
  }

  Future<void> storeAttendanceManually() async {
    final now = DateTime.now();
    final String dateKey = "${now.year}-${now.month}-${now.day}";

    QuerySnapshot classSnapshot = await FirebaseFirestore.instance.collection(attendanceTableName).get();
    QuerySnapshot studentSnapshot = await FirebaseFirestore.instance.collection(studentTableName).get();


    int maxRoll = -1;

    for (var doc in classSnapshot.docs) {
      final data = doc.data() as Map<String, dynamic>;

      // Convert roll to int, handle if null or not convertible
      int? roll = int.tryParse(data['roll'].toString());
      if (roll != null && roll > maxRoll) {
        maxRoll = roll;
      }
    }
    debugPrint("Sabse bada roll number: $maxRoll");

    for (var doc in studentSnapshot.docs) {
      final data = doc.data() as Map<String, dynamic>;
      Map<String, dynamic> attendanceData = {
        "createdDateTime": DateTime.now().toString(),
        "studentId": doc.id,
        "name": data['fullName'] ?? '',
        "div": data['division'] ?? '',
        "std": data['standard'] ?? '',
        "roll": maxRoll + 1,
        "isPresent": false,
      };
      Map<String, dynamic> attendanceRecordData = {
        "createdDateTime": DateTime.now().toString(),
        "studentId": doc.id,
        "div": data['division'] ?? '',
        "std": data['standard'] ?? '',
        "roll": maxRoll + 1,
        "isPresent": false,
      };
      await FirebaseFirestore.instance.collection(attendanceTableName).doc(doc.id).set(attendanceData);
      await FirebaseFirestore.instance.collection(attendanceRecordsTableName).doc(dateKey).collection("students").doc(doc.id).set(attendanceRecordData);
    }
  }

  Future<void> addClass()async{
    final division = classController.text.trim();
    final standard = sectionController.text.trim();
    String classId = DateTime.now().millisecondsSinceEpoch.toString();
    AttendanceModel classData = AttendanceModel(
        classId: classId,
        userId: CurrentUserData.uid,
        name: CurrentUserData.name,
        division: division,
        standard: standard,
        timestamp: DateTime.now().millisecondsSinceEpoch.toString()
    );
    if (division.isNotEmpty && standard.isNotEmpty) {
      await FirebaseFirestore.instance.collection(classesTableName).doc(classId).set(classData.toMap());
      Get.back();
    }
  }



  /// Attendance Submit view methods

  Rx<DateTime> selectedDate = DateTime.now().obs;
  Rx<String> startDate = "".obs;
  Rx<String> endDate = "".obs;
  String div = "";
  String std = "";
  // Future<void> updateSelectedDateTime() async {
  //   try {
  //     QuerySnapshot snapshot = await FirebaseFirestore.instance
  //         .collection(attendanceRecordsTableName)
  //         .orderBy('createdDateTime')
  //         .get();
  //
  //     if (snapshot.docs.isNotEmpty) {
  //       String firstDate = (snapshot.docs.first.data() as Map<String, dynamic>)['createdDateTime'];
  //       String lastDate = (snapshot.docs.last.data() as Map<String, dynamic>)['createdDateTime'];
  //
  //       startDate.value = firstDate;
  //       endDate.value = lastDate;
  //     } else {
  //       // No documents in collection
  //       startDate.value = "";
  //       endDate.value = "";
  //     }
  //     print("startDate inner: ${startDate.value}");
  //     print("endDate inner: ${endDate.value}");
  //   } catch (e) {
  //     print('Error getting dates: $e');
  //     startDate.value = "";
  //     endDate.value = "";
  //   }
  // }
  RxList<bool> isBeforePresentList = <bool>[].obs;
  Future<void> getBeforeCurrentDayData() async {
    isBeforePresentList.clear();
    debugPrint("🧹 Cleared isBeforePresentList: $isBeforePresentList");

    final DateTime yesterday = selectedDate.value.subtract(Duration(days: 1));
    final String dateKey = "${yesterday.year}-${yesterday.month}-${yesterday.day}";
    debugPrint("📅 Date:== $dateKey");

    final attendanceDocRef = FirebaseFirestore.instance
        .collection(attendanceRecordsTableName)
        .doc(dateKey).collection("students");

    final docSnapshot = await attendanceDocRef.get();
    debugPrint("📄 Fetched ${docSnapshot.docs.length} docs");

    if (docSnapshot.docs.isNotEmpty) {
      for (int i = 0; i < docSnapshot.docs.length; i++) {
        final doc = docSnapshot.docs[i];
        final data = doc.data();
        final isPresent = data['isPresent'] ?? false;
        isBeforePresentList.add(isPresent);
        debugPrint("👤 Student $i isPresent: $isPresent");
      }
      debugPrint("✅ Final isBeforePresentList: $isBeforePresentList");
    }
  }



  Future<void> createNewAttendance() async {
    final now = DateTime.now();
    final String dateKey = "${now.year}-${now.month}-${now.day}";

    final attendanceDocRef = FirebaseFirestore.instance
        .collection(attendanceRecordsTableName)
        .doc(dateKey);

    // Check if record for today already exists
    final docSnapshot = await attendanceDocRef.get();

    if (!docSnapshot.exists) {
      // Get all students
      final studentsSnapshot = await FirebaseFirestore.instance
          .collection(attendanceTableName)
          .get();

      // Create attendance for each student
      for (var studentDoc in studentsSnapshot.docs) {
        final String studentId = studentDoc.id;

        await attendanceDocRef
            .collection("students")
            .doc(studentId)
            .set({
          "div" : div,
          "std" : std,
          "isPresent": false,
          "createdDateTime": now.toIso8601String(),
        });
      }

      // Create parent record with creation date
      await attendanceDocRef.set({
        "createdDateTime": dateKey,
      });

      debugPrint("✅ Created new attendance record for $dateKey with ${studentsSnapshot.docs.length} students.");
    } else {
      debugPrint("ℹ️ Attendance for $dateKey already exists.");
    }

    /// ✅ Update startDate and endDate
    try {
      final snapshot = await FirebaseFirestore.instance
          .collection(attendanceRecordsTableName)
          .orderBy('createdDateTime')
          .get();

      if (snapshot.docs.isNotEmpty) {
        startDate.value = snapshot.docs.first.id;
        endDate.value = snapshot.docs.last.id;

        debugPrint("🟢 startDate: ${startDate.value}");
        debugPrint("🟢 endDate: ${endDate.value}");
      } else {
        debugPrint("⚠️ No attendance records found for range.");
      }
    } catch (e) {
      debugPrint("❌ Error fetching attendance date range: $e");
    }
  }


  @override
  void onInit() {
    getBeforeCurrentDayData();
    storeAttendanceManually();
    createNewAttendance().then((value) {
      final parsedEndDate = DateTime.tryParse(endDate.value);
      selectedDate.value = parsedEndDate ?? DateTime.now();
    },);
    super.onInit();
  }

  RxList<bool> isPresentList = <bool>[].obs;
  RxList<String> docIds = <String>[].obs;
  List<QueryDocumentSnapshot> attendanceDocs = [];
  List<QueryDocumentSnapshot> studentDocs = [];

  void markAll(bool value) {
    for (int i = 0; i < isPresentList.length; i++) {
      isPresentList[i] = value;
    }
  }


  Future<void> loadAttendanceData() async {
    for (var doc in attendanceDocs) {
      final data = doc.data() as Map<String, dynamic>;
      isPresentList.add(data['isPresent'] ?? false);
      docIds.add(doc.id);
    }
  }

  // Future<void> getAttendance(subjects, classes,Widget) async {
  //   QuerySnapshot attendanceSnapshot = await FirebaseFirestore.instance
  //       .collection(attendanceTableName)
  //       .where("div", isEqualTo: subjects)
  //       .where("std", isEqualTo: classes)
  //       .get();
  //
  //   if (attendanceSnapshot.docs.isEmpty) {
  //     return ;
  //   } else {
  //     // Use the data
  //   }
  // }

  Future<void> submitAttendance() async {
    final now = selectedDate.value;
    final String dateKey = "${now.year}-${now.month}-${now.day}";

    for (int i = 0; i < attendanceDocs.length; i++) {
      final docId = attendanceDocs[i].id;

      await FirebaseFirestore.instance
          .collection(attendanceRecordsTableName)
          .doc(dateKey)
          .collection("students")
          .doc(docId)
          .update({
        'isPresent': isPresentList[i],
      });
    }

    // Reload updated data from Firestore
    final snapshot = await FirebaseFirestore.instance
        .collection(attendanceRecordsTableName)
        .doc(dateKey)
        .collection("students")
        .get();

    attendanceDocs = snapshot.docs;
    await loadAttendanceData();
  }


  RxInt presentCount = 0.obs;
  RxInt absentCount = 0.obs;

  TextEditingController nameController = TextEditingController();
  TextEditingController rollNoController = TextEditingController();
  RxBool isAddMode = true.obs;
  RxBool isSubmitMode = false.obs;
  RxBool isPresent = false.obs;

  Future<void> deleteClass(String docId) async {
    await FirebaseFirestore.instance
        .collection(classesTableName)
        .doc(docId)
        .delete();
  }

}
