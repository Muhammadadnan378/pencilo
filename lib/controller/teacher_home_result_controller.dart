import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';
import '../data/consts/const_import.dart';
import '../data/current_user_data/current_user_Data.dart';
import '../db_helper/model_name.dart';
import '../model/result_subjects_model.dart';
import '../model/school_model.dart';
import '../view/home_view/teacher_home_cards_view/results_view/submit_result_view.dart';

class ResultController extends GetxController {
  var schoolLogo = ''.obs;
  var classTeacherSignature = ''.obs;
  var principalSignature = ''.obs;
  var selectedSchoolName = ''.obs;
  var checkDataLoading = false.obs;
  var isLoading = false.obs;
  var isEditing = false.obs;
  var isCurrentSchoolFormFilled = false.obs;
  var schoolId = "".obs;
  var schoolList = <SchoolModel>[].obs;

  final contactNumberController = TextEditingController();
  final schoolAddressController = TextEditingController();
  final alternativeNumberSchoolController = TextEditingController();
  final websiteLinkController = TextEditingController();

  final standardsList = ['4th', '5th', '6th', '7th', '8th', '9th', '10th'];
  final divisionsList = ['A', 'B', 'C', 'D', 'E', 'F', 'G', 'H', 'I', 'J'];
  final List<Color> bgColors = [
    Color(0xff44AC47),
    Color(0xff2A26FF),
    Color(0xff4488AC),
    Color(0xff4465AC),
    Color(0xffAC4444),
    Color(0xffAC9E44),
  ];

  final formKey = GlobalKey<FormState>();

  Future<String?> uploadToStorage(String filePath, String storagePath) async {
    try {
      File file = File(filePath);
      if (file.existsSync()) {
        var ref = FirebaseStorage.instance.ref().child(storagePath);
        await ref.putFile(file);
        return await ref.getDownloadURL(); // Return the uploaded file URL
      }
    } catch (e) {
      print("Error uploading $storagePath: $e");
    }
    return null;
  }

  Future<void> pickImage(RxString imagePath) async {
    final pickedFile = await ImagePicker().pickImage(
        source: ImageSource.gallery);
    if (pickedFile != null) {
      imagePath.value = pickedFile.path;
    }
  }
  //Clear data fields
  void clearDataFields() {
    schoolId.value = '';
    contactNumberController.clear();
    schoolAddressController.clear();
    alternativeNumberSchoolController.clear();
    websiteLinkController.clear();
    schoolLogo.value = '';
    classTeacherSignature.value = '';
    principalSignature.value = '';
  }
  //Check current school information logics
  Future<void> checkCurrentSchoolForm() async {
    checkDataLoading(true);
    final schoolData = await FirebaseFirestore.instance.collection(schoolTableName).where("schoolName", isEqualTo: CurrentUserData.schoolName).get();
    if (schoolData.docs.isNotEmpty) {
      isCurrentSchoolFormFilled(true);
      schoolList.value = schoolData.docs.map((doc) => SchoolModel.fromJson(doc.data())).toList();
      checkDataLoading(false);
    } else {
      isCurrentSchoolFormFilled(false);
      checkDataLoading(false);
    }
  }
  //Update school information logics
  Future<void> updateSchool() async {
    if (schoolList.isEmpty) {
      Get.snackbar('Error', 'No school data available to update');
      return;
    }

    isLoading(true);
    final existingSchool = schoolList.first;
    schoolId.value = existingSchool.schoolId;

    String? logoUrl = existingSchool.schoolLogo;
    String? teacherSignatureUrl = existingSchool.classTeacherSignature;
    String? principalSignatureUrl = existingSchool.principalSignature;

    // If new images are selected, upload them
    if (schoolLogo.value.isNotEmpty && !schoolLogo.value.startsWith('http')) {
      logoUrl = await uploadToStorage(schoolLogo.value, "${CurrentUserData.schoolName}/school_logo/${schoolId.value}.png");
    }
    if (classTeacherSignature.value.isNotEmpty && !classTeacherSignature.value.startsWith('http')) {
      teacherSignatureUrl = await uploadToStorage(classTeacherSignature.value, "${CurrentUserData.schoolName}/teacher_signature/${schoolId.value}.png");
    }
    if (principalSignature.value.isNotEmpty && !principalSignature.value.startsWith('http')) {
      principalSignatureUrl = await uploadToStorage(principalSignature.value, "${CurrentUserData.schoolName}/principal_signature/${schoolId.value}.png");
    }

    if (formKey.currentState!.validate()) {
      final updatedData = SchoolModel(
        schoolId: schoolId.value,
        schoolName: CurrentUserData.schoolName,
        contactNumber: contactNumberController.text,
        schoolAddress: schoolAddressController.text,
        schoolLogo: logoUrl ?? "",
        classTeacherSignature: teacherSignatureUrl ?? "",
        principalSignature: principalSignatureUrl ?? "",
        alternativeNumberSchool: alternativeNumberSchoolController.text,
        websiteLink: websiteLinkController.text,
      );

      try {
        await FirebaseFirestore.instance
            .collection(schoolTableName)
            .doc(CurrentUserData.schoolName)
            .update(updatedData.toJson());

        clearDataFields();
        checkCurrentSchoolForm();
        isLoading(false);
        isCurrentSchoolFormFilled(true);
        Get.snackbar('Success', 'School updated successfully');
      } catch (e) {
        isLoading(false);
        Get.snackbar('Error', 'Failed to update school: $e');
      }
    } else {
      isLoading(false);
    }
  }
  ///Add school information logics
  RxString theoryMarks = "".obs;
  RxString practicalMarks = "".obs;
  RxString selectedSubject = "".obs;

