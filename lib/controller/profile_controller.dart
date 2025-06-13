import 'package:pencilo/data/consts/const_import.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:pencilo/data/current_user_data/current_user_Data.dart';
import 'package:pencilo/db_helper/model_name.dart';
import 'package:pencilo/db_helper/network_check.dart';
import 'package:pencilo/model/attendance_model.dart';
import 'package:pencilo/model/student_model.dart';
import 'package:printing/printing.dart';
import 'package:intl/intl.dart'; // For date format
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'dart:io';
import '../model/notice_&_homework_model.dart';
import '../model/teacher_model.dart'; // For Firebase integration


class ProfileController extends GetxController {
  @override
  void onInit() {
    getNotice();
    super.onInit();
  }

  Map<String, dynamic> get results {
    int totalMarks = subjectMarks.fold(
      0,
          (total, item) => total + (item['totalMarks'] as int),
    );

    int maxMarks = subjectMarks.fold(
      0,
          (total, item) => total + (item['maxMarks'] as int),
    );

    double percentage = (totalMarks / maxMarks) * 100;

    String overallGrade;
    if (percentage >= 90) {
      overallGrade = 'A+';
    } else if (percentage >= 80) {
      overallGrade = 'A';
    } else if (percentage >= 70) {
      overallGrade = 'B+';
    } else if (percentage >= 60) {
      overallGrade = 'B';
    } else if (percentage >= 50) {
      overallGrade = 'C';
    } else if (percentage >= 40) {
      overallGrade = 'D';
    } else {
      overallGrade = 'F';
    }

    return {
      'totalMarks': totalMarks,
      'maxMarks': maxMarks,
      'percentage': percentage.toStringAsFixed(2),
      'grade': overallGrade,
    };
  }

