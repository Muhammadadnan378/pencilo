import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
import 'package:pencilo/data/current_user_data/current_user_Data.dart';

import '../data/consts/const_import.dart';
import '../model/create_event_model.dart';

class TeacherHomeViewController extends GetxController{

  ///Events methods and variables
  RxBool isSelectEvent = true.obs;
  RxBool isLoading = false.obs;
  RxBool isSelectCityEmpty = false.obs;
  RxBool isSelectStateEmpty = false.obs;
  RxBool isSelectEventEmpty = false.obs;
  EventModel? eventsModel;
  RxInt selectedHours = 0.obs; // to store selected hours
  RxInt selectedMinutes = 0.obs; // to store selected minutes
  RxString selectAmPm = "AM".obs; // to store selected minutes
  RxString time = "".obs;
  RxString selectedDateTime = "".obs;
  RxString selectedEventType = ''.obs;
  RxString selectedCity = ''.obs;
  RxString selectedState = ''.obs;
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

// Define controllers
  final TextEditingController nameController = TextEditingController();
  final TextEditingController schoolNameController = TextEditingController();
  final TextEditingController entryFeeController = TextEditingController();
  final TextEditingController winnerAmountController = TextEditingController();
  final TextEditingController contactNumberController = TextEditingController();
  final TextEditingController rulesController = TextEditingController();
  // List of event types (sports games)
  List<String> eventTypes = [
    'Cricket', 'Football', 'Basketball', 'Baseball', // Already included
    'Badminton', 'Table Tennis', 'Tennis', 'Hockey', 'Volleyball',
    'Kabaddi', 'KhoKho', 'Dance', 'Drawing', 'Reels',
    'Singing', 'PUBG', 'FreeFire', 'BGMI', 'Run',
  ];
  List<String> states = [
    'Andhra Pradesh', 'Arunachal Pradesh', 'Assam', 'Bihar',
    'Chhattisgarh', 'Goa', 'Gujarat', 'Haryana', 'Himachal Pradesh', 'Jharkhand',
    'Karnataka', 'Kerala', 'Madhya Pradesh', 'Maharashtra', 'Manipur', 'Meghalaya',
    'Mizoram', 'Nagaland', 'Odisha', 'Punjab', 'Rajasthan', 'Sikkim',
    'Tamil Nadu', 'Telangana', 'Uttar Pradesh', 'Uttarakhand', 'West Bengal'
  ];

  List<String> cities = [
    'Delhi', 'Mumbai',
    'Kolkata', 'Chennai', 'Bangalore', 'Hyderabad', 'Pune', 'Ahmedabad',
    'Jaipur', 'Lucknow', 'Visakhapatnam', 'Vijayawada', 'Guntur', 'Mysore',
    'Mangalore', 'Nagpur', 'Coimbatore', 'Madurai', 'Trichy', 'Kanpur',
    'Agra', 'Noida', 'Vadodara', 'Rajkot', 'Udaipur', 'Jodhpur', 'Patna',
    'Gaya', 'Bhagalpur', 'Muzaffarpur', 'Silchar', 'Durgapur', 'Asansol'
  ];

  // Function to pick date of birth
  Future<void> pickDateOfBirth(BuildContext context) async {
    DateTime today = DateTime.now();

    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: today,
      firstDate: today, // Prevent selection of past dates
      lastDate: DateTime(2100), // Arbitrary far future limit
    );