  Future<void> submitData() async {
    isLoading(true);
    schoolId.value = DateTime.now().millisecondsSinceEpoch.toString();
    String? logoUrl;
    String? teacherSignatureUrl;
    String? principalSignatureUrl;

    if (schoolLogo.value.isNotEmpty) {
      logoUrl = await uploadToStorage(schoolLogo.value, "${CurrentUserData.schoolName}/school_logo/$schoolId.png");
    }
    if (classTeacherSignature.value.isNotEmpty) {
      teacherSignatureUrl = await uploadToStorage(classTeacherSignature.value, "${CurrentUserData.schoolName}/teacher_signature/$schoolId.png");
    }
    if (principalSignature.value.isNotEmpty) {
      principalSignatureUrl = await uploadToStorage(principalSignature.value, "${CurrentUserData.schoolName}/principal_signature/$schoolId.png");
    }

    if (formKey.currentState!.validate()) {
      final schoolData = SchoolModel(
        schoolId: schoolId.value,
        schoolName: CurrentUserData.schoolName,
        contactNumber: contactNumberController.text,
        schoolAddress: schoolAddressController.text,
        schoolLogo: logoUrl ?? "",
        classTeacherSignature: teacherSignatureUrl ?? "",
        principalSignature: principalSignatureUrl ?? "",
        alternativeNumberSchool: alternativeNumberSchoolController.text,
        websiteLink: websiteLinkController.text,
      );

      try {
        await FirebaseFirestore.instance.collection(schoolTableName).doc(CurrentUserData.schoolName).set(schoolData.toJson());
        isLoading(false);
        clearDataFields();
        isCurrentSchoolFormFilled(true);
        Get.snackbar('Success', 'School created successfully');
      } on FirebaseFirestore catch (e) {
        Get.snackbar('Error', 'Failed to create school: $e');
      } finally {
        isLoading(false);
      }
    }
  }

  ///Edit result information logics
  RxList<TextEditingController> subjectListControllers = <TextEditingController>[].obs;
  RxList<TextEditingController> marksListControllers = <TextEditingController>[].obs;
  RxList<TextEditingController> practicalMarksListControllers = <TextEditingController>[].obs;

  TextEditingController totalTheoryMarksController = TextEditingController();
  TextEditingController totalPracticalMarksController = TextEditingController();

  List<String> getPracticalMarksList = [];
  List<String> getSubjectNameList = [];
  List<String> getMarksList = [];
  List<String> getTermList = ["Unit Term I","Unit Term II","Midterm I","Midterm II","Final Term"];
  final selectedStandard = ''.obs;
  final selectedDivision = ''.obs;
  final selectedTerm = ''.obs;
  RxBool isUploadSubjects = false.obs;
  RxBool isSavedSubjectMarks = false.obs;
  RxString resultSubjectId = ''.obs;
  FocusNode focusNode = FocusNode();
  // Update text fields
  String studentResultId = "";