  Future<void> generatePDF() async {
    final pdf = pw.Document();

    pdf.addPage(
      pw.Page(
        pageFormat: PdfPageFormat.a4,
        build: (pw.Context context) {
          return pw.Column(
            children: [
              pw.Header(
                level: 0,
                child: pw.Text('School Report Card',
                    textAlign: pw.TextAlign.center),
              ),
              pw.SizedBox(height: 20),
              pw.Row(
                mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                children: [
                  pw.Column(
                    crossAxisAlignment: pw.CrossAxisAlignment.start,
                    children: [
                      pw.Text('Name: ${studentInfo['name']}'),
                      pw.Text(
                          'Class: ${studentInfo['class']} ${studentInfo['section']}'),
                      pw.Text('Roll No: ${studentInfo['rollNo']}'),
                    ],
                  ),
                  pw.Column(
                    crossAxisAlignment: pw.CrossAxisAlignment.start,
                    children: [
                      pw.Text('Admission No: ${studentInfo['admissionNo']}'),
                      pw.Text('Session: 2024-2025'),
                      pw.Text('Term: First Term'),
                    ],
                  ),
                ],
              ),
              pw.SizedBox(height: 20),
              pw.Table(
                border: pw.TableBorder.all(),
                children: [
                  // Header row
                  pw.TableRow(
                    decoration:
                    const pw.BoxDecoration(color: PdfColors.grey300),
                    children: [
                      pw.Padding(
                        padding: const pw.EdgeInsets.all(5),
                        child: pw.Text('Subject',
                            style:
                            pw.TextStyle(fontWeight: pw.FontWeight.bold)),
                      ),
                      pw.Padding(
                        padding: const pw.EdgeInsets.all(5),
                        child: pw.Text('Theory',
                            style:
                            pw.TextStyle(fontWeight: pw.FontWeight.bold)),
                      ),
                      pw.Padding(
                        padding: const pw.EdgeInsets.all(5),
                        child: pw.Text('Practical',
                            style:
                            pw.TextStyle(fontWeight: pw.FontWeight.bold)),
                      ),
                      pw.Padding(
                        padding: const pw.EdgeInsets.all(5),
                        child: pw.Text('Total',
                            style:
                            pw.TextStyle(fontWeight: pw.FontWeight.bold)),
                      ),
                      pw.Padding(
                        padding: const pw.EdgeInsets.all(5),
                        child: pw.Text('Max',
                            style:
                            pw.TextStyle(fontWeight: pw.FontWeight.bold)),
                      ),
                      pw.Padding(
                        padding: const pw.EdgeInsets.all(5),
                        child: pw.Text('Grade',
                            style:
                            pw.TextStyle(fontWeight: pw.FontWeight.bold)),
                      ),
                    ],
                  ),
                  // Subject rows
                  ...subjectMarks.map((subject) => pw.TableRow(
                    children: [
                      pw.Padding(
                        padding: const pw.EdgeInsets.all(5),
                        child: pw.Text(subject['subject']),
                      ),
                      pw.Padding(
                        padding: const pw.EdgeInsets.all(5),
                        child: pw.Text(subject['theoryMarks'].toString()),
                      ),
                      pw.Padding(
                        padding: const pw.EdgeInsets.all(5),
                        child:
                        pw.Text(subject['practicalMarks'].toString()),
                      ),
                      pw.Padding(
                        padding: const pw.EdgeInsets.all(5),
                        child: pw.Text(subject['totalMarks'].toString()),
                      ),
                      pw.Padding(
                        padding: const pw.EdgeInsets.all(5),
                        child: pw.Text(subject['maxMarks'].toString()),
                      ),
                      pw.Padding(
                        padding: const pw.EdgeInsets.all(5),
                        child: pw.Text(subject['grade']),
                      ),
                    ],
                  )),
                ],
              ),
              pw.SizedBox(height: 20),
              pw.Container(
                width: double.infinity,
                padding: const pw.EdgeInsets.all(10),
                decoration: pw.BoxDecoration(
                  border: pw.Border.all(),
                ),
                child: pw.Column(
                  crossAxisAlignment: pw.CrossAxisAlignment.start,
                  children: [
                    pw.Text(
                        'Total Marks: ${results['totalMarks']} / ${results['maxMarks']}'),
                    pw.Text('Percentage: ${results['percentage']}%'),
                    pw.Text('Overall Grade: ${results['grade']}'),
                  ],
                ),
              ),
              pw.SizedBox(height: 20),
              pw.Container(
                width: double.infinity,
                padding: const pw.EdgeInsets.all(10),
                decoration: pw.BoxDecoration(
                  border: pw.Border.all(),
                ),
                child: pw.Column(
                  crossAxisAlignment: pw.CrossAxisAlignment.start,
                  children: [
                    pw.Text(
                        'Attendance: ${attendanceData['daysPresent']} / ${attendanceData['totalDays']} days (${attendanceData['percentage']}%)'),
                  ],
                ),
              ),
              pw.SizedBox(height: 30),
              pw.Row(
                mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                children: [
                  pw.Column(
                    crossAxisAlignment: pw.CrossAxisAlignment.center,
                    children: [
                      pw.Container(
                        width: 100,
                        height: 0.5,
                        color: PdfColors.black,
                      ),
                      pw.SizedBox(height: 5),
                      pw.Text('Class Teacher'),
                    ],
                  ),
                  pw.Column(
                    crossAxisAlignment: pw.CrossAxisAlignment.center,
                    children: [
                      pw.Container(
                        width: 100,
                        height: 0.5,
                        color: PdfColors.black,
                      ),
                      pw.SizedBox(height: 5),
                      pw.Text('Principal'),
                    ],
                  ),
                ],
              ),
            ],
          );
        },
      ),
    );

    await Printing.layoutPdf(
      onLayout: (PdfPageFormat format) async => pdf.save(),
    );
  }

  final List<Map<String, dynamic>> subjectMarks = [
    {
      'subject': 'Mathematics',
      'theoryMarks': 85,
      'practicalMarks': 18,
      'totalMarks': 103,
      'maxMarks': 120,
      'grade': 'A+',
      'icon': Icons.calculate,
      'color': Colors.blue,
    },
    {
      'subject': 'Science',
      'theoryMarks': 76,
      'practicalMarks': 19,
      'totalMarks': 95,
      'maxMarks': 120,
      'grade': 'A',
      'icon': Icons.science,
      'color': Colors.green,
    },
    {
      'subject': 'English',
      'theoryMarks': 72,
      'practicalMarks': 16,
      'totalMarks': 88,
      'maxMarks': 100,
      'grade': 'A',
      'icon': Icons.book,
      'color': Colors.purple,
    },
    {
      'subject': 'Hindi',
      'theoryMarks': 68,
      'practicalMarks': 15,
      'totalMarks': 83,
      'maxMarks': 100,
      'grade': 'B+',
      'icon': Icons.translate,
      'color': Colors.orange,
    },
    {
      'subject': 'Social Studies',
      'theoryMarks': 74,
      'practicalMarks': 17,
      'totalMarks': 91,
      'maxMarks': 100,
      'grade': 'A',
      'icon': Icons.public,
      'color': Colors.red,
    },
  ];

