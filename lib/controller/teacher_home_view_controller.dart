import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../data/consts/const_import.dart';

class TeacherHomeViewController extends GetxController{
  RxBool isSelectEvent = true.obs;
  // Assuming the controller contains reactive variables for hours and minutes
  RxInt selectedHours = 1.obs; // to store selected hours
  RxInt selectedMinutes = 1.obs; // to store selected minutes
  RxString selectAmPm = "AM".obs; // to store selected minutes
  // Dropdown values
  RxString selectedEventType = ''.obs;
  RxString selectedCity = ''.obs;
  RxString selectedState = ''.obs;
  final formKey = GlobalKey<FormState>();
// Define controllers
  final TextEditingController nameController = TextEditingController();
  final TextEditingController schoolNameController = TextEditingController();
  final TextEditingController eventLocationController = TextEditingController();
  final TextEditingController entryFeeController = TextEditingController();
  final TextEditingController winnerAmountController = TextEditingController();
  final TextEditingController contactNumberController = TextEditingController();
  final TextEditingController rulesController = TextEditingController();
  final TextEditingController selectedDateTimeController = TextEditingController();

  // Global key for form validation
  // List of event types (sports games)
  List<String> eventTypes = [
    'Cricket', 'Football', 'Basketball', 'Badminton', 'Table Tennis',
    'Tennis', 'Hockey', 'Volleyball', 'Kabaddi', 'Rugby'
  ];

  List<String> states = [
    'Andhra Pradesh',
    'Arunachal Pradesh',
    'Assam',
    'Bihar',
    'Chhattisgarh',
    'Goa',
    'Gujarat',
    'Haryana',
    'Himachal Pradesh',
    'Jharkhand',
    'Karnataka',
    'Kerala',
    'Madhya Pradesh',
    'Maharashtra',
    'Manipur',
    'Meghalaya',
    'Mizoram',
    'Nagaland',
    'Odisha',
    'Punjab',
    'Rajasthan',
    'Sikkim',
    'Tamil Nadu',
    'Telangana',
    'Uttar Pradesh',
    'Uttarakhand',
    'West Bengal'
  ];

  List<String> cities = [
    'Delhi',
    'Mumbai',
    'Kolkata',
    'Chennai',
    'Bangalore',
    'Hyderabad',
    'Pune',
    'Ahmedabad',
    'Jaipur',
    'Lucknow',
    'Visakhapatnam',
    'Vijayawada',
    'Guntur',
    'Mysore',
    'Mangalore',
    'Nagpur',
    'Coimbatore',
    'Madurai',
    'Trichy',
    'Kanpur',
    'Agra',
    'Noida',
    'Vadodara',
    'Rajkot',
    'Udaipur',
    'Jodhpur',
    'Patna',
    'Gaya',
    'Bhagalpur',
    'Muzaffarpur',
    'Silchar',
    'Durgapur',
    'Asansol'
  ];

  // Function to pick date of birth
  Future<void> pickDateOfBirth(BuildContext context) async {
    // Calculate the date 6 years ago from today
    DateTime sixYearsAgo = DateTime.now();

    // Ensure initialDate is not later than lastDate (6 years ago)
    DateTime initialDate = DateTime.now();

    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: initialDate, // Use a valid initial date
      firstDate: DateTime(1900), // This could be the earliest date someone can choose
      lastDate: sixYearsAgo, // The latest date they can pick (6 years ago)
    );

    if (pickedDate != null) {
      selectedDateTimeController.text = DateFormat('dd/MM/yyyy').format(pickedDate);
    }
  }
}