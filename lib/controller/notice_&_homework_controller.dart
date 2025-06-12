import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'package:pencilo/data/consts/const_import.dart';
import 'package:pencilo/db_helper/model_name.dart';
import '../../../../data/current_user_data/current_user_Data.dart';
import '../../../../model/notice_&_homework_model.dart';

class NotesNHomeWorkController extends GetxController {
  final Rx<File?> selectedImage = Rx<File?>(null);
  final standardsList = ['4th', '5th', '6th', '7th', '8th', '9th', '10th'];
  final divisionsList = ['A', 'B', 'C', 'D', 'E', 'F', 'G', 'H', 'I', 'J'];
  RxBool uploadingNotice = false.obs;
  RxBool isHomeWork = false.obs;
  final RxList<String> selectedStandards = <String>[].obs;
  final RxList<String> selectedDivision = <String>[].obs;
  TextEditingController titleController = TextEditingController();
  TextEditingController noteController = TextEditingController();

  Future<void> pickImageFromSource(ImageSource source) async {
    final ImagePicker picker = ImagePicker();
    final XFile? imageFile = await picker.pickImage(source: source);
    if (imageFile != null) {
      selectedImage.value = File(imageFile.path);
    }
  }

  Future<bool> validateForm() async {
    // Check if the required fields are filled
    if (titleController.text.isEmpty || noteController.text.isEmpty || selectedStandards.isEmpty || selectedDivision.isEmpty){
      Get.snackbar("Error", 'Please fill all the required fields.', colorText: whiteColor, backgroundColor: Colors.red);
      return false;
    }else{
      return true;
    }
  }

  Future<void> uploadNotice() async {
    String? imageUrl;

    // // Upload image to Firebase Storage if selected
    if (selectedImage.value != null) {
      final fileName = '${DateTime.now().millisecondsSinceEpoch}.jpg';
      final storageRef = FirebaseStorage.instance.ref().child('${isHomeWork.value == true ? "homeWork_images" : "notes_images"}/$fileName');
      await storageRef.putFile(selectedImage.value!);
      imageUrl = await storageRef.getDownloadURL();
    }

    for (var std in selectedStandards) {
      for (var div in selectedDivision) {
        String noticeId = DateTime.now().millisecondsSinceEpoch.toString();

        // Create notice model
        final notice = NoticeHomeWorkModel(
          teacherUid: CurrentUserData.uid,
          teacherName: CurrentUserData.name,
          noticeId: noticeId,
          title: titleController.text.trim(),
          note: noteController.text.trim(),
          standard: std,
          division: div,
          noticeIsWatched: [],
          imageUrl: imageUrl,
          createdAt: DateTime.now(),
        );


        try {
          await FirebaseFirestore.instance
              .collection(isHomeWork.value == true ? homeWorkTableName : noticeTableName)
              .doc(noticeId)
              .set(isHomeWork.value == true ? notice.toHomeWork() : notice.toNotice());
        }on FirebaseFirestore catch (e) {
          debugPrint("Error uploading to FireStore: $e");
          Get.snackbar("Upload Error", 'Something went wrong: ${e.toString()}', colorText: whiteColor, backgroundColor: Colors.red);
        }

        // // Get students of the matching std and div
        // final studentsSnapshot = await FirebaseFirestore.instance
        //     .collection(studentTableName)
        //     .where("standard", isEqualTo: std)
        //     .where("division", isEqualTo: div)
        //     .get();

        // try {
        //   for (var student in studentsSnapshot.docs) {
        //     final data = student.data();
        //     String pushToken = data["pushToken"] ?? "";
        //     debugPrint("$std $div PushToken $pushToken");
        //     // Send the push notification using the push token
        //     if (pushToken.isNotEmpty) {
        //       await SendNotificationService.sendNotificationUsingApi(
        //         token: pushToken,
        //         title: "${CurrentUserData.name} shared a new note",
        //         body: "Tap to view the notification",
        //         data: {
        //           "screen": "NotificationView", // This is for navigation when tapped
        //         },
        //       );
        //     }
        //     pushToken = "";
        //   }
        // } on FirebaseFirestore catch (e) {
        //   debugPrint("Error uploading to FireStore: $e");
        //   Get.snackbar("Upload Error", 'Something went wrong: ${e.toString()}', colorText: whiteColor, backgroundColor: Colors.red);
        // }
      }
    }

    Get.back();

    Get.snackbar("Success", 'Note uploaded successfully.', colorText: whiteColor, backgroundColor: Colors.green);

    // Optional: Clear form fields
    titleController.clear();
    noteController.clear();
    selectedImage.value = null;
    selectedStandards.clear();
    selectedDivision.clear();

  }
}