  final Map<String, dynamic> studentInfo = {
    'name': 'Rahul Sharma',
    'class': '8',
    'section': 'A',
    'rollNo': '15',
    'admissionNo': 'A20230015',
    'email': 'rahul.sharma@school.edu',
    'phone': '+91 9876543210',
    'address': '123 School Lane, New Delhi',
    'dateOfBirth': '12 June 2009',
    'bloodGroup': 'O+',
    'parentName': 'Rajesh Sharma',
    'parentPhone': '+91 9876543211',
  };

  final Map<String, dynamic> attendanceData = {
    'daysPresent': 20,
    'totalDays': 25,
    'percentage': 80,
    'history': [
      {'date': 'March 1', 'status': 'Present', 'isPresent': true},
      {'date': 'March 2', 'status': 'Present', 'isPresent': true},
      {'date': 'March 3', 'status': 'Absent', 'isPresent': false},
      {'date': 'March 4', 'status': 'Present', 'isPresent': true},
      {'date': 'March 5', 'status': 'Absent', 'isPresent': false},
      {'date': 'March 6', 'status': 'Present', 'isPresent': true},
      {'date': 'March 7', 'status': 'Present', 'isPresent': true},
    ]
  };

  Color getGradeColor(String grade) {
    switch (grade) {
      case 'A+':
        return Colors.purple;
      case 'A':
        return Colors.blue;
      case 'B+':
        return Colors.green;
      case 'B':
        return Colors.teal;
      case 'C':
        return Colors.orange;
      case 'D':
        return Colors.amber;
      default:
        return Colors.red;
    }
  }


  ///Profile View methods
  var isProfileLoading = false.obs;
  var imageUrl = ''.obs; // To store image URL
  var presents = "0".obs;
  var absents = "0".obs;

