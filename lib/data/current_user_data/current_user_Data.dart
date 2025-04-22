import 'package:pencilo/db_helper/model_name.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../model/student_model.dart';
import '../../model/teacher_model.dart';
import '../../view/splash_view/lets_start_view.dart';
import '../consts/const_import.dart';

class CurrentUserData {
  // Static fields for storing current user data
  static String uid = '';
  static String name = '';
  static String schoolName = '';
  static String phoneNumber = '';
  static String currentLocation = '';
  static String standard = ''; // Only for students
  static String division = ''; // Only for students
  static String subject = ''; // Only for teachers
  static bool isTeacher = false; // Flag to distinguish teacher and student
  static bool isStudent = false; // Flag to distinguish teacher and student

  // Method to load user data from Hive (either teacher or student)
  static Future<void> loadUserDataFromHive() async {
    try {
      var teacherBox = await Hive.openBox<TeacherModel>(teacherModelName);
      var studentBox = await Hive.openBox<StudentModel>(studentModelName);

      // Check for teacher data first
      if (teacherBox.isNotEmpty) {
        final teacher = teacherBox.getAt(0);
        uid = teacher?.uid ?? '';
        name = teacher?.name ?? '';
        schoolName = teacher?.schoolName ?? '';
        phoneNumber = teacher?.phoneNumber ?? '';
        currentLocation = teacher?.currentLocation ?? '';
        subject = teacher?.subject ?? '';
        isTeacher = true;
        isStudent = false; // Ensure student flag is false
      } else if (studentBox.isNotEmpty) {
        final student = studentBox.getAt(0);
        uid = student?.uid ?? '';
        name = student?.name ?? '';
        schoolName = student?.schoolName ?? '';
        phoneNumber = student?.phoneNumber ?? '';
        currentLocation = student?.currentLocation ?? '';
        standard = student?.standard ?? '';
        division = student?.division ?? '';
        isTeacher = false;
        isStudent = true; // Ensure student flag is true
      }
    } catch (e) {
      print('Error loading user data from Hive: $e');
    }
  }

  // Method to load user data from Firestore (either teacher or student)
  static Future<void> loadUserDataFromFirestore(String uid) async {
    try {
      var userDoc = await FirebaseFirestore.instance.collection(isTeacher ? teacherModelName : studentModelName).doc(uid).get();

      if (userDoc.exists) {
        Map<String, dynamic> userData = userDoc.data()!;
        CurrentUserData.uid = userData['uid'];
        CurrentUserData.name = userData['name'];
        CurrentUserData.schoolName = userData['schoolName'];
        CurrentUserData.phoneNumber = userData['phoneNumber'];
        CurrentUserData.currentLocation = userData['currentLocation'];

        if (isTeacher) {
          subject = userData['subject'];
          isTeacher = true;
          isStudent = false; // Ensure student flag is false
        } else {
          standard = userData['standard'];
          division = userData['division'];
          isTeacher = false;
          isStudent = true; // Ensure student flag is true
        }
      }
    } catch (e) {
      print('Error loading user data from Firestore: $e');
    }
  }

  static Future<void> logout() async {
    try {
      if (isTeacher) {
        var teacherBox = await Hive.openBox<TeacherModel>(teacherModelName);
        await teacherBox.clear();
      } else {
        var studentBox = await Hive.openBox<StudentModel>(studentModelName);
        await studentBox.clear();
      }

      // Navigate to the login screen (LetsStartView)
      Get.to(LetsStartView());
    } catch (e) {
      print('Error logging out: $e');
    }
  }

  // Check if the user has data in Hive (either student or teacher data)
  static Future<bool> hasUserData() async {
    try {
      if (isTeacher) {
        var teacherBox = await Hive.openBox<TeacherModel>(teacherModelName);
        return teacherBox.isNotEmpty;
      } else {
        var studentBox = await Hive.openBox<StudentModel>(studentModelName);
        return studentBox.isNotEmpty;
      }
    } catch (e) {
      print('Error checking user data in Hive: $e');
      return false;
    }
  }
}