    if (pickedDate != null) {
      selectedDateTime.value = DateFormat('dd/MM/yyyy').format(pickedDate);
    }
  }


  validate() {
    // Validation for required fields
    if (nameController.text.isEmpty ||
        schoolNameController.text.isEmpty ||
        entryFeeController.text.isEmpty ||
        winnerAmountController.text.isEmpty ||
        contactNumberController.text.isEmpty ||
        selectedDateTime.value.isEmpty ||
        selectedEventType.isEmpty ||
        selectedCity.value.isEmpty ||
        selectedState.value.isEmpty ||
        selectedHours.value == 0 &&
        selectedMinutes.value == 0) {

      return false; // Prevent further execution if any required field is empty
    } else {
      return true;
    }
  }

  checkValidatFields(BuildContext context) {
    // Check if any of the required fields are empty
    if (selectedEventType.value.isEmpty || selectedCity.value.isEmpty || selectedState.value.isEmpty) {
      if (selectedEventType.value.isEmpty) {
        isSelectEventEmpty.value = true;
      }
      if (selectedCity.value.isEmpty) {
        isSelectCityEmpty.value = true;
      }
      if (selectedState.value.isEmpty) {
        isSelectStateEmpty.value = true;
      }
    }
  }


  // Method to create an event and add it to Firestore
  Future<void> createEvent(BuildContext context) async {
    String time = "$selectedHours:${selectedMinutes.toString().padLeft(2, '0')} $selectAmPm";
    String eventId = DateTime.now().millisecondsSinceEpoch.toString();
    try {
      // Create the EventModel object from the controller data
      EventModel event = EventModel(
        userId: CurrentUserData.uid,
        eventId: eventId,
        time: time,
        selectedEventType: selectedEventType.value,
        selectedCity: selectedCity.value,
        selectedState: selectedState.value,
        name: nameController.text,
        schoolName: schoolNameController.text,
        entryFee: entryFeeController.text,
        winnerAmount: winnerAmountController.text,
        contactNumber: contactNumberController.text,
        rules: rulesController.text,
        selectedDateTime: selectedDateTime.value,
        participants: []
      );

      // Convert the event object to a map
      Map<String, dynamic> eventData = event.toMap();

      // Add the event to Firestore
      await _firestore.collection('events').doc(eventId).set(eventData);

      // Optionally, show a success message or handle post-creation actions
      Get.snackbar("Success", "Event Created successfully!",);
      debugPrint('Event created successfully!');
      clearValues();
    } catch (e) {
      // Handle errors, show an error message, or log the error
      Get.snackbar("Error", "Update: $e",);
      debugPrint('Error creating event: $e');
    }
  }
  Future<void> updateEvent(BuildContext context) async {
    String time = "$selectedHours:${selectedMinutes.toString().padLeft(2, '0')} $selectAmPm";
    try {
      // Create the EventModel object from the controller data
      EventModel event = EventModel(
        userId: CurrentUserData.uid,
        eventId: eventsModel!.eventId,
        time: eventsModel!.time != time ? time : eventsModel!.time,
        selectedEventType: selectedEventType.value,
        selectedCity: selectedCity.value,
        selectedState: selectedState.value,
        name: nameController.text,
        schoolName: schoolNameController.text,
        entryFee: entryFeeController.text,
        winnerAmount: winnerAmountController.text,
        contactNumber: contactNumberController.text,
        rules: rulesController.text,
        selectedDateTime: selectedDateTime.value,
        participants: eventsModel!.participants
      );

      // Convert the event object to a map
      Map<String, dynamic> eventData = event.toMap();

      // Add the event to Firestore
      await _firestore.collection('events').doc(eventsModel!.eventId).update(eventData);

      // Optionally, show a success message or handle post-creation actions
      Get.snackbar("Success", "Event update successfully!",);
      debugPrint('Event update successfully!');
      clearValues();
      eventsModel = null;
    } catch (e) {
      // Handle errors, show an error message, or log the error
      Get.snackbar("Error", "Update:  $e",);
      debugPrint('Error update event: $e');
    }
  }
  Future<void> deleteEvent(BuildContext context, String eventId) async {
    try {
      // Delete the event from Firestore
      await _firestore.collection('events').doc(eventId).delete();
    }on FirebaseException catch (e) {
      // Handle errors, show an error message, or log the error
      Get.snackbar("Error", "Delete: $e",);
      debugPrint('Error delete event: $e');
    }
  }




  // Method to clear all values after event creation
  void clearValues() {
    // Reset all controllers
    nameController.clear();
    schoolNameController.clear();
    entryFeeController.clear();
    winnerAmountController.clear();
    contactNumberController.clear();
    rulesController.clear();
    selectedDateTime.value = "";
    time.value = '';
    isSelectCityEmpty.value = false;
    isSelectStateEmpty.value = false;
    isSelectEventEmpty.value = false;
    // Reset all reactive variables
    selectedEventType.value = '';
    selectedCity.value = '';
    selectedState.value = '';
    selectedHours.value = 0; // Default hour
    selectedMinutes.value = 0; // Default minute
    selectAmPm.value = 'AM'; // Default AM/PM
  }

}