  // Method to pick image from gallery
  Future<void> pickImage(BuildContext context) async {
    try {
      final picker = ImagePicker();
      final pickedFile = await picker.pickImage(source: ImageSource.gallery);

      if (pickedFile != null) {
        File imageFile = File(pickedFile.path);
        isProfileLoading.value = true;
        // Reference the Firebase Storage location using CurrentUser.uid as the folder name
        Reference storageReference =
        FirebaseStorage.instance.ref().child('profileUrl/${CurrentUserData.uid}');
        UploadTask uploadTask = storageReference.putFile(imageFile);

        // Get download URL after upload
        await uploadTask.whenComplete(() async {
          String downloadUrl = await storageReference.getDownloadURL();
          imageUrl.value = downloadUrl;
          await updateProfileImage(downloadUrl);
        });
      }
    } finally {
      isProfileLoading.value = false;
    }
  }
  // Method to update the profile image in Firestore, Hive, and CurrentUserData
  Future<void> updateProfileImage(String newImageUrl) async {
    try {
      // Update in Firestore
      if (CurrentUserData.isTeacher) {
        await FirebaseFirestore.instance.collection(teacherTableName).doc(CurrentUserData.uid).update({
          'profileUrl': newImageUrl,
        });
      } else if (CurrentUserData.isStudent) {
        await FirebaseFirestore.instance.collection(studentTableName).doc(CurrentUserData.uid).update({
          'profileUrl': newImageUrl,
        });
      }

      // Update in Hive
      var teacherBox = await Hive.openBox<TeacherModel>(teacherTableName);
      var studentBox = await Hive.openBox<StudentModel>(studentTableName);
      if (CurrentUserData.isTeacher) {
        // Update teacher profileUrl in Hive
        try {
          TeacherModel teacherModel = teacherBox.getAt(0)!;
          teacherModel.profileUrl = newImageUrl;
          await teacherBox.putAt(0, teacherModel);
        } on Exception catch (e) {
          debugPrint("Failed to update profileUrl in Hive for teacher: $e");
        }
      } else if (CurrentUserData.isStudent) {
        // Update student profileUrl in Hive
        try {
          StudentModel studentModel = studentBox.getAt(0)!;
          studentModel.profileUrl = newImageUrl;
          await studentBox.putAt(0, studentModel);
        } on Exception catch (e) {
          debugPrint("Failed to update profileUrl in Hive for student: $e");
        }
      }

      // Update CurrentUserData
      CurrentUserData.profileUrl = newImageUrl;

      // Show success message
      Get.snackbar("success", "Profile image updated successfully.");
    } catch (e) {
      Get.snackbar("Error", "Failed to update profile image: $e");
      debugPrint("Error in updateProfileImage: $e");
    }
  }
  //get current user presents absents
  Future<void> getCurrentUserAttendance() async {
    presents.value = "0";
    absents.value = "0";

    try {
      // Get all dated attendance records under the current school
      QuerySnapshot datesSnapshot = await FirebaseFirestore.instance
          .collection(attendanceRecordsTableName)
          .doc(CurrentUserData.schoolName)
          .collection("students")
          .get();

      for (var dateDoc in datesSnapshot.docs) {
        final date = dateDoc.id;

        try {
          DocumentSnapshot studentAttendanceSnapshot = await FirebaseFirestore.instance
              .collection(attendanceRecordsTableName)
              .doc(CurrentUserData.schoolName)
              .collection("students")
              .doc(date)
              .collection("studentsAttendance")
              .doc(CurrentUserData.uid)
              .get();

          if (studentAttendanceSnapshot.exists) {
            final data = studentAttendanceSnapshot.data() as Map<String, dynamic>;
            if (data['isPresent'] == true) {
              presents.value = (int.parse(presents.value) + 1).toString();
            } else {
              absents.value = (int.parse(absents.value) + 1).toString();
            }
          }
        } catch (e) {
          debugPrint("⚠️ Failed to read attendance on $date: $e");
        }
      }

      debugPrint("✅ Total Presents: ${presents.value}");
      debugPrint("✅ Total Absents: ${absents.value}");

    } catch (e) {
      Get.snackbar("Error", "$e", backgroundColor: Colors.white, colorText: Colors.red);
    }
  }


  ///Edit Profile View methods
// Define controller variables to store text field values
  final fullNameController = TextEditingController(text: CurrentUserData.name);
  final rollNumberController = TextEditingController(text: CurrentUserData.rollNumber);
  final admissionNumberController = TextEditingController(text: CurrentUserData.admissionNumber);
  final schoolNameController = TextEditingController(text: CurrentUserData.schoolName);
  final dobController = TextEditingController(text: CurrentUserData.dob);
  final aadharNumberController = TextEditingController(text: CurrentUserData.aadharNumber);
  final emailController = TextEditingController(text: CurrentUserData.email);
  final phoneNumberController = TextEditingController(text: CurrentUserData.phoneNumber);
  final residentialAddressController = TextEditingController(text: CurrentUserData.residentialAddress);
  final parentNameController = TextEditingController(text: CurrentUserData.parentName);
  final parentPhoneController = TextEditingController(text: CurrentUserData.parentPhone);
  final subjectController = TextEditingController(text: CurrentUserData.subject);
  // final selectedClass = 'Select Class'.obs; // For dropdown
  var isLoading = false.obs;
  // Reactive variable to hold the selected blood group
  var selectedBloodGroup = RxString('');
  final standards = ['4th', '5th', '6th', '7th', '8th', '9th', '10th'];
  final divisions = ['A', 'B', 'C', 'D', 'E', 'F', 'G', 'H', 'I', 'J'];
  var selectedStandard = CurrentUserData.standard.obs;
  var selectedDivision = CurrentUserData.division.obs;
  var selectedSchoolName = "".obs;

