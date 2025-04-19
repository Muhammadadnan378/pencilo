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
  static String standard = ''; // Only for students
  static String division = ''; // Only for students
  static String subject = ''; // Only for teachers
  static bool isTeacher = false; // Flag to distinguish teacher and student

  // Method to load user data from Hive (either teacher or student)
  static Future<void> loadUserDataFromHive() async {
    try {
      // Check for teacher data first
      if (isTeacher) {
        var teacherBox = await Hive.openBox<TeacherModel>(teacherModelName);
        if (teacherBox.isNotEmpty) {
          final teacher = teacherBox.getAt(0); // Assuming there's only one teacher in the box
          uid = teacher?.uid ?? '';
          name = teacher?.name ?? '';
          schoolName = teacher?.schoolName ?? '';
          phoneNumber = teacher?.phoneNumber ?? '';
          subject = teacher?.subject ?? '';
        }
      } else {
        var studentBox = await Hive.openBox<StudentModel>(studentModelName);
        if (studentBox.isNotEmpty) {
          final student = studentBox.getAt(0); // Assuming there's only one student in the box
          uid = student?.uid ?? '';
          name = student?.name ?? '';
          schoolName = student?.schoolName ?? '';
          phoneNumber = student?.phoneNumber ?? '';
          standard = student?.standard ?? '';
          division = student?.division ?? '';
        }
      }
    } catch (e) {
      print('Error loading user data from Hive: $e');
    }
  }

  // Method to load user data from Firestore (either teacher or student)
  static Future<void> loadUserDataFromFirestore(String uid) async {
    try {
      // Load data from Firestore based on UID
      var userDoc = await FirebaseFirestore.instance.collection(isTeacher ? 'teachers' : 'students').doc(uid).get();

      if (userDoc.exists) {
        Map<String, dynamic> userData = userDoc.data()!;
        CurrentUserData.uid = userData['uid'];
        CurrentUserData.name = userData['name'];
        CurrentUserData.schoolName = userData['schoolName'];
        CurrentUserData.phoneNumber = userData['phoneNumber'];

        if (isTeacher) {
          subject = userData['subject'];
        } else {
          standard = userData['standard'];
          division = userData['division'];
        }
      }
    } catch (e) {
      print('Error loading user data from Firestore: $e');
    }
  }

  // Method to store user data (either teacher or student) in Firestore
  static Future<void> storeUserData() async {
    try {
      // Store data in Firestore based on user role
      final userData = {
        'uid': uid,
        'name': name,
        'schoolName': schoolName,
        'phoneNumber': phoneNumber,
        'isTeacher': isTeacher,
      };

      if (isTeacher) {
        // Store data for teacher
        userData['subject'] = subject;
        await FirebaseFirestore.instance.collection('teachers').doc(uid).set(userData);
      } else {
        // Store data for student
        userData['standard'] = standard;
        userData['division'] = division;
        await FirebaseFirestore.instance.collection('students').doc(uid).set(userData);
      }
    } catch (e) {
      print('Error storing user data: $e');
    }
  }

  // Logout method: clear data from Hive and navigate to login screen
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
