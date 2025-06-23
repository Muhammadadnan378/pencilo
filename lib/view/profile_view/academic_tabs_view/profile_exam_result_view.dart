import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:pencilo/data/current_user_data/current_user_Data.dart';
import 'package:pencilo/data/custom_widget/custom_dropdown.dart';
import 'package:pencilo/data/custom_widget/custom_media_query.dart';
import 'package:pencilo/db_helper/model_name.dart';
import 'package:printing/printing.dart';
import 'package:rxdart/rxdart.dart';

import '../../../controller/profile_controller.dart';
import '../../../data/consts/const_import.dart';
import '../../../model/result_subjects_model.dart';

class ProfileExamResultView extends StatefulWidget {
  ProfileExamResultView({super.key});

  @override
  State<ProfileExamResultView> createState() => _ProfileExamResultViewState();
}

class _ProfileExamResultViewState extends State<ProfileExamResultView> {
  final ProfileController controller = Get.put(ProfileController());

  Future<void> fetchSchoolData() async {
    debugPrint("fetchSchoolData");
    DocumentSnapshot schoolData = await FirebaseFirestore.instance
        .collection(schoolTableName)
        .doc(CurrentUserData.schoolName)
        .get();

    if (schoolData.exists) {
      // get school logo
      controller.schoolLogoImage.value = schoolData['schoolLogo'];
      controller.schoolWebLink.value = schoolData['websiteLink'];
      controller.schoolContactNumber.value = schoolData['contactNumber'];
      controller.schoolAddress.value = schoolData['schoolAddress'];
      controller.schoolName.value = schoolData['schoolName'];
      controller.schoolClassTeacherSignatureImage.value =
      schoolData['classTeacherSignature'];
      controller.schoolPrincipleSignatureImage.value =
      schoolData['principalSignature'];
    } else {
      controller.clearAllFields();
      debugPrint("no school logo");
    }

    QuerySnapshot subjectsData = await FirebaseFirestore.instance
        .collection(resultSubjectsTableName)
        .doc(CurrentUserData.schoolName)
        .collection(controller.selectedYear.value).where(
        "standard", isEqualTo: controller.selectedStandard.value).where(
        "division", isEqualTo: controller.selectedDivision.value)
        .get();

    if (subjectsData.docs.isNotEmpty) {
      String subjectId = subjectsData.docs[0].id;
      QuerySnapshot studentData = await FirebaseFirestore.instance
          .collection(resultSubjectsTableName)
          .doc(CurrentUserData.schoolName)
          .collection(controller.selectedYear.value)
          .doc(subjectId).collection("studentsSubject")
          .doc(
          "${controller.selectedStandard.value}${controller.selectedDivision
              .value}")
          .collection("studentResults")
          .where("studentUid", isEqualTo: CurrentUserData.uid).get();

      if (studentData.docs.isNotEmpty) {
        controller.studentName.value = studentData.docs[0]['studentName'];
        controller.studentRollNo.value = studentData.docs[0]['rollNo'];
        controller.studentDivStd.value =
        "${studentData.docs[0]['standard']} ${studentData.docs[0]['division']}";

        controller.resultDoc.value = studentData;
        for (var item in studentData.docs) {
          var resultData = ResultModel.fromMap(
              item.data() as Map<String, dynamic>);
          if (resultData.term == "Midterm") {
            debugPrint("Mid Term");
          } else {
            debugPrint("Final Term");
          }
        }
      } else {
        debugPrint("no student data");
        debugPrint("CurrentUserData.uid: ${CurrentUserData.uid}");
        controller.studentName.value = "";
        controller.studentRollNo.value = "";
        controller.studentDivStd.value = "";
        controller.resultDoc.value = null;
      }
    } else {
      controller.studentName.value = "";
      controller.studentRollNo.value = "";
      controller.studentDivStd.value = "";
      controller.resultDoc.value = null;
    }
  }