  // List of available blood groups
  var bloodGroups = [
    'A+',
    'A-',
    'B+',
    'B-',
    'AB+',
    'AB-',
    'O+',
    'O-',
  ];

  bool emailValidation() {
    // Regular expression for validating Gmail email addresses
    final emailRegex = RegExp(r'^[a-zA-Z0-9._%+-]+@gmail\.com$');

    if (!emailRegex.hasMatch(emailController.text)) {
      return false;
    }
    return true; // Return true if email is valid
  }


  bool validatePhoneNumber(String phoneNumber) {
    // India phone number validation
      final myPhoneNumber = RegExp(r'^[789]\d{9}$');
      if (!myPhoneNumber.hasMatch(phoneNumber)) {
        return false;
      }
    return true; // Return true if phone number is valid
  }

  validation({required String value,
    required bool isName,
    required bool isAadharNumber,
    required bool isEmail,
    required bool isPhoneNumber,
    required bool isGurdianPhone}){
    if (isName && value.isEmpty) {
      return 'Name is required';
    }
    if (isAadharNumber && value.isNotEmpty && value.length != 12) {
      return 'Aadhar number should be 12 digits';
    }
    if (isEmail && value.isNotEmpty && !emailValidation()) {
      return 'Please enter a valid Gmail address';
    }
    if (isPhoneNumber && !validatePhoneNumber(phoneNumberController.text)) {
      if(phoneNumberController.text.isEmpty){
        return 'Phone number is required';
      }else{
        return 'Invalid phone number';
      }
    }
    if (isGurdianPhone && !validatePhoneNumber(parentPhoneController.text) && value.isNotEmpty) {
      return 'Invalid phone number';
    }
    return null; // No error
  }

