// create friend view controller
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:pencilo/model/create_event_model.dart';

import '../data/consts/const_import.dart';

class FriendViewController extends GetxController{
  final TextEditingController nameController = TextEditingController();
  final TextEditingController schoolNameController = TextEditingController();
  final TextEditingController contactNumberController = TextEditingController();

  RxBool isLoading = false.obs;
  final formKey = GlobalKey<FormState>();

  clearValues(){
    nameController.clear();
    schoolNameController.clear();
    contactNumberController.clear();
  }

  Future<void> joinEvent(BuildContext context,EventModel eventModel) async {
    // Retrieve the current user's data
    String studentName = nameController.text;
    String studentClass = schoolNameController.text;  // You can modify this if needed
    String studentPhone = contactNumberController.text;

    // Create a map for the participant's data
    Map<String, dynamic> participant = {
      'studentName': studentName,
      'studentClass': studentClass,
      'studentPhone': studentPhone,
    };

    try {
      // Add the current user as a participant to the event
      await FirebaseFirestore.instance.collection('events').doc(eventModel.eventId).update({
        'participants': FieldValue.arrayUnion([participant]),
      });
      // Show a success message
      Get.snackbar('Success', 'You have successfully joined the event!', snackPosition: SnackPosition.TOP);
      clearValues();
      // Optionally, navigate to another screen or clear the form fields
      Navigator.pop(context);  // Close the form after successful submission

    } catch (e) {
      // Handle errors, show an error message, or log the error
      print('Error joining event: $e');
      Get.snackbar('Error', 'Something went wrong. Please try again.',
          snackPosition: SnackPosition.BOTTOM);
    }
  }

}