  Future<void> _printReport({required String term}) async {
    final docs = controller.resultDoc.value?.docs ?? [];
    final termDocs = docs
        .map((d) => ResultModel.fromMap(d.data() as Map<String, dynamic>))
        .where((m) => m.term == term)
        .toList();

    if (termDocs.isEmpty) {
      controller.isTermResultPDFShow(false);
      Get.snackbar("Notice", "No data for $term");
      return;
    }

    final pdf = pw.Document();

    // Load images
    pw.MemoryImage? logo;
    if (controller.schoolLogoImage.value.isNotEmpty) {
      final logoData = await NetworkAssetBundle(Uri.parse(controller.schoolLogoImage.value)).load("");
      logo = pw.MemoryImage(logoData.buffer.asUint8List());
    }

    pw.MemoryImage? teacherSigImg;
    if (controller.schoolClassTeacherSignatureImage.value.isNotEmpty) {
      final data = await NetworkAssetBundle(Uri.parse(controller.schoolClassTeacherSignatureImage.value)).load("");
      teacherSigImg = pw.MemoryImage(data.buffer.asUint8List());
    }

    pw.MemoryImage? principalSigImg;
    if (controller.schoolPrincipleSignatureImage.value.isNotEmpty) {
      final data = await NetworkAssetBundle(Uri.parse(controller.schoolPrincipleSignatureImage.value)).load("");
      principalSigImg = pw.MemoryImage(data.buffer.asUint8List());
    }

    pdf.addPage(
      pw.MultiPage(
        pageFormat: PdfPageFormat.a4,
        build: (context) => [
          pw.Row(
            children: [
              if (logo != null)
                pw.ClipOval(
                  child: pw.Container(
                    width: 70,
                    height: 70,
                    child: pw.Image(logo, fit: pw.BoxFit.cover),
                  ),
                ),
              pw.SizedBox(width: 15),
              pw.Column(
                crossAxisAlignment: pw.CrossAxisAlignment.start,
                  children: [
                    pw.Text(
                      controller.schoolName.value,
                      style: pw.TextStyle(fontSize: 14, fontWeight: pw.FontWeight.bold),
                    ),
                    pw.SizedBox(height: 3),
                    pw.Text(
                      controller.schoolAddress.value,
                      style: pw.TextStyle(fontSize: 10),
                    ),
                    pw.SizedBox(height: 3),
                    pw.Text(
                      controller.schoolContactNumber.value,
                      style: pw.TextStyle(fontSize: 10),
                    ),
                  ]
              ),
              pw.Spacer(),
              pw.SizedBox(
                width: 130,
                height: 50,
                child: pw.Text("Address: ${controller.schoolAddress.value}", style: pw.TextStyle(fontSize: 10))
              )
            ],
          ),

          pw.SizedBox(height: 40),
          pw.Row(mainAxisAlignment: pw.MainAxisAlignment.spaceBetween, children: [
            pw.Column(crossAxisAlignment: pw.CrossAxisAlignment.start, children: [
              pw.Text("Name: ${controller.studentName.value}"),
              pw.Text("Class: ${controller.studentDivStd.value}"),
              pw.Text("Roll No: ${controller.studentRollNo.value}"),
            ]),
            pw.Column(crossAxisAlignment: pw.CrossAxisAlignment.start, children: [
              pw.Text("Session: ${controller.selectedYear.value}"),
              pw.Text("Term: $term"),
            ]),
          ]),
          pw.SizedBox(height: 10),
          pw.TableHelper. fromTextArray(
            headerStyle: pw.TextStyle(fontWeight: pw.FontWeight.bold),
            headerDecoration: pw.BoxDecoration(
              color: PdfColors.grey300, // Dark grey background for header
            ),
            cellAlignment: pw.Alignment.centerLeft,
            headers: ['Subject', 'Theory', 'Practical', 'Total', 'Max', 'Grade'],
            data: termDocs.map((m) {
              final t = int.tryParse(m.subjectTheoryMarks ?? "0") ?? 0;
              final p = int.tryParse(m.subjectPracticalMarks ?? "0") ?? 0;
              final max = m.totalSubjectMarks ?? 0;
              final obt = t + p;
              final grade = controller.getGradeFromMarks(obtained: obt, max: max);
              return [m.subjectName, "$t", "$p", "$obt", "$max", grade];
            }).toList(),
          ),
          pw.SizedBox(height: 20),
              () {
            final sums = termDocs.fold<List<int>>([0, 0], (s, m) {
              final t = int.tryParse(m.subjectTheoryMarks ?? "0") ?? 0;
              final p = int.tryParse(m.subjectPracticalMarks ?? "0") ?? 0;
              final mx = m.totalSubjectMarks ?? 0;
              return [s[0] + t + p, s[1] + mx];
            });
            final percent = sums[1] == 0 ? 0.0 : (sums[0] / sums[1]) * 100;
            final grade = controller.getGradeFromMarks(obtained: sums[0], max: sums[1]);
            return pw.Container(
              width: double.infinity,
              padding: const pw.EdgeInsets.all(10),
              decoration: pw.BoxDecoration(border: pw.Border.all()),
              child: pw.Column(
                crossAxisAlignment: pw.CrossAxisAlignment.start,
                children: [
                  pw.Text("Total Marks: ${sums[0]} / ${sums[1]}"),
                  pw.Text("Percentage: ${percent.toStringAsFixed(2)}%"),
                  pw.Text("Overall Grade: $grade"),
                ],
              ),
            );
          }(),
          // pw.SizedBox(height: 20),
          // pw.Container(
          //   width: double.infinity,
          //   padding: const pw.EdgeInsets.all(10),
          //   decoration: pw.BoxDecoration(border: pw.Border.all()),
          //   child: pw.Text(
          //     'Attendance: {controller.attendanceDays.value} / {controller.totalDays.value} days ({(controller.attendanceDays.value / controller.totalDays.value * 100).toStringAsFixed(0)}%)',
          //   ),
          // ),
          pw.SizedBox(height: 30),
          pw.Row(
            mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
            children: [
              pw.Column(
                children: [
                  if (teacherSigImg != null)
                    pw.Image(teacherSigImg, width: 100, height: 50),
                  pw.Container(width: 100, height: 0.5, color: PdfColors.black),
                  pw.SizedBox(height: 5),
                  pw.Text('Class Teacher'),
                ],
              ),
              pw.Column(
                children: [
                  if (principalSigImg != null)
                    pw.Image(principalSigImg, width: 100, height: 50),
                  pw.Container(width: 100, height: 0.5, color: PdfColors.black),
                  pw.SizedBox(height: 5),
                  pw.Text('Principal'),
                ],
              ),
            ],
          ),
        ],
      ),
    );

    // ✅ Show preview instead of directly saving
    await Printing.layoutPdf(
      onLayout: (PdfPageFormat format) async => pdf.save(),
      name: "$term-report.pdf",
    ).then((value) {
      controller.isTermResultPDFShow(false);
    },);
  }



