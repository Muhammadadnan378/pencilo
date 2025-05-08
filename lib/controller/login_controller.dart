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
  final gender = ['Male', 'Female'];
  var selectedStandard = ''.obs;
  var selectedGender = ''.obs;
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
// Validate the form fields and phone number format for Pakistan and India
  Future<bool> validateForm(BuildContext context) async {
    // Check if the required fields are filled
    if (name.value.isEmpty ||
        schoolName.value.isEmpty ||
        phoneNumber.value.isEmpty ||
        selectedGender.value.isEmpty ||
        (isTeacher && subject.value.isEmpty) ||
        (!isTeacher && selectedStandard.value.isEmpty) ||
        (!isTeacher && selectedDivision.value.isEmpty)) {
      showSnackbar(context, 'Please fill all the required fields.');
      return false;
    }
    // Validate phone number format
    bool isPhoneValid = await validatePhoneNumber(context);
    if (!isPhoneValid) {
      return false;
    }
    return true; // Return true if form is valid
  }

// Validate the phone number for Pakistan and India
  Future<bool> validatePhoneNumber(BuildContext context) async {
    // India phone number validation with required +91 or 91 at the start
      final myPhoneNumber = RegExp(r'^[789]\d{9}$');
      if (!myPhoneNumber.hasMatch(phoneNumber.value)) {
        showSnackbar(context, "Please enter a valid Indian phone number.");
        return false;
      }
    return true; // Return true if phone number is valid
  }
  // Fetch user data and store it in Hive if the phone number already exists
  Future<void> fetchUserDataAndStoreInHive() async {
    try {
      // Fetch data from Firestore for either teacher or student
      DocumentSnapshot userDoc;
      if (isTeacher) {
        userDoc = (await FirebaseFirestore.instance
            .collection(teacherTableName)
            .where('phoneNumber', isEqualTo: phoneNumber.value)
            .get()).docs.first;
      } else {
        userDoc = (await FirebaseFirestore.instance
            .collection(studentTableName)
            .where('phoneNumber', isEqualTo: phoneNumber.value)
            .get()).docs.first;
      }
      // Assign the uid of the existing user to existId
      existId = userDoc['uid'];
      // Load data into CurrentUserData and Hive, ensuring all fields are included
      CurrentUserData.uid = userDoc['uid'] ?? '';
      CurrentUserData.name = userDoc['fullName'] ?? '';
      CurrentUserData.schoolName = userDoc['schoolName'] ?? '';
      CurrentUserData.currentLocation = userDoc['currentLocation'] ?? '';
      CurrentUserData.phoneNumber = userDoc['phoneNumber'] ?? '';
      CurrentUserData.profileUrl = userDoc['profileUrl'] ?? '';
      CurrentUserData.gender = userDoc['gender'] ?? '';
      if (isTeacher) {
        CurrentUserData.subject = userDoc['subject'] ?? '';
        CurrentUserData.isTeacher = userDoc['isTeacher'] ?? true;
        // Ensure all teacher-related fields are stored
        CurrentUserData.dob = userDoc['dob'] ?? '';
        CurrentUserData.bloodGroup = userDoc['bloodGroup'] ?? '';
        CurrentUserData.aadharNumber = userDoc['aadharNumber'] ?? '';
        CurrentUserData.email = userDoc['email'] ?? '';
        CurrentUserData.residentialAddress = userDoc['residentialAddress'] ?? '';
        addTeacherDataToHive(userDoc);
      } else {
        // Ensure all student-related fields are stored
        CurrentUserData.standard = userDoc['standard'] ?? '';
        CurrentUserData.rollNumber = userDoc['rollNumber'] ?? '';
        CurrentUserData.admissionNumber = userDoc['admissionNumber'] ?? '';
        CurrentUserData.isStudent = userDoc['isStudent'] ?? true;
        CurrentUserData.division = userDoc['division'] ?? '';
        CurrentUserData.dob = userDoc['dob'] ?? '';
        CurrentUserData.bloodGroup = userDoc['bloodGroup'] ?? '';
        CurrentUserData.aadharNumber = userDoc['aadharNumber'] ?? '';
        CurrentUserData.email = userDoc['email'] ?? '';
        CurrentUserData.residentialAddress = userDoc['residentialAddress'] ?? '';
        CurrentUserData.parentName = userDoc['parentName'] ?? '';
        CurrentUserData.parentPhone = userDoc['parentPhone'] ?? '';
        addStudentDataToHive(userDoc);
      }
      // Navigate to Home after storing data
      Get.offAll(Home());
    } catch (e) {
      Get.snackbar('Error', 'Failed to fetch user data: $e');
      print("Error: $e");
    }
  }
  // Check if the phone number already exists in Firestore
  Future<bool> isPhoneNumberExist() async {
    try {
      final teacherDoc = await FirebaseFirestore.instance
          .collection(teacherTableName)
          .where('phoneNumber', isEqualTo: phoneNumber.value)
          .get();
      final studentDoc = await FirebaseFirestore.instance
          .collection(studentTableName)
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
      QuerySnapshot userDoc;

      if (isTeacher) {
        userDoc = await FirebaseFirestore.instance
            .collection(teacherTableName)
            .where('phoneNumber', isEqualTo: phoneNumber.value)
            .get();
      } else {
        userDoc = await FirebaseFirestore.instance
            .collection(studentTableName)
            .where('phoneNumber', isEqualTo: phoneNumber.value)
            .get();
      }

      if (userDoc.docs.isNotEmpty) {
        // User already exists, fetch data
        await fetchUserDataAndStoreInHive();
      } else {
        // New user, generate UID and store
        final String uid = DateTime.now().millisecondsSinceEpoch.toString();
        if (isTeacher) {
          await storeTeacherData(uid);
        } else {
          await storeStudentData(uid);
        }
      }
    } catch (e) {
      Get.snackbar('Error', 'Failed to store data: $e');
      print("Error: $e");
    }
  }


