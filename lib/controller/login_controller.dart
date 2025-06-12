import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
import 'package:pencilo/admin_views/admin_home_view.dart';
import 'package:pencilo/db_helper/model_name.dart';
import 'package:pencilo/db_helper/network_check.dart';
import 'package:pencilo/model/admin_model.dart';
import 'package:pencilo/view/home.dart';
import '../data/consts/const_import.dart';
import '../data/current_user_data/current_user_Data.dart';
import '../model/attendance_model.dart';
import '../model/student_model.dart';
import '../model/teacher_model.dart';

class LoginController extends GetxController {

  @override
  void onInit() {
    getSchoolName();
    super.onInit();
  }

  final standardsList = ['4th', '5th', '6th', '7th', '8th', '9th', '10th'];
  final divisionsList = ['A', 'B', 'C', 'D', 'E', 'F', 'G', 'H', 'I', 'J'];
  List<String> schoolNameList = [];
  final genderList = ['Male', 'Female'];
  var selectedStandard = ''.obs;
  var selectedGender = ''.obs;
  var selectedDivision = ''.obs;
  var selectedSchoolName = ''.obs;
  var name = ''.obs;
  var currentLocation = ''.obs;
  // var schoolName = ''.obs;
  var phoneNumber = ''.obs;
  var subject = ''.obs;
  var isLoginUser = false.obs;
  var existId = "";  // Variable to store the uid of existing user
  var isTeacher = false; // Tracks whether the user is a teacher
  var isStudent = false; // Tracks whether the user is a teacher
  String pushToken = "";
  TextEditingController schoolNameController = TextEditingController();


  Future<void> getPushToken() async {
    String? token = await FcmService.getPushToken();
    pushToken = token!;
  }

  Future<void> getSchoolName ()async{
    schoolNameList.clear();
    QuerySnapshot schoolSnapshot = await FirebaseFirestore.instance.collection("schools_name").get();
    if (schoolSnapshot.docs.isNotEmpty) {
      for(var doc in schoolSnapshot.docs){
        schoolNameList.add(doc['schoolName']);
      }
    }
  }