  // Function to save data to Firestore
  Future<void> updateProfile() async {
    if(!await NetworkHelper.isInternetAvailable()){
      isLoading(false);
      Get.snackbar("Error", "No internet connection");
      return ;
    }

    if(selectedSchoolName.value.isEmpty){
      isLoading(false);
      Get.snackbar("Error", "School name is required");
      return ;
    }

    // Set loading state
    isLoading.value = true;

    try {
      TeacherModel teacherModel = TeacherModel(
        uid: CurrentUserData.uid,
        fullName: fullNameController.text.isNotEmpty ? fullNameController.text : CurrentUserData.name,
        dob: dobController.text.isNotEmpty ? dobController.text : CurrentUserData.dob,
        bloodGroup: selectedBloodGroup.value.isNotEmpty ? selectedBloodGroup.value : CurrentUserData.bloodGroup,
        aadharNumber: aadharNumberController.text.isNotEmpty ? aadharNumberController.text : CurrentUserData.aadharNumber,
        email: emailController.text.isNotEmpty ? emailController.text : CurrentUserData.email,
        phoneNumber: phoneNumberController.text.isNotEmpty ? phoneNumberController.text : CurrentUserData.phoneNumber,
        residentialAddress: residentialAddressController.text.isNotEmpty ? residentialAddressController.text : CurrentUserData.residentialAddress,
        subject: subjectController.text.isNotEmpty ? subjectController.text : CurrentUserData.subject,
        profileUrl: CurrentUserData.profileUrl,
        currentLocation: CurrentUserData.currentLocation,
        schoolName:  CurrentUserData.schoolName,
        isTeacher: true,
      );


      StudentModel studentModel = StudentModel(
        uid: CurrentUserData.uid,
        fullName: fullNameController.text.isNotEmpty ? fullNameController.text : CurrentUserData.name,
        dob: dobController.text.isNotEmpty ? dobController.text : CurrentUserData.dob,
        bloodGroup: selectedBloodGroup.value.isNotEmpty ? selectedBloodGroup.value : CurrentUserData.bloodGroup,
        aadharNumber: aadharNumberController.text.isNotEmpty ? aadharNumberController.text : CurrentUserData.aadharNumber,
        email: emailController.text.isNotEmpty ? emailController.text : CurrentUserData.email,
        phoneNumber: phoneNumberController.text.isNotEmpty ? phoneNumberController.text : CurrentUserData.phoneNumber,
        residentialAddress: residentialAddressController.text.isNotEmpty ? residentialAddressController.text : CurrentUserData.residentialAddress,
        rollNumber: rollNumberController.text.isNotEmpty ? rollNumberController.text : CurrentUserData.rollNumber,
        admissionNumber: admissionNumberController.text.isNotEmpty ? admissionNumberController.text : CurrentUserData.admissionNumber,
        parentName: parentNameController.text.isNotEmpty ? parentNameController.text : CurrentUserData.parentName,
        parentPhone: parentPhoneController.text.isNotEmpty ? parentPhoneController.text : CurrentUserData.parentPhone,
        standard: selectedStandard.value.isNotEmpty ? selectedStandard.value : CurrentUserData.standard,
        division: selectedDivision.value.isNotEmpty ? selectedDivision.value : CurrentUserData.division,
        isStudent: true,
        schoolName: selectedSchoolName.value.isNotEmpty ? selectedSchoolName.value : CurrentUserData.schoolName,
        currentLocation: CurrentUserData.currentLocation,
        profileUrl: CurrentUserData.profileUrl,
      );


      // Open Hive boxes
      var teacherBox = await Hive.openBox<TeacherModel>(teacherTableName);
      var studentBox = await Hive.openBox<StudentModel>(studentTableName);

      if(selectedSchoolName.value != CurrentUserData.schoolName && selectedSchoolName.value.isNotEmpty){
        await FirebaseFirestore.instance.collection("schools_name").add({"schoolName":schoolNameController.text});
      }

      // Update current user data in Firestore and Hive
      if (CurrentUserData.isTeacher) {
        try {
          // Update teacher data in Firestore
          await FirebaseFirestore.instance
              .collection(teacherTableName)
              .doc(CurrentUserData.uid)
              .update(teacherModel.toMap());

          // Update teacher data in Hive
          await teacherBox.putAt(0, teacherModel);

          // Update static data in CurrentUserData
          CurrentUserData.name = teacherModel.fullName ?? CurrentUserData.name;
          CurrentUserData.subject = teacherModel.subject ?? CurrentUserData.subject ;
          CurrentUserData.phoneNumber = teacherModel.phoneNumber ?? CurrentUserData.phoneNumber;
          CurrentUserData.dob = teacherModel.dob ?? CurrentUserData.dob;
          CurrentUserData.bloodGroup = teacherModel.bloodGroup ?? CurrentUserData.bloodGroup;
          CurrentUserData.aadharNumber = teacherModel.aadharNumber ?? CurrentUserData.aadharNumber;
          CurrentUserData.email = teacherModel.email ?? CurrentUserData.email;
          CurrentUserData.residentialAddress = teacherModel.residentialAddress ?? CurrentUserData.residentialAddress;
          CurrentUserData.residentialAddress = teacherModel.residentialAddress ?? CurrentUserData.residentialAddress;

        } on FirebaseFirestore catch (e) {
          Get.snackbar("Error", "$e");
        }
      } else if (CurrentUserData.isStudent) {
        try {
          // Update student data in Firestore
          await FirebaseFirestore.instance
              .collection(studentTableName)
              .doc(CurrentUserData.uid)
              .update(studentModel.toMap());
          
          //Update user division and standard in attendance
          if(CurrentUserData.division != selectedDivision.value || CurrentUserData.standard != selectedStandard.value || CurrentUserData.name != fullNameController.text || CurrentUserData.schoolName != selectedSchoolName.value) {
            AttendanceModel newData = AttendanceModel(
              studentName: fullNameController.text,
              standard: selectedStandard.value,
              division: selectedDivision.value,
              schoolName: selectedSchoolName.value,
            );

            FirebaseFirestore.instance
                .collection(studentAttendanceTableName)
                .doc(CurrentUserData.schoolName)
                .collection("students")
                .doc(CurrentUserData.uid)
                .update(newData.updateAttendance());
          }
          

          // Update student data in Hive
          try {
            await studentBox.putAt(0, studentModel);
          } on Exception catch (e) {
            Get.snackbar("Error", "$e");
          }

          // Update static data in CurrentUserData
          CurrentUserData.name = studentModel.fullName ?? CurrentUserData.name;
          CurrentUserData.standard = studentModel.standard ?? CurrentUserData.standard; // Store class
          CurrentUserData.division = studentModel.division ?? CurrentUserData.division; // Store section
          CurrentUserData.phoneNumber = studentModel.phoneNumber ?? CurrentUserData.phoneNumber;
          CurrentUserData.dob = studentModel.dob ?? CurrentUserData.dob;
          CurrentUserData.bloodGroup = studentModel.bloodGroup ?? CurrentUserData.bloodGroup;
          CurrentUserData.aadharNumber = studentModel.aadharNumber ?? CurrentUserData.aadharNumber;
          CurrentUserData.email = studentModel.email ?? CurrentUserData.email;
          CurrentUserData.residentialAddress = studentModel.residentialAddress ?? CurrentUserData.residentialAddress;
          CurrentUserData.parentName = studentModel.parentName ?? CurrentUserData.parentName;
          CurrentUserData.parentPhone = studentModel.parentPhone ?? CurrentUserData.parentPhone;
          CurrentUserData.schoolName = studentModel.schoolName ?? CurrentUserData.schoolName;

        } on FirebaseException catch (e) {
          Get.snackbar("Error", "$e");
        }
      }

      isLoading(false);
      Get.back(); // Go back to the previous screen after successful data save
      // Show success message and clear fields
      Get.snackbar("Success", "Profile data updated successfully.");

    } catch (e) {
      // Handle any other exceptions
      isLoading(false);
      Get.snackbar("Error", "Failed to update profile: $e");
    } finally {
      // Hide loading state
      isLoading(false);
      isLoading.value = false;
    }
  }


