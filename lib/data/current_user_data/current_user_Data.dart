import 'package:pencilo/db_helper/model_name.dart';
import '../../model/admin_model.dart';
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
  static String pushToken = ''; // URL for profile picture

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
  static bool isAdmin = false; // Parent's phone classSection for students only

// Method to load user data from Hive (either teacher or student)
  static Future<void> loadUserDataFromHive() async {
    try {
      var adminBox = await Hive.openBox<AdminModel>(adminTableName);
      var teacherBox = await Hive.openBox<TeacherModel>(teacherTableName);
      var studentBox = await Hive.openBox<StudentModel>(studentTableName);

      // Check for admin data first
      if (adminBox.isNotEmpty) {
        final admin = adminBox.getAt(0);
        if (admin != null) {
          uid = admin.uid;
          name = admin.fullName;
          phoneNumber = admin.phoneNumber;
          isAdmin = true;
          isTeacher = false;
          isStudent = false;
          return; // ✅ Exit once found
        }
      }

      // Check for teacher data
      if (teacherBox.isNotEmpty) {
        final teacher = teacherBox.getAt(0);
        if (teacher != null) {
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
          profileUrl = teacher.profileUrl ?? '';
          gender = teacher.gender ?? '';
          pushToken = teacher.pushToken ?? '';
          isTeacher = true;
          isStudent = false;
          isAdmin = false;
          return;
        }
      }

      // Check for student data
      if (studentBox.isNotEmpty) {
        final student = studentBox.getAt(0);
        if (student != null) {
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
          profileUrl = student.profileUrl ?? '';
          gender = student.gender ?? '';
          pushToken = student.pushToken ?? '';
          isTeacher = false;
          isStudent = true;
          isAdmin = false;
          return;
        }
      }

      // If nothing is found
      debugPrint('No user data found in Hive.');

    } catch (e) {
      debugPrint('Error loading user data from Hive: $e');
    }
  }

  static Future<void> logout() async {
    try {
      if (isTeacher) {
        var teacherBox = await Hive.openBox<TeacherModel>(teacherTableName);
        await teacherBox.clear();
      } else if (isStudent) {
        var studentBox = await Hive.openBox<StudentModel>(studentTableName);
        await studentBox.clear();
      } else {
        var adminBox = await Hive.openBox<AdminModel>(adminTableName);
        await adminBox.clear();
      }

      // Clear all static fields
      uid = '';
      name = '';
      schoolName = '';
      phoneNumber = '';
      currentLocation = '';
      standard = '';
      gender = '';
      division = '';
      subject = '';
      isTeacher = false;
      isStudent = false;
      isAdmin = false;
      profileUrl = '';
      pushToken = '';
      rollNumber = '';
      admissionNumber = '';
      dob = '';
      bloodGroup = '';
      aadharNumber = '';
      email = '';
      residentialAddress = '';
      parentName = '';
      parentPhone = '';
      classSection = '';

      // Navigate to the login screen
      Get.to(LetsStartView());
    } catch (e) {
      debugPrint('Error logging out: $e');
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
      debugPrint('Error checking user data in Hive: $e');
      return false;
    }
  }
}
