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
  static String gender = ''; // Only for students
  static String division = ''; // Only for students
  static String subject = ''; // Only for teachers
  static bool isTeacher = false; // Flag to distinguish teacher and student
  static bool isStudent = false; // Flag to distinguish teacher and student
  static String profileUrl = ''; // URL for profile picture

  // Fields for students
  static String rollNumber = ''; // Only for students
  static String admissionNumber = ''; // Only for students
  static String dob = ''; // Date of birth for both students and teachers
  static String bloodGroup = ''; // Blood group for both students and teachers
  static String aadharNumber = ''; // Aadhar number for both students and teachers
  static String email = ''; // Email for both students and teachers
  static String residentialAddress = ''; // Residential address for both students and teachers
  static String parentName = ''; // Parent's name for students only
  static String parentPhone = ''; // Parent's phone number for students only
  static String classSection = ''; // Parent's phone classSection for students only

// Method to load user data from Hive (either teacher or student)
  static Future<void> loadUserDataFromHive() async {
    try {
      // Open the Hive boxes for teacher and student models
      var teacherBox = await Hive.openBox<TeacherModel>(teacherTableName);
      var studentBox = await Hive.openBox<StudentModel>(studentTableName);

      // Check for teacher data first
      if (teacherBox.isNotEmpty) {
        final teacher = teacherBox.getAt(0); // Assuming the teacher is at index 0
        if (teacher != null) {
          // Load data into CurrentUserData
          uid = teacher.uid ?? '';
          name = teacher.fullName ?? '';
          schoolName = teacher.schoolName ?? '';
          phoneNumber = teacher.phoneNumber ?? '';
          currentLocation = teacher.currentLocation ?? '';
          subject = teacher.subject ?? '';
          dob = teacher.dob ?? '';
          bloodGroup = teacher.bloodGroup ?? '';
          aadharNumber = teacher.aadharNumber ?? '';
          email = teacher.email ?? '';
          residentialAddress = teacher.residentialAddress ?? '';
          profileUrl = teacher.profileUrl ?? '';  // Assign profileUrl from Hive
          isTeacher = true;
          isStudent = false; // Ensure student flag is false
          gender = teacher.gender ?? ''; // Ensure student flag is false
        }
      }

      // Check for student data
      if (studentBox.isNotEmpty) {
        final student = studentBox.getAt(0); // Assuming the student is at index 0
        if (student != null) {
          // Load data into CurrentUserData
          uid = student.uid ?? '';
          name = student.fullName ?? '';
          schoolName = student.schoolName ?? '';
          phoneNumber = student.phoneNumber ?? '';
          currentLocation = student.currentLocation ?? '';
          standard = student.standard ?? '';
          division = student.division ?? '';
          dob = student.dob ?? '';
          bloodGroup = student.bloodGroup ?? '';
          aadharNumber = student.aadharNumber ?? '';
          email = student.email ?? '';
          residentialAddress = student.residentialAddress ?? '';
          parentName = student.parentName ?? '';
          parentPhone = student.parentPhone ?? '';
          profileUrl = student.profileUrl ?? '';  // Assign profileUrl from Hive
          isTeacher = false;
          isStudent = true; // Ensure student flag is true
          gender = student.gender ?? ''; // Ensure student flag is false
        }
      }
    } catch (e) {
      print('Error loading user data from Hive: $e');
    }
  }




  static Future<void> logout() async {
    try {
      if (isTeacher) {
        var teacherBox = await Hive.openBox<TeacherModel>(teacherTableName);
        await teacherBox.clear();
      } else {
        var studentBox = await Hive.openBox<StudentModel>(studentTableName);
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
        var teacherBox = await Hive.openBox<TeacherModel>(teacherTableName);
        return teacherBox.isNotEmpty;
      } else {
        var studentBox = await Hive.openBox<StudentModel>(studentTableName);
        return studentBox.isNotEmpty;
      }
    } catch (e) {
      print('Error checking user data in Hive: $e');
      return false;
    }
  }
}