  Future<void> storeSchoolName () async{
    QuerySnapshot schoolSnapshot = await FirebaseFirestore.instance.collection("schools_name").where("schoolName",isEqualTo: schoolNameController.text).get();
    if(schoolSnapshot.docs.isNotEmpty){
      return;
    }else{
      await FirebaseFirestore.instance.collection("schools_name").add({"schoolName":schoolNameController.text}).then((value) {
        getSchoolName ();
      });
    }
  }

// Validate the form fields and phone number format for Pakistan and India
  Future<bool> validateForm(BuildContext context) async {
    // Check if the required fields are filled
    if (name.value.isEmpty ||
        selectedSchoolName.value.isEmpty ||
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
      QuerySnapshot snapshot;

      if (isTeacher) {
        snapshot = await FirebaseFirestore.instance
            .collection(teacherTableName)
            .where('phoneNumber', isEqualTo: phoneNumber.value)
            .get();
      } else if (isStudent) {
        snapshot = await FirebaseFirestore.instance
            .collection(studentTableName)
            .where('phoneNumber', isEqualTo: phoneNumber.value)
            .get();
      } else {
        snapshot = await FirebaseFirestore.instance
            .collection('admin')
            .where('phoneNumber', isEqualTo: phoneNumber.value)
            .get();
      }

      if (snapshot.docs.isEmpty) {
        Get.snackbar("Not Found", "User with this phone number not found.");
        return;
      }

      var userDoc = snapshot.docs.first;
      var data = userDoc.data() as Map<String, dynamic>;

      existId = data['uid'];

      debugPrint("$isStudent");
      debugPrint("$isTeacher");
      debugPrint("pushToken $pushToken");
      // Update push token
      await FirebaseFirestore.instance
          .collection(isTeacher ? teacherTableName : isStudent ? studentTableName : 'admin')
          .doc(data['uid'])
          .update({'pushToken': pushToken});

      // Load into CurrentUserData
      CurrentUserData.uid = data['uid'] ?? '';
      CurrentUserData.name = data['fullName'] ?? '';
      CurrentUserData.phoneNumber = data['phoneNumber'] ?? '';
      CurrentUserData.pushToken = pushToken;

      if (!isTeacher && !isStudent) {
        CurrentUserData.isAdmin = true;
        await addAdminData(AdminModel(
          uid: data['uid'],
          phoneNumber: data['phoneNumber'],
          fullName: data['fullName'],
          isAdmin: true,
        ));
        return Get.offAll(AdminHomeView());
      }

      // Common Fields
      CurrentUserData.schoolName = data['schoolName'] ?? '';
      CurrentUserData.currentLocation = data['currentLocation'] ?? '';
      CurrentUserData.profileUrl = data['profileUrl'] ?? '';
      CurrentUserData.gender = data['gender'] ?? '';

      if (isTeacher) {
        CurrentUserData.isTeacher = true;
        CurrentUserData.isStudent = false;
        CurrentUserData.subject = data['subject'] ?? '';
        CurrentUserData.dob = data['dob'] ?? '';
        CurrentUserData.bloodGroup = data['bloodGroup'] ?? '';
        CurrentUserData.aadharNumber = data['aadharNumber'] ?? '';
        CurrentUserData.email = data['email'] ?? '';
        CurrentUserData.residentialAddress = data['residentialAddress'] ?? '';
        addTeacherDataToHive(userDoc);
      } else if (isStudent) {
        CurrentUserData.isStudent = true;
        CurrentUserData.isTeacher = false;
        CurrentUserData.standard = data['standard'] ?? '';
        CurrentUserData.rollNumber = data['rollNumber'] ?? '';
        CurrentUserData.admissionNumber = data['admissionNumber'] ?? '';
        CurrentUserData.division = data['division'] ?? '';
        CurrentUserData.dob = data['dob'] ?? '';
        CurrentUserData.bloodGroup = data['bloodGroup'] ?? '';
        CurrentUserData.aadharNumber = data['aadharNumber'] ?? '';
        CurrentUserData.email = data['email'] ?? '';
        CurrentUserData.residentialAddress = data['residentialAddress'] ?? '';
        CurrentUserData.parentName = data['parentName'] ?? '';
        CurrentUserData.parentPhone = data['parentPhone'] ?? '';
        addStudentDataToHive(userDoc);
      }

      Get.offAll(Home());
    } catch (e) {
      debugPrint("Error: $e");
      Get.snackbar('Error', 'Failed to fetch user data: $e');
    }
  }



  // Check if the phone number already exists in Firestore
  Future<void> storeUserData() async {

    if(!await NetworkHelper.isInternetAvailable()){
      Get.snackbar('Error', 'No Internet Connection');
      return;
    }
    await getPushToken();

    try {
      debugPrint("$isStudent");
      debugPrint("$isTeacher");
      QuerySnapshot userDoc;

      if (isTeacher) {
        userDoc = await FirebaseFirestore.instance
            .collection(teacherTableName)
            .where('phoneNumber', isEqualTo: phoneNumber.value)
            .get();
      } else if (isStudent) {
        debugPrint("Student");
        userDoc = await FirebaseFirestore.instance
            .collection(studentTableName)
            .where('phoneNumber', isEqualTo: phoneNumber.value)
            .get();
      }else{
        userDoc = await FirebaseFirestore.instance
            .collection('admin')
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
        storeSchoolName();
      }
    } catch (e) {
      Get.snackbar('Error', 'Failed to store data: $e');
      debugPrint("Error: $e");
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
      pushToken: userDoc['pushToken'],
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
      pushToken: userDoc['pushToken'] ?? '',
    );

    await studentBox.add(newStudent);
  }