  // Function to pick date of birth
  Future<void> pickDateOfBirth(BuildContext context) async {
    // Calculate the date 6 years ago from today
    DateTime sixYearsAgo = DateTime.now().subtract(Duration(days: 6 * 365));

    // Ensure initialDate is not later than lastDate (6 years ago)
    DateTime initialDate = DateTime.now().isBefore(sixYearsAgo) ? DateTime.now() : sixYearsAgo;

    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: initialDate, // Use a valid initial date
      firstDate: DateTime(1900), // This could be the earliest date someone can choose
      lastDate: sixYearsAgo, // The latest date they can pick (6 years ago)
    );

    if (pickedDate != null) {
      dobController.text = DateFormat('dd/MM/yyyy').format(pickedDate);
    }
  }

  ///Notice Methods
  final RxList<NoticeHomeWorkModel> showData = <NoticeHomeWorkModel>[].obs;
  RxInt totalNotice = 0.obs;

  Future<void> getNotice() async {
    QuerySnapshot noticeSnapshot = await FirebaseFirestore.instance
        .collection(noticeTableName)
        .where("division", isEqualTo: CurrentUserData.division)
        .where("standard", isEqualTo: CurrentUserData.standard)
        .get();

    int count = 0;
    for (var noticeDoc in noticeSnapshot.docs) {
      NoticeHomeWorkModel noticeModel = NoticeHomeWorkModel.fromMap(noticeDoc.data() as Map<String, dynamic>);

      // ✅ Count only if CurrentUserData.uid is NOT in noticeIsWatched
      if (!noticeModel.noticeIsWatched.contains(CurrentUserData.uid)) {
        count++;
      }
    }

    totalNotice.value = count; // Set final value after loop
  }

  Future<void> markNoticeAsWatched() async {
    QuerySnapshot noticeSnapshot = await FirebaseFirestore.instance
        .collection(noticeTableName)
        .where("division", isEqualTo: CurrentUserData.division)
        .where("standard", isEqualTo: CurrentUserData.standard)
        .get();

    for (var noticeDoc in noticeSnapshot.docs) {
      NoticeHomeWorkModel noticeModel =
      NoticeHomeWorkModel.fromMap(noticeDoc.data() as Map<String, dynamic>);

      // If UID is not already in the list, add it
      if (!noticeModel.noticeIsWatched.contains(CurrentUserData.uid)) {
        await FirebaseFirestore.instance
            .collection(noticeTableName)
            .doc(noticeDoc.id)
            .update({
          "noticeIsWatched": FieldValue.arrayUnion([CurrentUserData.uid])
        });
        totalNotice.value = 0;
      }
    }
  }




}