// Add Teacher Data to Hive
  void addTeacherDataToHive(DocumentSnapshot userDoc) async {
    final teacherBox = await Hive.openBox<TeacherModel>(teacherTableName);

    // Initialize the newTeacher object with empty fields if they're missing
    final newTeacher = TeacherModel(
      uid: userDoc['uid'],
      fullName: userDoc['fullName'],
      schoolName: userDoc['schoolName'],
      subject: userDoc['subject'],
      phoneNumber: userDoc['phoneNumber'],
      currentLocation: userDoc['currentLocation'],
      isTeacher: userDoc['isTeacher'],
      dob: userDoc['dob'],
      bloodGroup: userDoc['bloodGroup'],
      aadharNumber: userDoc['aadharNumber'],
      email: userDoc['email'] ?? '',
      residentialAddress: userDoc['residentialAddress'],
      profileUrl: userDoc['profileUrl'],
      gender: userDoc['gender'],
    );

    await teacherBox.add(newTeacher);
  }

// Add Student Data to Hive
  void addStudentDataToHive(DocumentSnapshot userDoc) async {
    final studentBox = await Hive.openBox<StudentModel>(studentTableName);

    // Initialize the newStudent object with empty fields if they're missing
    final newStudent = StudentModel(
      uid: userDoc['uid'] ?? '',
      fullName: userDoc['fullName'] ?? '',
      rollNumber: userDoc['rollNumber'] ?? '',
      admissionNumber: userDoc['admissionNumber'] ?? '',
      dob: userDoc['dob'] ?? '',
      bloodGroup: userDoc['bloodGroup'] ?? '',
      aadharNumber: userDoc['aadharNumber'] ?? '',
      email: userDoc['email'] ?? '',
      phoneNumber: userDoc['phoneNumber'] ?? '',
      residentialAddress: userDoc['residentialAddress'] ?? '',
      parentName: userDoc['parentName'] ?? '',
      parentPhone: userDoc['parentPhone'] ?? '',
      schoolName: userDoc['schoolName'] ?? '',
      standard: userDoc['standard'] ?? '',
      division: userDoc['division'] ?? '',
      currentLocation: userDoc['currentLocation'] ?? '',
      isStudent: userDoc['isStudent'] ?? true,
      profileUrl: userDoc['profileUrl'] ?? '',
      gender: userDoc['gender'] ?? '',
    );

    await studentBox.add(newStudent);
  }


  Future<void> storeTeacherData(String uid) async {
    try {
      final newTeacher = TeacherModel(
          uid: uid,
          fullName: name.value,
          schoolName: schoolName.value,
          subject: subject.value,
          phoneNumber: phoneNumber.value.trim(),
          currentLocation: currentLocation.value,
          dob: "", // Default empty string
          bloodGroup: "", // Default empty string
          aadharNumber: "", // Default empty string
          email: "", // Default empty string
          residentialAddress: "", // Default empty string
          profileUrl: "",// Default empty string
          isTeacher: true,
          gender: selectedGender.value
      );

      // Store the teacher data in Firestore using the toMap method
      await FirebaseFirestore.instance.collection(teacherTableName).doc(uid).set(newTeacher.toMap()).then((_) {


        // Update static data in CurrentUserData class
        CurrentUserData.uid = uid;
        CurrentUserData.name = name.value;
        CurrentUserData.schoolName = schoolName.value;
        CurrentUserData.phoneNumber = phoneNumber.value.trim();
        CurrentUserData.currentLocation = currentLocation.value;
        CurrentUserData.subject = subject.value;
        CurrentUserData.isTeacher = true;
        CurrentUserData.isStudent = false; // This will make sure the current user is marked as a teacher
        CurrentUserData.gender = selectedGender.value; // This will make sure the current user is marked as a teacher
        // Store the teacher data in Hive
        addTeacherData(newTeacher);
      });
    } catch (e) {
      Get.snackbar('Error', 'Failed to store teacher data: $e');
    }
  }

  Future<void> storeStudentData(String uid) async {
    try {
      final newStudent = StudentModel(
          uid: uid,
          fullName: name.value,
          schoolName: schoolName.value,
          standard: selectedStandard.value,
          division: selectedDivision.value,
          phoneNumber: phoneNumber.value.trim(),
          currentLocation: currentLocation.value,
          dob: "", // Default empty string
          bloodGroup: "", // Default empty string
          aadharNumber: "", // Default empty string
          email: "", // Default empty string
          residentialAddress: "", // Default empty string
          parentName: "", // Default empty string
          parentPhone: "", // Default empty string
          profileUrl: "",// Default empty string
          isStudent: true,
          rollNumber: "", // Default empty string
          admissionNumber: "", // Default empty string
          gender: selectedGender.value,
      );

      // Store the student data in Firestore using the toMap method
      await FirebaseFirestore.instance.collection(studentTableName).doc(uid).set(newStudent.toMap()).then((_) {


        // Update static data in CurrentUserData class
        CurrentUserData.uid = uid;
        CurrentUserData.name = name.value;
        CurrentUserData.schoolName = schoolName.value;
        CurrentUserData.phoneNumber = phoneNumber.value.trim();
        CurrentUserData.currentLocation = currentLocation.value;
        CurrentUserData.standard = selectedStandard.value;
        CurrentUserData.gender = selectedGender.value;
        CurrentUserData.division = selectedDivision.value;
        CurrentUserData.isTeacher = false; // This will make sure the current user is marked as a student
        CurrentUserData.isStudent = true;
        // Store the student data in Hive
        addStudentData(newStudent);
      });
    } catch (e) {
      Get.snackbar('Error', 'Failed to store student data: $e');
    }
  }


  // Add Teacher Data to Hive
  void addTeacherData(TeacherModel teacher) async {
    final teacherBox = await Hive.openBox<TeacherModel>(teacherTableName);
    await teacherBox.add(teacher).then((value) {
      Get.offAll(Home());  // Navigate to Home screen
    });
  }


  // Add Student Data to Hive
  void addStudentData(StudentModel student) async {
    final studentBox = await Hive.openBox<StudentModel>(studentTableName);
    await studentBox.add(student).then((value) {
      Get.offAll(Home());  // Navigate to Home screen
    });
  }
}