  @override
  void onInit() {
    super.onInit();
    // Add 2 default fields
    addNewSubjectField();
    addNewSubjectField();
  }

  void addNewSubjectField() {
    subjectListControllers.add(TextEditingController());
    marksListControllers.add(TextEditingController());
    practicalMarksListControllers.add(TextEditingController());
  }

  void removeSubjectField(int index) {
    if (subjectListControllers.length > 1) {
      subjectListControllers.removeAt(index);
      marksListControllers.removeAt(index);
      practicalMarksListControllers.removeAt(index);
    } else {
      Get.snackbar("Notice", "At least one subject is required");
    }
  }


  void collectSubjectAndMarks() {
    getSubjectNameList = subjectListControllers.map((c) => c.text.trim()).toList();
    getMarksList = marksListControllers.map((c) => c.text.trim()).toList();
    getPracticalMarksList = practicalMarksListControllers.map((c) => c.text.trim()).toList();
  }


  Future<void> uploadResultSubjects() async {
    String getOnlyYear = DateTime.parse(DateTime.now().toString()).year.toString();

    if(selectedTerm.value.isEmpty){
      isUploadSubjects.value = false;
      Get.snackbar("Notice", "Select Term");
      return;
    }

    String resultId = "";
    if (resultSubjectId.isEmpty) {
      resultId = DateTime.now().millisecondsSinceEpoch.toString();
    }
    collectSubjectAndMarks();

    ResultModel resultModel = ResultModel(
      resultInfoId: resultSubjectId.value.isEmpty ? resultId : resultSubjectId.value, // Implement this
      schoolName: CurrentUserData.schoolName, // Replace with actual source
      standard: selectedStandard.value,
      division: selectedDivision.value,
      subjectNameList: getSubjectNameList,
      theoryMarksList: getMarksList,
      practicalMarksList: getPracticalMarksList,
    );


    try {
      if (resultSubjectId.value.isEmpty) {
        await FirebaseFirestore.instance
            .collection(resultSubjectsTableName)
            .doc(CurrentUserData.schoolName)
            .collection(getOnlyYear).doc(resultId)
            .set(resultModel.resultInfoToMap());
        resultSubjectId.value = resultId;
      }else{
        await FirebaseFirestore.instance
            .collection(resultSubjectsTableName)
            .doc(CurrentUserData.schoolName)
            .collection(getOnlyYear).doc(resultSubjectId.value)
            .update(resultModel.resultInfoToMap());
      }
      isUploadSubjects.value = false;
      Get.to(SubmitResultView(resultSubjectId: resultSubjectId.value,));
    } catch (e) {
      isUploadSubjects.value = false;
      Get.snackbar('Error', 'Failed to save result: $e');
    }finally{
      isUploadSubjects.value = false;
    }
  }

  Future<void> getSubjects() async {
    String getOnlyYear = DateTime.parse(DateTime.now().toString()).year.toString();

    debugPrint("Year:$getOnlyYear");

    resultSubjectId.value = "";
    if (selectedDivision.value.isNotEmpty && selectedStandard.value.isNotEmpty) {
      final resultData = await FirebaseFirestore.instance
          .collection(resultSubjectsTableName).doc(CurrentUserData.schoolName).collection(getOnlyYear)
          .where("schoolName", isEqualTo: CurrentUserData.schoolName)
          .where("standard", isEqualTo: selectedStandard.value)
          .where("division", isEqualTo: selectedDivision.value)
          .get();

      if (resultData.docs.isNotEmpty) {
        final doc = resultData.docs.first;
        final resultModel = ResultModel.fromMap(doc.data());

        // Clear previous controllers
        subjectListControllers.clear();
        marksListControllers.clear();
        practicalMarksListControllers.clear();

        for (int i = 0; i < resultModel.subjectNameList!.length; i++) {
          final subject = resultModel.subjectNameList![i];
          final mark = i < resultModel.theoryMarksList!.length ? resultModel.theoryMarksList![i] : '';
          final practicalMark = i < resultModel.practicalMarksList!.length ? resultModel.practicalMarksList![i] : '';

          subjectListControllers.add(TextEditingController(text: subject));
          marksListControllers.add(TextEditingController(text: mark));
          practicalMarksListControllers.add(TextEditingController(text: practicalMark));

        }

        resultSubjectId.value = doc.id;
        getSubjectNameList = resultModel.subjectNameList!;
        getMarksList = resultModel.theoryMarksList!;

      } else {
        // If no data found, you can choose to clear fields or leave them
        subjectListControllers.clear();
        marksListControllers.clear();
        practicalMarksListControllers.clear();

        addNewSubjectField(); // Add at least one for input
      }
    }
  }