  @override
  Widget build(BuildContext context) {
    fetchSchoolData();
    return Scaffold(
      appBar: AppBar(),
      body: SingleChildScrollView(
        physics: BouncingScrollPhysics(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 10.0, right: 10),
              child: Column(
                children: [
                  Row(
                    children: [
                      Obx(() {
                        controller.selectedYear.value;
                        return Expanded(
                          child: CustomDropdown(
                            subjects: controller.yearsList, // <- fixed here
                            selectedValue: controller.selectedYear,
                            dropdownTitle: "Select Year",
                            onSelected: (value) async {
                              controller.selectedYear.value = value;
                              await fetchSchoolData();
                            },
                          ),
                        );
                      }),
                      SizedBox(width: 5,),
                      Obx(() {
                        controller.selectedTerm.value;
                        return Expanded(
                          child: CustomDropdown(
                            subjects: controller.getTermList, // <- fixed here
                            selectedValue: controller.selectedTerm,
                            dropdownTitle: "Select Term",
                          ),
                        );
                      }),
                    ],
                  ),
                  Row(
                    children: [
                      Obx(() {
                        controller.selectedStandard.value;
                        return Expanded(
                          child: CustomDropdown(
                            subjects: controller.standards,
                            selectedValue: controller.selectedStandard,
                            dropdownTitle: "Select Standard",
                            onSelected: (value) async {
                              controller.selectedStandard.value = value;
                              await fetchSchoolData();
                            },
                          ),
                        );
                      }),
                      SizedBox(width: 5,),
                      Obx(() {
                        controller.selectedDivision.value;
                        return Expanded(
                          child: CustomDropdown(
                            subjects: controller.divisions,
                            selectedValue: controller.selectedDivision,
                            dropdownTitle: "Select Division",
                            onSelected: (value) async {
                              controller.selectedDivision.value = value;
                              await fetchSchoolData();
                            },
                          ),
                        );
                      }),
                    ],
                  ),
                ],
              ),
            ),

            SizedBox(height: 10,),
            Center(
              child: Obx(() => controller.isTermResultPDFShow.value ? CircularProgressIndicator() : CustomCard(
                  onTap: () {
                    controller.isTermResultPDFShow(true);
                    _printReport(term: controller.selectedTerm.value);
                  },
                  height: 50,
                  width: SizeConfig.screenWidth * 0.7,
                  color: blackColor,
                  borderRadius: 10,
                  child: Icon(Icons.picture_as_pdf, color: whiteColor,size: 30,)
              ),),
            ),
          ],
        ),
      ),
    );
  }
}

