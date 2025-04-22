import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:hive/hive.dart';
import 'package:pencilo/db_helper/model_name.dart';
import 'package:pencilo/view/home.dart';
import '../data/consts/const_import.dart';
import '../data/current_user_data/current_user_Data.dart';
import '../model/student_model.dart';
import '../model/teacher_model.dart';

class LoginController extends GetxController {
  final standards = ['4th', '5th', '6th', '7th', '8th', '9th', '10th'];
  final divisions = ['A', 'B', 'C', 'D', 'E', 'F', 'G', 'H', 'I', 'J'];

  var selectedStandard = ''.obs;
  var selectedDivision = ''.obs;
  var name = ''.obs;
  var currentLocation = ''.obs;
  var schoolName = ''.obs;
  var phoneNumber = ''.obs;
  var subject = ''.obs;

  var isLoginUser = false.obs;

  var existId = "";  // Variable to store the uid of existing user

  var isTeacher = false; // Tracks whether the user is a teacher

  void setIsTeacher(bool value) {
    isTeacher = value;
  }

  void selectStandard(String value) {
    selectedStandard.value = value;
  }

  void selectDivision(String value) {
    selectedDivision.value = value;
  }

  // Example usage in form validation
  bool get isFormValid {
    return name.isNotEmpty && schoolName.isNotEmpty && phoneNumber.isNotEmpty &&
        validatePhoneNumber(phoneNumber.value) &&
        (isTeacher ? subject.isNotEmpty : true);
  }

