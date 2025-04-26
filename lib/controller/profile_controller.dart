import 'package:get/get.dart';
import 'package:pencilo/data/consts/const_import.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:pencilo/data/current_user_data/current_user_Data.dart';
import 'package:pencilo/db_helper/model_name.dart';
import 'package:printing/printing.dart';
import 'package:intl/intl.dart'; // For date format
import 'package:cloud_firestore/cloud_firestore.dart'; // For Firebase integration


class ProfileController extends GetxController {
  Map<String, dynamic> get results {
    int totalMarks =
    subjectMarks.fold(0, (sum, item) => sum + (item['totalMarks'] as int));
    int maxMarks =
    subjectMarks.fold(0, (sum, item) => sum + (item['maxMarks'] as int));
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




  ///Edit Profile View methods
// Define controller variables to store text field values
  final fullNameController = TextEditingController();
  final classSectionController = TextEditingController();
  final rollNumberController = TextEditingController();
  final admissionNumberController = TextEditingController();
  final dobController = TextEditingController();
  final bloodGroupController = TextEditingController();
  final aadharNumberController = TextEditingController();
  final emailController = TextEditingController();
  final phoneNumberController = TextEditingController();
  final residentialAddressController = TextEditingController();
  final parentNameController = TextEditingController();
  final parentPhoneController = TextEditingController();
  final selectedClass = 'Select Class'.obs; // For dropdown
  var isLoading = false.obs;

  // Function to save data to Firestore
  Future<void> saveProfileData() async {
    // Validation: Check if all fields are filled
    if (fullNameController.text.isEmpty ||
        classSectionController.text.isEmpty ||
        rollNumberController.text.isEmpty ||
        admissionNumberController.text.isEmpty ||
        dobController.text.isEmpty ||
        bloodGroupController.text.isEmpty ||
        aadharNumberController.text.isEmpty ||
        emailController.text.isEmpty ||
        phoneNumberController.text.isEmpty ||
        residentialAddressController.text.isEmpty ||
        parentNameController.text.isEmpty ||
        parentPhoneController.text.isEmpty) {
      Get.snackbar("Error", "Please fill in all the required fields.");
      return;
    }

    // Set loading state
    isLoading.value = true;

    try {
      String uid = DateTime.now().millisecondsSinceEpoch.toString();
      // Add to Firestore
      await FirebaseFirestore.instance.collection(academicTableName).doc(uid).set({
        'uid' : CurrentUserData.uid,
        'full_name': fullNameController.text,
        'class_section': classSectionController.text,
        'roll_number': rollNumberController.text,
        'admission_number': admissionNumberController.text,
        'dob': dobController.text,
        'blood_group': bloodGroupController.text,  // Adjusted to use text from the text controller
        'aadhar_number': aadharNumberController.text,
        'email': emailController.text,
        'phone_number': phoneNumberController.text,
        'residential_address': residentialAddressController.text,
        'parent_name': parentNameController.text,
        'parent_phone': parentPhoneController.text,
      });

      // Show success message and clear fields
      clearFields();
      Get.back(); // Go back to previous screen after successful data save

    } catch (e) {

    } finally {
      // Hide loading state
      isLoading.value = false;
    }
  }

  // Function to pick date of birth
  Future<void> pickDateOfBirth(BuildContext context) async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime(2101),
    );

    if (pickedDate != null) {
      dobController.text = DateFormat('dd/MM/yyyy').format(pickedDate);
    }
  }

  // Method to clear all fields after successful profile update
  void clearFields() {
    fullNameController.clear();
    classSectionController.clear();
    rollNumberController.clear();
    admissionNumberController.clear();
    dobController.clear();
    bloodGroupController.clear();
    aadharNumberController.clear();
    emailController.clear();
    phoneNumberController.clear();
    residentialAddressController.clear();
    parentNameController.clear();
    parentPhoneController.clear();
    selectedClass.value = 'Select Class';
  }
}