  Future<void> storeTeacherData(String uid) async {
    try {
      final newTeacher = TeacherModel(
          uid: uid,
          fullName: name.value,
          schoolName: selectedSchoolName.value,
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
          gender: selectedGender.value,
          pushToken: pushToken
      );

      // Store the teacher data in Firestore using the toMap method
      await FirebaseFirestore.instance.collection(teacherTableName).doc(uid).set(newTeacher.toMap()).then((_) {


        // Update static data in CurrentUserData class
        CurrentUserData.uid = uid;
        CurrentUserData.name = name.value;
        CurrentUserData.schoolName = selectedSchoolName.value;
        CurrentUserData.phoneNumber = phoneNumber.value.trim();
        CurrentUserData.currentLocation = currentLocation.value;
        CurrentUserData.subject = subject.value;
        CurrentUserData.isTeacher = true;
        CurrentUserData.isStudent = false; // This will make sure the current user is marked as a teacher
        CurrentUserData.gender = selectedGender.value; // This will make sure the current user is marked as a teacher
        CurrentUserData.pushToken = pushToken; // This will make sure the current user is marked as a teacher
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
          schoolName: selectedSchoolName.value,
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
          pushToken: pushToken,
      );
      await addStudentAttendance(uid);
      // Store the student data in Firestore using the toMap method
      await FirebaseFirestore.instance.collection(studentTableName).doc(uid).set(newStudent.toMap()).then((_) {

        // Update static data in CurrentUserData class
        CurrentUserData.uid = uid;
        CurrentUserData.name = name.value;
        CurrentUserData.schoolName = selectedSchoolName.value;
        CurrentUserData.phoneNumber = phoneNumber.value.trim();
        CurrentUserData.currentLocation = currentLocation.value;
        CurrentUserData.standard = selectedStandard.value;
        CurrentUserData.gender = selectedGender.value;
        CurrentUserData.division = selectedDivision.value;
        CurrentUserData.isTeacher = false; // This will make sure the current user is marked as a student
        CurrentUserData.isStudent = true;
        CurrentUserData.pushToken = pushToken;
        // Store the student data in Hive
        addStudentData(newStudent);
      });
    } catch (e) {
      debugPrint("Error: $e");
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

  // Add Student Data to Hive
  addAdminData(AdminModel admin) async {
    final adminBox = await Hive.openBox<AdminModel>(adminTableName);
    await adminBox.add(admin);
  }

  ///Add student in attendance
  Future<void> addStudentAttendance(String uid) async {
    String date = DateFormat('dd-MM-yyyy').format(DateTime.now());

    QuerySnapshot studentSnapshot = await FirebaseFirestore.instance
        .collection(studentAttendanceTableName)
        .doc(selectedSchoolName.value)
        .collection("students")
        .where("schoolName", isEqualTo: selectedSchoolName.value).where(
        "division", isEqualTo: selectedDivision.value).where(
        "standard", isEqualTo: selectedStandard.value)
        .get();

    // Find the highest rollNo
    int maxRollNo = 0;
    for (var doc in studentSnapshot.docs) {
      String? rollNoStr = doc['rollNo'];
      int? roll = int.tryParse(rollNoStr ?? '');
      if (roll != null && roll > maxRollNo) {
        maxRollNo = roll;
      }
    }

    // New rollNo is highest + 1
    String rollNo = (maxRollNo + 1).toString();

    AttendanceModel attendanceModel = AttendanceModel(
      studentUid: uid,
      studentName: name.value,
      rollNo: rollNo,
      dateTime: date,
      division: selectedDivision.value,
      standard: selectedStandard.value,
      schoolName: CurrentUserData.schoolName,
    );

    // Save to Firestore
    await FirebaseFirestore.instance
        .collection(studentAttendanceTableName)
        .doc(selectedSchoolName.value)
        .collection("students")
        .doc(uid)
        .set(attendanceModel.addStudent()); // Ensure your model has `toMap()` method
  }

}