  // Validate the phone number for Pakistan and India
  bool validatePhoneNumber(String phoneNumber) {
    // Pakistan phone number regex pattern
    final pakistanPattern = RegExp(r'^03[0-9]{9}$');

    // India phone number regex pattern
    final indiaPattern = RegExp(r'^[789][0-9]{9}$');

    // Check if the number matches either of the patterns
    if (pakistanPattern.hasMatch(phoneNumber) || indiaPattern.hasMatch(phoneNumber)) {
      return true;  // Valid phone number
    } else {
      // Show error message if the phone number format is invalid
      Get.snackbar(
        'Invalid Phone Number',
        'Please enter a valid phone number. Format: Pakistan (03XXXXXXXXX) or India (7, 8, 9XXXXXXXXX)',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return false;  // Invalid phone number
    }
  }

  // Check if the phone number already exists in Firestore
  Future<bool> isPhoneNumberExist() async {
    try {
      final teacherDoc = await FirebaseFirestore.instance
          .collection(teacherModelName)
          .where('phoneNumber', isEqualTo: phoneNumber.value)
          .get();
      final studentDoc = await FirebaseFirestore.instance
          .collection(studentModelName)
          .where('phoneNumber', isEqualTo: phoneNumber.value)
          .get();

      // If a document exists in either collection, the number exists
      return teacherDoc.docs.isNotEmpty || studentDoc.docs.isNotEmpty;
    } catch (e) {
      Get.snackbar('Error', 'Failed to check phone number: $e');
      print("Error : $e");
      return false;
    }
  }

  // Store user data in Firestore (with DateTime as UID)
  Future<void> storeUserData() async {
    try {
      // Check if phone number already exists
      bool exists = await isPhoneNumberExist();
      if (exists) {
        // Fetch existing data from Firestore
        await fetchUserDataAndStoreInHive();
      } else {
        // Generate UID using current timestamp (millisecondsSinceEpoch)
        final String uid = DateTime.now().millisecondsSinceEpoch.toString();

        if (isTeacher) {
          await storeTeacherData(uid);
        } else {
          await storeStudentData(uid);
        }
      }
    } catch (e) {
      Get.snackbar('Error', 'Failed to store data: $e');
      print("Error : $e");
    }
  }

  // Fetch user data and store it in Hive if the phone number already exists
  Future<void> fetchUserDataAndStoreInHive() async {
    try {
      // Fetch data from Firestore for either teacher or student
      DocumentSnapshot userDoc;

      if (isTeacher) {
        userDoc = (await FirebaseFirestore.instance
            .collection(teacherModelName)
            .where('phoneNumber', isEqualTo: phoneNumber.value)
            .get()).docs.first;
      } else {
        userDoc = (await FirebaseFirestore.instance
            .collection(studentModelName)
            .where('phoneNumber', isEqualTo: phoneNumber.value)
            .get()).docs.first;
      }

      // Assign the uid of the existing user to existId
      existId = userDoc['uid'];

      // Load data into CurrentUserData and Hive
      CurrentUserData.uid = userDoc['uid'];
      CurrentUserData.name = userDoc['name'];
      CurrentUserData.schoolName = userDoc['schoolName'];
      CurrentUserData.currentLocation = userDoc['currentLocation'];
      CurrentUserData.phoneNumber = userDoc['phoneNumber'];

      if (isTeacher) {
        CurrentUserData.subject = userDoc['subject'];
        CurrentUserData.isTeacher = userDoc['isTeacher'];
        addTeacherDataToHive(userDoc);
      } else {
        CurrentUserData.standard = userDoc['standard'];
        CurrentUserData.isStudent = userDoc['isStudent'];
        CurrentUserData.division = userDoc['division'];
        addStudentDataToHive(userDoc);
      }

      // Navigate to Home after storing data
      Get.off(Home());
    } catch (e) {
      Get.snackbar('Error', 'Failed to fetch user data: $e');
      print("Error : $e");
    }
  }

  // Add Teacher Data to Hive
  void addTeacherDataToHive(DocumentSnapshot userDoc) async {
    final teacherBox = await Hive.openBox<TeacherModel>(teacherModelName);
    final newTeacher = TeacherModel(
      uid: userDoc['uid'],
      name: userDoc['name'],
      schoolName: userDoc['schoolName'],
      subject: userDoc['subject'],
      phoneNumber: userDoc['phoneNumber'],
      currentLocation: userDoc['currentLocation'],
    );
    await teacherBox.add(newTeacher);
  }

  // Add Student Data to Hive
  void addStudentDataToHive(DocumentSnapshot userDoc) async {
    final studentBox = await Hive.openBox<StudentModel>(studentModelName);
    final newStudent = StudentModel(
      uid: userDoc['uid'],
      name: userDoc['name'],
      schoolName: userDoc['schoolName'],
      standard: userDoc['standard'],
      division: userDoc['division'],
      phoneNumber: userDoc['phoneNumber'],
      currentLocation: userDoc['currentLocation'],
    );
    await studentBox.add(newStudent);
  }

  // Store Teacher Data in Firestore
  Future<void> storeTeacherData(String uid) async {
    try {
      final newTeacher = TeacherModel(
        uid: uid,
        name: name.value,
        schoolName: schoolName.value,
        subject: subject.value,
        phoneNumber: phoneNumber.value,
        currentLocation: currentLocation.value,
      );

      // Store the teacher data in Firestore
      await FirebaseFirestore.instance.collection(teacherModelName).doc(uid).set({
        'uid': uid,
        'name': name.value,
        'schoolName': schoolName.value,
        'subject': subject.value,
        'phoneNumber': phoneNumber.value,
        'isTeacher': true,
      }).then((_) {
        // Store the teacher data in Hive
        addTeacherData(newTeacher);
      });
    } catch (e) {
      Get.snackbar('Error', 'Failed to store teacher data: $e');
    }
  }

  // Store Student Data in Firestore
  Future<void> storeStudentData(String uid) async {
    try {
      final newStudent = StudentModel(
        uid: uid,
        name: name.value,
        schoolName: schoolName.value,
        standard: selectedStandard.value,
        division: selectedDivision.value,
        phoneNumber: phoneNumber.value,
        currentLocation: currentLocation.value,
      );

      // Store the student data in Firestore
      await FirebaseFirestore.instance.collection(studentModelName).doc(uid).set({
        'uid': uid,
        'name': name.value,
        'schoolName': schoolName.value,
        'standard': selectedStandard.value,
        'division': selectedDivision.value,
        'phoneNumber': phoneNumber.value,
        'currentLocation': currentLocation.value,
        'isStudent': true,
      }).then((_) {
        // Store the student data in Hive
        addStudentData(newStudent);
      });
    } catch (e) {
      Get.snackbar('Error', 'Failed to store student data: $e');
    }
  }

  // Add Teacher Data to Hive
  void addTeacherData(TeacherModel teacher) async {
    final teacherBox = await Hive.openBox<TeacherModel>(teacherModelName);
    await teacherBox.add(teacher).then((value) {
      Get.off(Home());  // Navigate to Home screen
    });
  }

  // Add Student Data to Hive
  void addStudentData(StudentModel student) async {
    final studentBox = await Hive.openBox<StudentModel>(studentModelName);
    await studentBox.add(student).then((value) {
      Get.off(Home());  // Navigate to Home screen
    });
  }
}