  Future<void> submitResult({
    required String subjectName,
    required String studentName,
    required String studentUid,
    required String div,
    required String std,
    required String rollNo,
    required int totalSubjectMarks,
  }) async {
    String getOnlyYear = DateTime.now().year.toString();

    String resultId = DateTime.now().millisecondsSinceEpoch.toString();
    final String subjectDocId = "$std$div"; // document ID for class level

    final subjectRef = FirebaseFirestore.instance
        .collection(resultSubjectsTableName)
        .doc(CurrentUserData.schoolName)
        .collection(getOnlyYear)
        .doc(resultSubjectId.value)
        .collection("studentsSubject")
        .doc(subjectDocId)
        .collection("studentResults");

    try {
      // ✅ Step 1: Query if the student already has a result for this subject
      final existing = await subjectRef
          .where('studentUid', isEqualTo: studentUid)
          .where('subjectName', isEqualTo: subjectName)
          .where("term", isEqualTo: selectedTerm.value)
          .limit(1)
          .get();

      final schoolData = ResultModel(
        resultSubjectId: existing.docs.isNotEmpty ? existing.docs.first.id : resultId,
        standard: std,
        division: div,
        studentUid: studentUid,
        subjectName: subjectName,
        studentName: studentName,
        schoolName: CurrentUserData.schoolName,
        subjectTheoryMarks: totalTheoryMarksController.text.isEmpty ? '0' : totalTheoryMarksController.text,
        subjectPracticalMarks: totalPracticalMarksController.text.isEmpty ? '0' : totalPracticalMarksController.text,
        term: selectedTerm.value,
        rollNo: rollNo,
        totalSubjectMarks: totalSubjectMarks,
      );

      if (existing.docs.isNotEmpty) {
        // ✅ Update existing document
        await subjectRef.doc(existing.docs.first.id).update(schoolData.resultSubjectToMap());
      } else {
        // ✅ Create new document
        await subjectRef.doc(resultId).set(schoolData.resultSubjectToMap());
      }

      isSavedSubjectMarks.value = false;
      Get.snackbar('Success', 'Result saved successfully');
    } catch (e) {
      isSavedSubjectMarks.value = false;
      Get.snackbar('Error', 'Failed to save result: $e');
    }
  }



  Future<void> getStudentMarks({required String subjectId, required String studentUid,required String div,required String std,required String subjectName}) async {
    String getOnlyYear = DateTime.now().year.toString();

    final subjectRef = FirebaseFirestore.instance
        .collection(resultSubjectsTableName)
        .doc(CurrentUserData.schoolName)
        .collection(getOnlyYear)
        .doc(subjectId).collection("studentsSubject").doc("$std$div")
        .collection("studentResults");

    final querySnapshot = await subjectRef
        .where("studentUid", isEqualTo: studentUid)
        .where("term", isEqualTo: selectedTerm.value)
        .where("subjectName", isEqualTo: subjectName)
        .get();

    if (querySnapshot.docs.isNotEmpty) {
      final doc = querySnapshot.docs.first;
      final resultModel = ResultModel.fromMap(doc.data());

      totalTheoryMarksController.text = resultModel.subjectTheoryMarks ?? "0";
      totalPracticalMarksController.text = resultModel.subjectPracticalMarks ?? "0";
    } else {
      totalTheoryMarksController.text = "";
      totalPracticalMarksController.text = "";
    }
  }

}
